//
//  TrailViewCell.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/19/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailViewCell.h"
#import "Trail.h"
#import "HikeAPI.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+Additions.h"
#import "TrailMO.h"

@interface TrailViewCell ()

@property (nonatomic, strong) TrailMO *trailMO;
@property (nonatomic, strong) Trail *trail;

@property (weak, nonatomic) IBOutlet UILabel *trailName;
@property (weak, nonatomic) IBOutlet UILabel *dificultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@end

@implementation TrailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.trailName.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:30.0];
    }

    
    if (self.isOffline) {
        self.saveButton.hidden = YES;
    } else {
        self.saveButton.hidden = NO;
    }
    
    //self.trailImageOverlayView.backgroundColor = [UIColor clearColor];
    self.trailImageOverlayView.image = [UIImage imageNamed:@"gradient"];
    ///self.trailImageOverlayView.alpha = 0.7f;
    self.trailImageOverlayView.userInteractionEnabled = NO;
    //[UIView addGradientBottomToView:self.trailImageOverlayView];
    self.trailName.adjustsFontSizeToFitWidth = YES;
    self.trailName.minimumScaleFactor = 0.7f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithTrailMO:(TrailMO *)trail {
	self.trailMO = trail;
    
    if (self.isOffline) {
        self.saveButton.hidden = YES;
    } else {
        self.saveButton.hidden = NO;
    }

	
    if ([trail respondsToSelector:NSSelectorFromString(@"cover")]) {
        if (trail.cover && trail.cover.length > 0) {
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:trail.cover]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            
            [self.thumbImageView setImageWithURLRequest:imageRequest
                                     placeholderImage:[UIImage imageNamed:@"placeholderForTrail"]
                                              success:nil
                                              failure:nil];
        } else {
            [self.thumbImageView setImage:[UIImage imageNamed:@"placeholderForTrail"]];
        }
    } else {
        [self.thumbImageView setImage:[UIImage imageNamed:@"placeholderForTrail"]];
    }
    
    if ([trail respondsToSelector:NSSelectorFromString(@"name")]) {
        self.trailName.text = self.trailMO.name;
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"difficultly")]) {
        self.dificultyLabel.text = self.trailMO.difficultly;
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"distance")]) {
        self.lengthLabel.text = self.trailMO.distance;
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"duraion")]) {
        self.durationLabel.text = self.trailMO.duraion;
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"reviewCount")]) {
        if ([self.trailMO.reviewCount isEqualToNumber:[NSNumber numberWithInteger:1]]) {
            self.reviewCountLabel.text = [NSString stringWithFormat:@"( %ld review )",(long)[self.trailMO.reviewCount integerValue]];
        } else {
            self.reviewCountLabel.text = [NSString stringWithFormat:@"( %ld reviews )",(long)[self.trailMO.reviewCount integerValue]];
        }
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"averageRating")]) {
        self.star1.image = (self.trailMO.averageRating >= 1) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
        self.star2.image = (self.trailMO.averageRating >= 2) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
        self.star3.image = (self.trailMO.averageRating >= 3) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
        self.star4.image = (self.trailMO.averageRating >= 4) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
        self.star5.image = (self.trailMO.averageRating >= 5) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"isSaved")]) {
        self.saveButton.selected = self.trailMO.isSaved ? YES : NO;
    }
	
	///	self.distanceLabel.text = ???;
}


- (void)updateWithTrail:(Trail *)trail {
    self.trail = trail;
    
    if ([trail respondsToSelector:NSSelectorFromString(@"cover")]) {
        NSLog(@"trail cover = %@",self.trail.cover);
        //self.thumbImageView.image = [UIImage imageNamed:@"placeholderForTrail"];
        if(self.trail.cover) {
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.trail.cover]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            
            [self.thumbImageView setImageWithURLRequest:imageRequest
                                     placeholderImage:[UIImage imageNamed:@"placeholderForTrail"]
                                              success:nil
                                              failure:nil];            
        }
        else {
            [self.thumbImageView setImage:[UIImage imageNamed:@"placeholderForTrail"]];
        }
    } else {
        [self.thumbImageView setImage:[UIImage imageNamed:@"placeholderForTrail"]];
    }
    
    if ([trail respondsToSelector:NSSelectorFromString(@"name")]) {
        self.trailName.text = self.trail.name;
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"difficultly")]) {
        self.dificultyLabel.text = self.trail.difficultly;
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"distance")]) {
        self.lengthLabel.text = self.trail.distance;
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"duraion")]) {
        self.durationLabel.text = self.trail.duraion;
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"reviewCount")]) {
        if (self.trail.reviewCount == 1) {
            self.reviewCountLabel.text = [NSString stringWithFormat:@"( %ld review )",(long)self.trail.reviewCount];
        } else {
            self.reviewCountLabel.text = [NSString stringWithFormat:@"( %ld reviews )",(long)self.trail.reviewCount];
        }
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"averageRating")]) {
        self.star1.image = (self.trail.averageRating >= 1) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
        self.star2.image = (self.trail.averageRating >= 2) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
        self.star3.image = (self.trail.averageRating >= 3) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
        self.star4.image = (self.trail.averageRating >= 4) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
        self.star5.image = (self.trail.averageRating >= 5) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    }
    if ([trail respondsToSelector:NSSelectorFromString(@"isSaved")]) {
        self.saveButton.selected = self.trail.isSaved ? YES : NO;
    }
    
    ///	self.distanceLabel.text = ???;
}


- (void)updateSavedState:(BOOL)option {
	self.saveButton.selected = option ? YES : NO;
}

- (IBAction)saveButtonPressed:(id)sender {
	[self.delegate saveTrailWithIndex:self.trail.index];
}

@end
