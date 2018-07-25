//
//  Trail.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "Trail.h"
#import "TrailReviews.h"
#import "TrailReview.h"
#import "Guides.h"
#import "Accomodations.h"
#import "StringUtils.h"
#import "NSMutableDictionary+Additions.h"
#import "TrailRoute.h"
#import "LocationCoordinate.h"
#import "Weather.h"

@implementation Trail

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:@"trail_id"];
	[encoder encodeObject:self.name forKey:@"trail_name"];
	[encoder encodeObject:self.difficultly forKey:@"trail_difficulty"];
	[encoder encodeObject:self.thinksToDo forKey:@"trail_things_to_do"];
	[encoder encodeObject:self.info forKey:@"trail_information"];
	
	self.startLocation = [[LocationCoordinate alloc] init];
	self.endLocation = [[LocationCoordinate alloc] init];
	[encoder encodeDouble:self.startLocation.latitude forKey:@"trail_lat_start"];
	[encoder encodeDouble:self.startLocation.longitude forKey:@"trail_long_start"];
	[encoder encodeDouble:self.endLocation.latitude forKey:@"trail_lat_end"];
	[encoder encodeDouble:self.endLocation.longitude forKey:@"trail_long_end"];
	
    [encoder encodeObject:[NSNumber numberWithInteger:self.lowerPoint] forKey:@"trail_min_height"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.higherPoint] forKey:@"trail_max_height"];
	[encoder encodeObject:self.temperature forKey:@"trail_temperature"];
	[encoder encodeObject:self.distance forKey:@"trail_distance"];
	[encoder encodeObject:self.duraion forKey:@"trail_time"];
	[encoder encodeObject:self.cover forKey:@"trail_cover"];
	[encoder encodeObject:self.covers forKey:@"trail_covers"];
	[encoder encodeBool:self.isSaved forKey:@"is_saved"];
	[encoder encodeFloat:self.averageRating forKey:@"average_rating"];
	[encoder encodeObject:[NSNumber numberWithInteger:self.reviewCount] forKey:@"review_count"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.guideCount] forKey:@"guide_count"];
	[encoder encodeObject:self.guides forKey:@"guides"];
    [encoder encodeObject:self.weather forKey:@"weather"];
	[encoder encodeObject:self.accomodations forKey:@"accommodations"];
	[encoder encodeObject:self.reviews forKey:@"reviews"];
	[encoder encodeObject:self.route forKey:@"trail_route"];
    [encoder encodeObject:self.mapImage forKey:@"trail_map_image"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.index = [[decoder decodeObjectForKey:@"trail_id"] intValue];
		self.name = [decoder decodeObjectForKey:@"trail_name"];
		self.difficultly = [decoder decodeObjectForKey:@"trail_difficulty"];
		self.thinksToDo = [decoder decodeObjectForKey:@"trail_things_to_do"];
		self.info = [decoder decodeObjectForKey:@"trail_information"];
		
		self.startLocation = [[LocationCoordinate alloc] init];
		self.endLocation = [[LocationCoordinate alloc] init];
		self.startLocation.latitude = [decoder decodeDoubleForKey:@"trail_lat_start"];
		self.startLocation.longitude = [decoder decodeDoubleForKey:@"trail_long_start"];
		self.endLocation.latitude = [decoder decodeDoubleForKey:@"trail_lat_end"];
		self.endLocation.longitude = [decoder decodeDoubleForKey:@"trail_long_end"];
		
		self.lowerPoint = [[decoder decodeObjectForKey:@"trail_min_height"] intValue];
		self.higherPoint = [[decoder decodeObjectForKey:@"trail_max_height"] intValue];
		self.temperature = [decoder decodeObjectForKey:@"trail_temperature"];
		self.distance = [decoder decodeObjectForKey:@"trail_distance"];
		self.duraion = [decoder decodeObjectForKey:@"trail_time"];
		self.cover = [decoder decodeObjectForKey:@"trail_cover"];
		self.covers = [decoder decodeObjectForKey:@"trail_covers"];
		self.isSaved = [decoder decodeBoolForKey:@"is_saved"];
		self.averageRating = [decoder decodeFloatForKey:@"average_rating"];
		self.reviewCount = [decoder decodeInt32ForKey:@"review_count"];
        self.guideCount = [decoder decodeInt32ForKey:@"guide_count"];
		self.guides = [decoder decodeObjectForKey:@"guides"];
        self.weather = [decoder decodeObjectForKey:@"weather"];
		self.accomodations = [decoder decodeObjectForKey:@"accommodations"];
		self.route = [decoder decodeObjectForKey:@"trail_route"];
        self.mapImage = [decoder decodeObjectForKey:@"trail_map_image"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	Trail *newTrail = [[[self class] alloc] init];
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
		[newTrail setGuides:[self guides]];
        [newTrail setWeather:[self weather]];
		[newTrail setAccomodations:[self accomodations]];
		[newTrail setReviews:[self reviews]];
		[newTrail setRoute:[self route]];
        [newTrail setMapImage:[self mapImage]];
	}
	return newTrail;
}

