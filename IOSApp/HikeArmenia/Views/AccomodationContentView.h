//
//  AccomodationContentView.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/1/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Accomodation;

@interface AccomodationContentView : UIView
- (void)updateWithAccomodation:(Accomodation *)accomodation;
@end
