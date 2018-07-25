//
//  TrailMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/9/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailMO.h"
#import "Trail.h"
#import "Guides.h"
#import "Accomodations.h"
#import "TrailReviews.h"
#import "Weather.h"
#import "LocationCoordinate.h"
#import "TrailRoute.h"

@implementation TrailMO

@dynamic index;
@dynamic name;
@dynamic difficultly;
@dynamic thinksToDo;
@dynamic info;
@dynamic startLocation;
@dynamic endLocation;
@dynamic route;
@dynamic higherPoint;
@dynamic lowerPoint;
@dynamic temperature;
@dynamic distance;
@dynamic duraion;
@dynamic cover;
@dynamic covers;
@dynamic isSaved;
@dynamic averageRating;
@dynamic reviewCount;
@dynamic guideCount;
@dynamic guides;
@dynamic accomodations;
@dynamic reviews;
@dynamic weather;
@dynamic mapImage;

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.index forKey:@"trail_id"];
    [encoder encodeObject:self.name forKey:@"trail_name"];
    [encoder encodeObject:self.difficultly forKey:@"trail_difficulty"];
    [encoder encodeObject:self.thinksToDo forKey:@"trail_things_to_do"];
    [encoder encodeObject:self.info forKey:@"trail_information"];
    
//    self.startLocation = [[LocationCoordinate alloc] init];
//    self.endLocation = [[LocationCoordinate alloc] init];
//    [encoder encodeDouble:self.startLocation.latitude forKey:@"trail_lat_start"];
//    [encoder encodeDouble:self.startLocation.longitude forKey:@"trail_long_start"];
//    [encoder encodeDouble:self.endLocation.latitude forKey:@"trail_lat_end"];
//    [encoder encodeDouble:self.endLocation.longitude forKey:@"trail_long_end"];
    
    [encoder encodeObject:self.lowerPoint forKey:@"trail_min_height"];
    [encoder encodeObject:self.higherPoint forKey:@"trail_max_height"];
    [encoder encodeObject:self.temperature forKey:@"trail_temperature"];
    [encoder encodeObject:self.distance forKey:@"trail_distance"];
    [encoder encodeObject:self.duraion forKey:@"trail_time"];
    [encoder encodeObject:self.cover forKey:@"trail_cover"];
    [encoder encodeObject:self.covers forKey:@"trail_covers"];
    [encoder encodeBool:self.isSaved forKey:@"is_saved"];
    [encoder encodeFloat:self.averageRating forKey:@"average_rating"];
    [encoder encodeObject:self.reviewCount forKey:@"review_count"];
    [encoder encodeObject:self.guideCount forKey:@"guide_count"];
    [encoder encodeObject:self.guides forKey:@"guides"];
    [encoder encodeObject:self.weather forKey:@"weather"];
    [encoder encodeObject:self.accomodations forKey:@"accommodations"];
    [encoder encodeObject:self.reviews forKey:@"reviews"];
    [encoder encodeObject:self.route forKey:@"trail_route"];
    [encoder encodeObject:self.mapImage forKey:@"trail_map_image"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.index = [decoder decodeObjectForKey:@"trail_id"];
        self.name = [decoder decodeObjectForKey:@"trail_name"];
        self.difficultly = [decoder decodeObjectForKey:@"trail_difficulty"];
        self.thinksToDo = [decoder decodeObjectForKey:@"trail_things_to_do"];
        self.info = [decoder decodeObjectForKey:@"trail_information"];
        
        self.startLocation.latitude = [decoder decodeDoubleForKey:@"trail_lat_start"];
        self.startLocation.longitude = [decoder decodeDoubleForKey:@"trail_long_start"];
        self.endLocation.latitude = [decoder decodeDoubleForKey:@"trail_lat_end"];
        self.endLocation.longitude = [decoder decodeDoubleForKey:@"trail_long_end"];
        
        self.lowerPoint = [decoder decodeObjectForKey:@"trail_min_height"];
        self.higherPoint = [decoder decodeObjectForKey:@"trail_max_height"];
        self.temperature = [decoder decodeObjectForKey:@"trail_temperature"];
        self.distance = [decoder decodeObjectForKey:@"trail_distance"];
        self.duraion = [decoder decodeObjectForKey:@"trail_time"];
        self.cover = [decoder decodeObjectForKey:@"trail_cover"];
        self.covers = [decoder decodeObjectForKey:@"trail_covers"];
        self.isSaved = [decoder decodeBoolForKey:@"is_saved"];
        self.averageRating = [decoder decodeFloatForKey:@"average_rating"];
        self.reviewCount = [decoder decodeObjectForKey:@"review_count"];
        self.guideCount = [decoder decodeObjectForKey:@"guide_count"];
        self.guides = [decoder decodeObjectForKey:@"guides"];
        self.weather = [decoder decodeObjectForKey:@"weather"];
        self.accomodations = [decoder decodeObjectForKey:@"accommodations"];
        self.reviews = [decoder decodeObjectForKey:@"reviews"];
        self.route = [decoder decodeObjectForKey:@"trail_route"];
        self.mapImage = [decoder decodeObjectForKey:@"trail_map_image"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TrailMO *newTrail = [NSEntityDescription insertNewObjectForEntityForName:@"TrailMO" inManagedObjectContext:[[self class] managedObjectContext]];
                         
    if(newTrail) {
        [newTrail setIndex:[self index]];
        [newTrail setName:[self name]];
        [newTrail setDifficultly:[self difficultly]];
        [newTrail setThinksToDo:[self thinksToDo]];
        [newTrail setInfo:[self info]];
        [newTrail setStartLocation:[self startLocation]];
        [newTrail setEndLocation:[self endLocation]];
        [newTrail setLowerPoint:[self lowerPoint]];
        [newTrail setHigherPoint:[self higherPoint]];
        [newTrail setTemperature:[self temperature]];
        [newTrail setDistance:[self distance]];
        [newTrail setDuraion:[self duraion]];
        [newTrail setCover:[self cover]];
        [newTrail setCovers:[self covers]];
        [newTrail setIsSaved:[self isSaved]];
        [newTrail setAverageRating:[self averageRating]];
        [newTrail setGuideCount:[self guideCount]];
        [newTrail setReviewCount:[self reviewCount]];
        [newTrail setGuides:[self guides]];
        [newTrail setWeather:[self weather]];
        [newTrail setAccomodations:[self accomodations]];
        [newTrail setReviews:[self reviews]];
        [newTrail setRoute:[self route]];
        [newTrail setMapImage:[self mapImage]];
    }
    return newTrail;
}

-(Trail *)trailMOtoTrail {
    Trail *trail = [[Trail alloc] init];
    trail.index = [self.index integerValue];
    trail.name = self.name;
    trail.difficultly = self.difficultly;
    trail.thinksToDo = self.thinksToDo;
    trail.info = self.info;
    trail.lowerPoint = [self.lowerPoint integerValue];
    trail.higherPoint = [self.higherPoint integerValue];
    
    trail.startLocation = [[LocationCoordinate alloc] init];
    trail.startLocation.latitude = self.startLocation.latitude;
    trail.startLocation.longitude = self.startLocation.longitude;
    
    trail.route = [[TrailRoute alloc] init];
    trail.route.routeArray = self.route.routeArray;
    
    trail.weather = [[Weather alloc] init];
    trail.weather.temperature = self.weather.temperature;
    trail.weather.weatherIcon = self.weather.weatherIcon;
    
    trail.temperature = self.temperature;
    trail.distance = self.distance;
    trail.duraion = self.duraion;
    trail.guideCount = [self.guideCount integerValue];
    trail.reviewCount = [self.reviewCount integerValue];
    trail.cover = self.cover;
    trail.covers = self.covers;
    trail.guides = [[Guides alloc] init];
    trail.guides.guidesArray = self.guides.guidesArray;
    
    trail.accomodations = [[Accomodations alloc] init];
    trail.accomodations.accomodationsArray = self.accomodations.accomodationsArray;
    
    trail.mapImage = self.mapImage;
    trail.reviews = [[TrailReviews alloc] init];
    trail.reviews.reviewsArray = self.reviews.reviewsArray;
    
    return trail;
}

-(TrailMO *)updateWithTrail:(Trail *)trail {
    self.index = [NSNumber numberWithInteger:trail.index];
    self.name = trail.name;
    self.difficultly = trail.difficultly;
    self.thinksToDo = trail.thinksToDo;
    self.info = trail.info;
    
    self.startLocation.latitude = trail.startLocation.latitude;
    self.startLocation.longitude = trail.startLocation.longitude;
    self.endLocation.latitude = trail.endLocation.latitude;
    self.endLocation.longitude = trail.endLocation.longitude;
    
    self.lowerPoint = [NSNumber numberWithInteger:trail.lowerPoint];
    self.higherPoint = [NSNumber numberWithInteger:trail.higherPoint];
    self.temperature = trail.temperature;
    self.distance = trail.distance;
    self.duraion = trail.duraion;
    self.cover = trail.cover;
    self.covers = trail.covers;
    self.isSaved = trail.isSaved;
    self.averageRating = trail.averageRating;
    self.reviewCount = [NSNumber numberWithInteger:trail.reviewCount];
    self.guideCount = [NSNumber numberWithInteger:trail.guideCount];
    self.guides.guidesArray = trail.guides.guidesArray;
    
    self.weather.temperature = trail.weather.temperature;
    self.weather.weatherIcon = trail.weather.weatherIcon;
    
    self.accomodations.accomodationsArray = trail.accomodations.accomodationsArray;
    self.reviews.reviewsArray = trail.reviews.reviewsArray;
    self.route.routeArray = trail.route.routeArray;
    self.mapImage = trail.mapImage;
    return self;
}

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
