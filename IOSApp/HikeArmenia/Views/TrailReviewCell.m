//
//  TrailReviewCell.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/30/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailReviewCell.h"
#import "TrailReview.h"
#import "HikeAPI.h"
#import "UIImageView+AFNetworking.h"

@interface TrailReviewCell ()
@property (nonatomic, strong) TrailReview *review;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *reviewText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTextLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewTextLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightConstraint;

@end

@implementation TrailReviewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.avatarHeightConstraint.constant = 35.0f;
        self.reviewText.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:18.0f];
        self.userName.font = [UIFont fontWithName:@"SFUIDisplay-Medium" size:17.0f];
    }
    self.avatar.layer.cornerRadius = self.avatarHeightConstraint.constant / 2;
    self.avatar.clipsToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

- (void)updateWithTrailReview:(TrailReview *)review {
	self.review = review;
	
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize bound  = CGSizeMake([UIScreen mainScreen].bounds.size.width-self.reviewTextLabelLeadingConstraint.constant - self.reviewTextLabelTrailingConstraint.constant, CGFLOAT_MAX);
    CGRect newRect = [review.reviewText boundingRectWithSize:bound
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:self.reviewText.font.pointSize],NSParagraphStyleAttributeName: paragraph}
                                                     context:nil];
    
    self.reviewTextLabelHeightConstraint.constant = ceilf(newRect.size.height);

    
	NSLog(@"user photo = %@",self.review.avatar);
	
	NSURL *url = [NSURL URLWithString:self.review.avatar];
	if(self.review.avatar)
		[self.avatar setImageWithURL:url];
    else
        [self.avatar setImage:[UIImage imageNamed:@"tempAvatar"]];
	
	self.userName.text = [NSString stringWithFormat:@"%@ %@",self.review.firstname,self.review.lastname];
	self.reviewText.text = [NSString stringWithFormat:@"%@",self.review.reviewText];
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
		CGSize textSize = [self.reviewText intrinsicContentSize];
		self.reviewBottomConstraint.constant = 65.0 - self.reviewTopConstraint.constant - ceilf(textSize.height);
	}
}

@end