//
//  HomeViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/8/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HANavigationController;

@interface HomeViewController : UIViewController <UIGestureRecognizerDelegate>
@property(strong, nonatomic) HANavigationController *navController;
@property(assign, nonatomic) BOOL leftMenuClosed;

- (void)menuAction;
- (IBAction)savedTrailsButtonPressed:(id)sender;
- (IBAction)guidesButtonPressed:(id)sender;

@end
