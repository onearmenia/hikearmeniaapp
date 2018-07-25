//
//  TrailMO.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/9/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Trail.h"
#import "GuidesMO.h"
#import "AccomodationsMO.h"
#import "TrailReviewsMO.h"
#import "WeatherMO.h"
#import "LocationCoordinateMO.h"
#import "TrailRouteMO.h"

@interface TrailMO : NSManagedObject

@property (assign, nonatomic)   NSNumber *index;
@property (copy, nonatomic)		NSString *name;
@property (copy, nonatomic)     NSString *difficultly;
@property (copy, nonatomic)     NSString *thinksToDo;
@property (copy, nonatomic)		NSString  *info;
@property (strong, nonatomic)	LocationCoordinateMO *startLocation;
@property (strong, nonatomic)	LocationCoordinateMO *endLocation;
@property (strong, nonatomic)	TrailRouteMO *route;
@property (assign, nonatomic)		NSNumber *higherPoint;
@property (assign, nonatomic)		NSNumber *lowerPoint;
@property (copy, nonatomic)		NSString *temperature;
@property (copy, nonatomic)		NSString *distance;
@property (copy, nonatomic)		NSString *duraion;
@property (copy, nonatomic)		NSString *cover;
@property (strong, nonatomic)	NSArray *covers;
@property (assign, nonatomic)   BOOL isSaved;
@property (assign, nonatomic)   float  averageRating;
@property (assign, nonatomic)   NSNumber *reviewCount;
@property (assign, nonatomic)   NSNumber *guideCount;
@property (strong, nonatomic)	GuidesMO *guides;
@property (strong, nonatomic)	AccomodationsMO *accomodations;
@property (strong, nonatomic)	TrailReviewsMO *reviews;
@property (strong, nonatomic)	WeatherMO *weather;
@property (copy, nonatomic)		NSString *mapImage;

-(Trail *)trailMOtoTrail;
-(TrailMO *)updateWithTrail:(Trail *)trail;

@end
