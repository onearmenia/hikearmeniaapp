//
//  PathTracker.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/28/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "PathTracker.h"
#import "AppDelegate.h"

@interface PathTracker()


@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PathTracker 


+ (id)sharedPathTracker {
    static PathTracker *sharedPathTracker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPathTracker = [[self alloc] init];
    });
    return sharedPathTracker;
}


- (id)init {
    if (self = [super init]) {
        self.coordinates = [[NSMutableArray alloc] init];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationManager.activityType = CLActivityTypeFitness;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)startTracking {
    if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
    {
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    [self.locationManager startUpdatingLocation];
    self.isTracking = YES;
}

- (void)stopTracking {
    [self.locationManager stopUpdatingLocation];
    [self.coordinates removeAllObjects];
    self.isTracking = NO;
}

#pragma CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *latestLoc = [locations lastObject];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latestLoc.coordinate.latitude, latestLoc.coordinate.longitude);
    if (([latestLoc horizontalAccuracy] > 0) && ([latestLoc horizontalAccuracy] < 100)) {
        [self.coordinates addObject:[NSValue valueWithBytes:&loc objCType:@encode(CLLocationCoordinate2D)]];
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            if ([self.delegate respondsToSelector:@selector(userLocationUpdated)]) {
                [self.delegate userLocationUpdated];
            }
        }
    }
}


@end