+ (id)objectFromJSON:(id)json {
	Trail *trail = nil;
	if ([json isKindOfClass:[NSDictionary class]]) {
		trail = [[Trail alloc] init];
		
		trail.index = [[json objectForKey:@"trail_id"] integerValue];
		trail.name = [json objectForKey:@"trail_name"];
		trail.difficultly = [json objectForKey:@"trail_difficulty"];
		trail.thinksToDo = [json objectForKey:@"trail_things_to_do"];
		trail.info = [json objectForKey:@"trail_information"];
		
		trail.startLocation = [[LocationCoordinate alloc] init];
		trail.endLocation = [[LocationCoordinate alloc] init];
        if ([[json objectForKey:@"trail_lat_start"] length] > 0) {
            trail.startLocation.latitude = [[json objectForKey:@"trail_lat_start"] doubleValue];
        } else {
            trail.startLocation.latitude = NAN;
        }
        if ([[json objectForKey:@"trail_long_start"] length] > 0) {
            trail.startLocation.longitude = [[json objectForKey:@"trail_long_start"] doubleValue];
        } else {
            trail.startLocation.longitude = NAN;
        }
		trail.endLocation.latitude = [[json objectForKey:@"trail_lat_end"] doubleValue];
		trail.endLocation.longitude = [[json objectForKey:@"trail_long_end"] doubleValue];
		
		trail.lowerPoint = [[json objectForKey:@"trail_min_height"] integerValue];
		trail.higherPoint = [[json objectForKey:@"trail_max_height"] integerValue];
		trail.temperature = [json objectForKey:@"trail_temperature"];
		trail.distance = [json objectForKey:@"trail_distance"];
		trail.duraion = [json objectForKey:@"trail_time"];
		trail.cover = [json objectForKey:@"trail_cover"];
		trail.covers = [json objectForKey:@"trail_covers"];
		trail.isSaved = [[json objectForKey:@"is_saved"] boolValue];
		if([json objectForKey:@"average_rating"] != [NSNull null])
			trail.averageRating = [[json objectForKey:@"average_rating"] floatValue];
        trail.mapImage = [json objectForKey:@"trail_map_image"];

		trail.route = [TrailRoute objectFromJSON:[json objectForKey:@"trail_route"]];
		trail.reviewCount = [[json objectForKey:@"review_count"] integerValue];
        trail.guideCount = [[json objectForKey:@"guide_count"] integerValue];
		trail.guides = [Guides objectFromJSON:[json objectForKey:@"guides"]];
        trail.weather = [Weather objectFromJSON:[json objectForKey:@"weather"]];
		trail.accomodations = [Accomodations objectFromJSON:[json objectForKey:@"accommodations"]];
		trail.reviews = [TrailReviews objectFromJSON:[json objectForKey:@"reviews"]];
	}
	return trail;
}

- (void)loadTrailWithCallback:(ServiceCallback)callback {
	NSString *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
	NSString *params = [NSString stringWithFormat:@"%ld?language=%@",(long)self.index,language];
	NSString *url = [self.class buildURLWithServiceName:@"api/trails" URL:params];
	
	[self.class invokeWithRequestMethod:RequestMethodGet URL:url queryParameters:nil bodyPayload:nil callback:callback resultClass:[Trail class]];
}

- (void)loadTrailTipsWithCallback:(ServiceCallback)callback {
    NSString *params = [NSString stringWithFormat:@"%ld",(long)self.index];
    NSString *url = [self.class buildURLWithServiceName:@"api/trail-review" URL:params];
    
    [self.class invokeWithRequestMethod:RequestMethodGet URL:url queryParameters:nil bodyPayload:nil callback:callback resultClass:[TrailReviews class]];
}

- (void)addTrailToSavedListWithCallback:(ServiceCallback)callback {
	NSString *url = [self.class buildURLWithServiceName:@"api/saved-trails" URL:@""];
	
	NSMutableDictionary *bodyPayload = [[NSMutableDictionary alloc] init];
	[bodyPayload setObject:[NSNumber numberWithInteger:self.index] forKey:@"trail_id"];
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyPayload options:0 error:&error];
	if (!error) {
		[self.class invokeWithRequestMethod:RequestMethodPost URL:url queryParameters:nil bodyPayload:jsonData callback:^(id result,long long contentLength, NSError *error) {
			if(!error)
			{
				if ([result isKindOfClass:[NSDictionary class]]) {
					NSInteger code = [[result objectForKey:@"code"] integerValue];
					if(code == 200)
						callback([NSNumber numberWithBool:YES],1, nil);
					else
						callback([NSNumber numberWithBool:NO],1, nil);
				}
				else
					callback([NSNumber numberWithBool:NO],1, error);
			}
			else
			{
				callback([NSNumber numberWithBool:NO],1, error);
			}
		} resultClass:nil];
	} else {
		callback(nil,0,error);
	}
}

