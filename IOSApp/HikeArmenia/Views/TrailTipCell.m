//
//  TrailTipCell.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/29/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailTipCell.h"
#import "TrailReview.h"
#import "HikeAPI.h"
#import "UIImageView+AFNetworking.h"

@interface TrailTipCell ()
@property (nonatomic, strong) TrailReview *review;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *reviewText;

@end

@implementation TrailTipCell

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
	self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
	self.avatar.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (void)updateWithTrailTip:(TrailReview *)review {
	self.review = review;
	
	NSLog(@"user photo = %@",self.review.avatar);
	
	NSURL *url = [NSURL URLWithString:self.review.avatar];
	if(self.review.avatar)
		[self.avatar setImageWithURL:url];
    else
        [self.avatar setImage:[UIImage imageNamed:@"tempAvatar"]];
	
	self.userName.text = [NSString stringWithFormat:@"%@ %@",self.review.firstname,self.review.lastname];
	self.reviewText.text = [NSString stringWithFormat:@"%@",self.review.reviewText];
}

@end
