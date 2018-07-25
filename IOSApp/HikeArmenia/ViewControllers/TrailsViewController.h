//
//  TrailsViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/8/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrailViewCell.h"
#import "TrailDetailViewController.h"
#import "GAITrackedViewController.h"

@interface TrailsViewController : GAITrackedViewController <TrailViewCellDelegate, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
@property (assign, nonatomic) BOOL filterSavedTrails;
@property (assign, nonatomic) BOOL transitionNotUseDefault;

- (void)reloadTrails;
- (void)updateTrailsAnimated:(BOOL)animated;
@end
