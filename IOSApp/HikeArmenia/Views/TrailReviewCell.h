//
//  TrailReviewCell.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/30/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrailReview;

@interface TrailReviewCell : UITableViewCell
- (void)updateWithTrailReview:(TrailReview *)review;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTextLabelHeightConstraint;
@end
