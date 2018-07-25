//
//  CompassViewController.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/3/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GAITrackedViewController.h"

@interface CompassViewController : GAITrackedViewController <CLLocationManagerDelegate>

- (void)startCompass;
@property (strong, nonatomic) UIImageView *arrowImageView;
@end

