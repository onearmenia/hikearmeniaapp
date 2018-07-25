//
//  MGLTrailMapViewController.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/22/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/MGLMapView.h>
#import "Trail.h"
#import "PathTracker.h"
#import "GAITrackedViewController.h"

@interface MGLTrailMapViewController : GAITrackedViewController <MGLMapViewDelegate, CLLocationManagerDelegate, PathTrackerDelegate>

@property (strong, nonatomic) Trail *trail;
@property (assign, nonatomic) BOOL isOffline;
@end