- (void)removeTrailFromSavedListWithCallback:(ServiceCallback)callback {
    NSString *url = [self.class buildURLWithServiceName:@"api/saved-trails" URL:[NSString stringWithFormat:@"%ld", (long)self.index]];
    
    NSError *error = nil;
    if (!error) {
        [self.class invokeWithRequestMethod:RequestMethodDelete URL:url queryParameters:nil bodyPayload:nil callback:^(id result,long long contentLength, NSError *error) {
            if(!error)
            {
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [[result objectForKey:@"code"] integerValue];
                    if(code == 200)
                        callback([NSNumber numberWithBool:YES],1, nil);
                    else
                        callback([NSNumber numberWithBool:NO],1, nil);
                }
                else
                    callback([NSNumber numberWithBool:NO],1, error);
            }
            else
            {
                callback([NSNumber numberWithBool:NO],1, error);
            }
        } resultClass:nil];
    } else {
        callback(nil,0,error);
    }
}

- (void)addReview:(NSString *)review withRating:(NSInteger)rating callback:(ServiceCallback)callback {
	NSString *params = [NSString stringWithFormat:@"%ld",(long)self.index];
	NSString *url = [self.class buildURLWithServiceName:@"api/trail-review" URL:params];
	
	NSMutableDictionary *bodyPayload = [[NSMutableDictionary alloc] init];
	[bodyPayload setObject:review forKey:@"review"];
	[bodyPayload setObject:[NSNumber numberWithInteger:rating] forKey:@"rating"];
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyPayload options:0 error:&error];
	if (!error) {
		[self.class invokeWithRequestMethod:RequestMethodPut URL:url queryParameters:nil bodyPayload:jsonData callback:^(id result,long long contentLength, NSError *error) {
			if(!error)
			{
				if ([result isKindOfClass:[NSDictionary class]]) {
					NSInteger code = [[result objectForKey:@"code"] integerValue];
					if(code == 200)
						callback([NSNumber numberWithBool:YES],1, nil);
					else
						callback([NSNumber numberWithBool:NO],1, nil);
				}
				else
					callback([NSNumber numberWithBool:NO],1, error);
			}
			else
			{
				callback([NSNumber numberWithBool:NO],1, error);
			}
		} resultClass:nil];
	} else {
		callback(nil,0,error);
	}
}

- (NSDictionary *)objectToDictionary {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict safeSetObject:[NSNumber numberWithInteger:self.index] forKey:@"trail_id"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.name] forKey:@"trail_name"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.difficultly] forKey:@"trail_difficulty"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.thinksToDo] forKey:@"trail_things_to_do"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.info] forKey:@"trail_information"];
	[dict safeSetObject:[NSNumber numberWithDouble:self.startLocation.latitude] forKey:@"trail_lat_start"];
	[dict safeSetObject:[NSNumber numberWithDouble:self.startLocation.longitude] forKey:@"trail_long_start"];
	[dict safeSetObject:[NSNumber numberWithDouble:self.endLocation.latitude] forKey:@"trail_lat_end"];
	[dict safeSetObject:[NSNumber numberWithDouble:self.endLocation.longitude] forKey:@"trail_long_end"];
    [dict safeSetObject:[NSNumber numberWithInteger:self.lowerPoint] forKey:@"trail_min_height"];
    [dict safeSetObject:[NSNumber numberWithInteger:self.higherPoint] forKey:@"trail_max_height"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.temperature] forKey:@"trail_temperature"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.distance] forKey:@"trail_distance"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.duraion] forKey:@"trail_time"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.cover] forKey:@"trail_cover"];
	[dict safeSetObject:self.covers forKey:@"trail_covers"];
	[dict safeSetObject:[NSNumber numberWithBool:self.isSaved] forKey:@"is_saved"];
	[dict safeSetObject:[NSNumber numberWithFloat:self.averageRating] forKey:@"average_rating"];
	[dict safeSetObject:[NSNumber numberWithInteger:self.reviewCount] forKey:@"review_count"];
    [dict safeSetObject:[NSNumber numberWithInteger:self.guideCount] forKey:@"guide_count"];
    [dict safeSetObject:[StringUtils safeStringWithString:self.mapImage] forKey:@"trail_map_image"];

	return [dict copy];
}

@end
