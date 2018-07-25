//
//  PathTracker.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/28/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol PathTrackerDelegate <NSObject>
- (void)userLocationUpdated;
@end

@interface PathTracker : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray *coordinates;
@property (weak, nonatomic) id<PathTrackerDelegate> delegate;

@property (assign, nonatomic) BOOL isTracking;

+ (id)sharedPathTracker;

- (void)startTracking;
- (void)stopTracking;

@end
