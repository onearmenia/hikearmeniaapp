//
//  AccomodationViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/3/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GAITrackedViewController.h"

@class Accomodation;

@interface AccomodationViewController : GAITrackedViewController <MFMailComposeViewControllerDelegate> 
@property(strong, nonatomic) Accomodation *accomodation;
@end
