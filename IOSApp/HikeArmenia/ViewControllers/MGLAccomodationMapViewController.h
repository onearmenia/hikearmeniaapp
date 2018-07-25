//
//  MGLAccomodationMapViewController.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 9/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/MGLMapView.h>
#import "GAITrackedViewController.h"
#import <Mapbox/MGLCalloutView.h>
#import "Accomodation.h"

@interface MGLAccomodationMapViewController : GAITrackedViewController <MGLMapViewDelegate, MGLCalloutViewDelegate>

@property (assign, nonatomic) BOOL isEmbed;
@property (strong, nonatomic) Accomodation *accomodation;
@end
