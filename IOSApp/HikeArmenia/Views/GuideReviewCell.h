//
//  GuideReviewCell.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/23/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuideReview;

@interface GuideReviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTextLabelHeightConstraint;
- (void)updateWithGuideReview:(GuideReview *)review;
@end
