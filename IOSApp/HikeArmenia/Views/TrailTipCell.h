//
//  TrailTipCell.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/29/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrailReview;

@interface TrailTipCell : UITableViewCell
- (void)updateWithTrailTip:(TrailReview *)review;
@end
