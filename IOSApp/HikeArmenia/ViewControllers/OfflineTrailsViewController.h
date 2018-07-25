//
//  OfflineTrailsViewController.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/9/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrailViewCell.h"
#import "GAITrackedViewController.h"

@interface OfflineTrailsViewController : GAITrackedViewController <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, NSFetchedResultsControllerDelegate>

@property (assign, nonatomic) BOOL savedTrailsButtonState;
@property (assign, nonatomic) BOOL transitionNotUseDefault;

- (void)updateTrailsAnimated:(BOOL)animated;

@end
