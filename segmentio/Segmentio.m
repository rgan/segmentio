#include <sys/sysctl.h>

#import <UIKit/UIKit.h>
#import "Segmentio.h"

#define SEGMENTIO_IDENTIFY_URL [NSURL URLWithString:@"https://api2.segment.io/v1/identify"]
#define SEGMENTIO_TRACK_URL [NSURL URLWithString:@"https://api2.segment.io/v1/track"]

@interface Segmentio() <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation Segmentio {
    
}

- (id)initWithSecret:(NSString *)secret {
    
    if (self = [self init]) {
        _secret = secret;
    }
    return self;
}

-(NSDictionary *) getContext {
    NSMutableDictionary *context = [@{} mutableCopy];
    NSMutableDictionary *providersDict = [@{} mutableCopy];
    providersDict[@"all"] = @NO;
    providersDict[@"Mixpanel"] = @YES;
    context[@"providers"] = providersDict;
    context[@"library"] = @"analytics-ios";
    return context;
}

- (void)identify:(NSString *)userId traits:(NSDictionary *)traits {
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
    [payload setValue:traits forKey:@"traits"];
    [payload setValue:userId forKey:@"userId"];
    [payload setValue:self.secret forKey:@"apiKey"];
    payload[@"timestamp"] = [[NSDate date] description];
    [payload setValue:[self getContext] forKey:@"context"];
    
    NSData *payloadData = [NSJSONSerialization dataWithJSONObject:payload
                                                      options:0 error:NULL];
    [self sendData:SEGMENTIO_IDENTIFY_URL data:payloadData];

}

- (void)track:(NSString *)userId event:(NSString *)event properties:(NSDictionary *)properties {
     NSMutableDictionary *payload = [NSMutableDictionary dictionary];
     [payload setValue:properties forKey:@"properties"];
     [payload setValue:event forKey:@"event"];
     [payload setValue:userId forKey:@"userId"];
     [payload setValue:self.secret forKey:@"apiKey"];
     payload[@"timestamp"] = [[NSDate date] description];
     [payload setValue:[self getContext] forKey:@"context"];
     
     NSData *payloadData = [NSJSONSerialization dataWithJSONObject:payload
                                                           options:0 error:NULL];
     [self sendData:SEGMENTIO_TRACK_URL data:payloadData];
}

- (void)sendData:(NSURL *)url data:(NSData *)data {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //[urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:data];
    self.connection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                      delegate:self];
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = (NSHTTPURLResponse *)response;
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    int statusCode = self.response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
        NSLog(@"Success:");
    } else {
        NSLog(@"Failed:%d", statusCode);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed with error");
}

@end
