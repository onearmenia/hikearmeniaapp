//
//  AboutViewController.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 5/4/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import <MessageUI/MessageUI.h>


@interface AboutViewController : GAITrackedViewController <MFMailComposeViewControllerDelegate,UIScrollViewDelegate>
@property (assign, nonatomic) BOOL savedTrailsButtonState;
@end
