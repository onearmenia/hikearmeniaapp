//
//  AddTrailTipViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/1/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class Trail;

@interface AddTrailTipViewController : GAITrackedViewController <UITextViewDelegate>
@property(strong, nonatomic) Trail *trail;

@end
