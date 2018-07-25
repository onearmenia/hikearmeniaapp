//
//  GuideViewCell.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/22/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "GuideViewCell.h"
#import "Guide.h"
#import "HikeAPI.h"
#import "UIImageView+AFNetworking.h"
#import "Languages.h"
#import "Language.h"

@interface GuideViewCell ()

@property (nonatomic, strong) Guide *guide;


@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UIView *languagesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *languagesViewheightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneAndMailButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

@end

@implementation GuideViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.phoneAndMailButtonWidthConstraint.constant = 60.0;
    }

 }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithGuide:(Guide *)guide {
	self.guide = guide;
	
	NSLog(@"guide photo = %@",self.guide.photoURL);
	
	NSURL *url = [NSURL URLWithString:self.guide.photoURL];
    self.guideName.adjustsFontSizeToFitWidth = YES;
    self.guideName.minimumScaleFactor = 0.7f;
    [self.avatar setImage:[UIImage imageNamed:@"tempAvatar"]];
	if(self.guide.photoURL)
		[self.avatar setImageWithURL:url];
	
	self.guideName.text = [NSString stringWithFormat:@"%@ %@",self.guide.firstname,self.guide.lastname];
    if (self.guide.reviewCount == 1) {
        self.reviewCountLabel.text = [NSString stringWithFormat:@"( %ld review )",(long)self.guide.reviewCount];
    } else {
        self.reviewCountLabel.text = [NSString stringWithFormat:@"( %ld reviews )",(long)self.guide.reviewCount];
    }
	self.star1.image = (self.guide.averageRating >= 1) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
	self.star2.image = (self.guide.averageRating >= 2) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
	self.star3.image = (self.guide.averageRating >= 3) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
	self.star4.image = (self.guide.averageRating >= 4) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
	self.star5.image = (self.guide.averageRating >= 5) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
    
    UIImage *imagePhone = [[UIImage imageNamed:@"phone"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.phoneButton setImage:imagePhone forState:UIControlStateNormal];
    
    UIImage *imageEmail = [[UIImage imageNamed:@"mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.emailButton setImage:imageEmail forState:UIControlStateNormal];
    
    if (!(guide.phone.length > 0)) {
        self.phoneButton.tintColor = [UIColor lightGrayColor];
    } else {
        self.phoneButton.tintColor = [UIColor colorWithRed:65.0/255.0 green:118.0/255.0 blue:5.0/255.0 alpha:1.0];
    }
    if (!(guide.email.length > 0)) {
        self.emailButton.tintColor = [UIColor lightGrayColor];
        
    } else {
        self.emailButton.tintColor = [UIColor colorWithRed:65.0/255.0 green:118.0/255.0 blue:5.0/255.0 alpha:1.0];
    }

    [self configureLanguagesView];
}

- (void)configureLanguagesView {
    double langIconLeading = 0.0;
    double langImgSize = 18.0;
    double langImgSpacing = 5.0;
    [self.languagesView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    for (int i = 0; i<self.guide.languages.languageArray.count; i++) {
        UIImageView *langImgView = [[UIImageView alloc] init];
        [langImgView setImageWithURL:[NSURL URLWithString:[self.guide.languages.languageArray[i] imageUrl]]];
        [self.languagesView addSubview:langImgView];
        langImgView.translatesAutoresizingMaskIntoConstraints = NO;
        [langImgView addConstraint:[NSLayoutConstraint constraintWithItem:langImgView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute 
                                                        multiplier:1.0 
                                                          constant:langImgSize]];
        [langImgView addConstraint:[NSLayoutConstraint constraintWithItem:langImgView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:langImgSize]];
        [self.languagesView addConstraint:[NSLayoutConstraint constraintWithItem:langImgView
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.languagesView
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1.0
                                                                 constant:langIconLeading]];
        [self.languagesView addConstraint:[NSLayoutConstraint constraintWithItem:langImgView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.languagesView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:0]];
        langIconLeading += langImgSize+langImgSpacing;
    }
    
    if (self.guide.languages.languageArray.count < 1) {
        self.languagesViewheightConstraint.constant = 0;
    } else {
        self.languagesViewheightConstraint.constant = 18.0f;
    }
}

- (IBAction)emailButtonPressed:(id)sender {
	[self.delegate emailGuideWithIndex:self.guide.index];
}

- (IBAction)phoneButtonPressed:(id)sender {
	[self.delegate callGuideWithIndex:self.guide.index];
}

@end
