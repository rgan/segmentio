//
//  AnalyticsViewController.h
//  segmentio
//
//  Created by Rajaram Ganeshan on 12/14/13.
//  Copyright (c) 2013 Rajaram Ganeshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Segmentio.h"

@interface AnalyticsViewController : UIViewController
@property(nonatomic, strong) Segmentio *segmentio;

- (IBAction)sendEvents:(UIButton *)sender;

@end
