//
//  MGLMapViewController.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/30/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/MGLMapView.h>
#import "PathTracker.h"
#import <Mapbox/MGLCalloutView.h>
#import "PathTracker.h"
#import "OfflineTrailsViewController.h"
#import "GAITrackedViewController.h"

@interface MGLMapViewController : GAITrackedViewController <MGLMapViewDelegate, MGLCalloutViewDelegate, CLLocationManagerDelegate, PathTrackerDelegate>

@property (strong, nonatomic) NSArray *trails;
@property (assign, nonatomic) BOOL showSavedTrails;
@property (assign, nonatomic) BOOL isOffline;
@property (weak, nonatomic) OfflineTrailsViewController *offlineTrailsViewController;
@end
