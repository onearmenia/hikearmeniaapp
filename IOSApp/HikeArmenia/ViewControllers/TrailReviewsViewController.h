//
//  TrailReviewViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/30/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class Trail;

@interface TrailReviewsViewController : GAITrackedViewController
@property(strong, nonatomic) Trail *trail;
@end
