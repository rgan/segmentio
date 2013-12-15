//
//  AnalyticsViewController.m
//  segmentio
//
//  Created by Rajaram Ganeshan on 12/14/13.
//  Copyright (c) 2013 Rajaram Ganeshan. All rights reserved.
//

#import "AnalyticsViewController.h"

@interface AnalyticsViewController ()

@end

@implementation AnalyticsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Initializing analytics");
    self.segmentio = [[Segmentio alloc] initWithSecret:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendEvents:(UIButton *)sender
{
    
    [self.segmentio identify:@"test1234" traits:@{@"fullName" : @"testuser"}];
    [self.segmentio track:@"test1234" event:@"User Signed In" properties:@{@"eventId" : @"lms.users.session.success.signed_in"}];
}

@end
