//
//  GuideViewCell.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/22/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Guide;

@protocol GuideViewCellDelegate <NSObject>
- (void)emailGuideWithIndex:(NSInteger)index;
- (void)callGuideWithIndex:(NSInteger)index;
@end

@interface GuideViewCell : UITableViewCell
@property (assign, nonatomic) id<GuideViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *guideName;

- (void)updateWithGuide:(Guide *)guide;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@end
