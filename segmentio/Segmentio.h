#import <Foundation/Foundation.h>

@interface Segmentio : NSObject

@property(nonatomic, strong) NSString *secret;

- (void)identify:(NSString *)userId traits:(NSDictionary *)traits;
- (void)track:(NSString *)userId event:(NSString *)event properties:(NSDictionary *)properties;
- (id)initWithSecret:(NSString *)secret;

@end
