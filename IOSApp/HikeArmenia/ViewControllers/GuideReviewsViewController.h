//
//  GuideReviewsViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/23/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GAITrackedViewController.h"

@class Guide;

@interface GuideReviewsViewController : GAITrackedViewController <MFMailComposeViewControllerDelegate>
@property(strong, nonatomic) Guide *guide;
@end
