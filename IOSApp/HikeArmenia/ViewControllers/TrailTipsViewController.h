//
//  TrailTipsViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/29/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trail;

@interface TrailTipsViewController : UIViewController
@property(strong, nonatomic) Trail *trail;

- (void)reloadTips;

@end
