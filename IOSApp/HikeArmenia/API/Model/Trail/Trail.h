//
//  Trail.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@class Guides;
@class Accomodations;
@class TrailReviews;
@class TrailReview;
@class TrailRoute;
@class LocationCoordinate;
@class Weather;

@interface Trail : ServiceInvocation

@property (assign, nonatomic)   NSInteger index;
@property (copy, nonatomic)		NSString *name;
@property (copy, nonatomic)     NSString *difficultly;
@property (copy, nonatomic)     NSString *thinksToDo;
@property (copy, nonatomic)		NSString  *info;
@property (strong, nonatomic)	LocationCoordinate *startLocation;
@property (strong, nonatomic)	LocationCoordinate *endLocation;
@property (strong, nonatomic)	TrailRoute *route;
@property (assign, nonatomic)		NSInteger higherPoint;
@property (assign, nonatomic)		NSInteger lowerPoint;
@property (copy, nonatomic)		NSString *temperature;
@property (copy, nonatomic)		NSString *distance;
@property (copy, nonatomic)		NSString *duraion;
@property (copy, nonatomic)		NSString *cover;
@property (strong, nonatomic)	NSArray *covers;
@property (assign, nonatomic)   BOOL isSaved;
@property (assign, nonatomic)   float  averageRating;
@property (assign, nonatomic)   NSInteger reviewCount;
@property (assign, nonatomic)   NSInteger guideCount;
@property (strong, nonatomic)	Guides *guides;
@property (strong, nonatomic)	Accomodations *accomodations;
@property (strong, nonatomic)	TrailReviews *reviews;
@property (strong, nonatomic)	Weather *weather;
@property (copy, nonatomic)		NSString *mapImage;


- (void)loadTrailWithCallback:(ServiceCallback)callback;
- (void)addTrailToSavedListWithCallback:(ServiceCallback)callback;
- (void)removeTrailFromSavedListWithCallback:(ServiceCallback)callback;
- (void)addReview:(NSString *)review withRating:(NSInteger)rating callback:(ServiceCallback)callback;
- (void)loadTrailTipsWithCallback:(ServiceCallback)callback;

@end
