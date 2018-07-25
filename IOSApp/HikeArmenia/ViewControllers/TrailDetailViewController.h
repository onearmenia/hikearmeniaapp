//
//  TrailDetailViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/26/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trail.h"
#import "GAITrackedViewController.h"

@class Trail;

@interface TrailDetailViewController : GAITrackedViewController <UIGestureRecognizerDelegate>
@property(strong, nonatomic) Trail *trail;
@property (assign, nonatomic) BOOL savedTrailsButtonState;
@property (assign, nonatomic) BOOL isOffline;
@property (strong, nonatomic) UIImage *tempImage;
@property (strong, nonatomic) NSString *tempImageUrl;
@end
