//
//  AccomodationContentView.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/1/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "AccomodationContentView.h"
#import "Accomodation.h"
#import "UIImageView+AFNetworking.h"
#import "HikeAPI.h"
#import "Definitions.h"
#import "AppDelegate.h"

@interface AccomodationContentView ()
@property (strong, nonatomic) Accomodation *accomodation;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@end

@implementation AccomodationContentView

- (void)updateWithAccomodation:(Accomodation *)accomodation {
	self.accomodation = accomodation;
	
    NSLog(@"accomodation image url = %@",accomodation.cover);
    if(accomodation.cover) {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:accomodation.cover]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [self.imageView setImageWithURLRequest:imageRequest
                         placeholderImage:[UIImage imageNamed:@"placeholderForTrail"]
                                  success:nil
                                  failure:nil];
    }
		
	
	self.priceLabel.text = accomodation.price;
    self.nameLabel.text = accomodation.name;
    
    self.overlayView.userInteractionEnabled = NO;
    self.overlayView.backgroundColor = [UIColor clearColor];
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];;
    self.overlayView.alpha = 0.7f;
}

@end
