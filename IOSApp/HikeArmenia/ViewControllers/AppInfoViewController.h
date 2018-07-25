//
//  AppInfoViewController.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 5/4/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GAITrackedViewController.h"

@interface AppInfoViewController : GAITrackedViewController < MFMailComposeViewControllerDelegate >
@property (assign, nonatomic) BOOL savedTrailsButtonState;

@end
