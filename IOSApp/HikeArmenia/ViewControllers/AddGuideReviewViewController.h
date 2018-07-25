//
//  AddGuideReviewViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/23/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class Guide;

@interface AddGuideReviewViewController : GAITrackedViewController <UITextViewDelegate>
@property(strong, nonatomic) Guide *guide;
@end
