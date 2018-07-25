//
//  UserRoute.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "UserRoute.h"
#import "LocationCoordinate.h"
#import "NSMutableDictionary+Additions.h"
#import "Trail.h"
#import <CoreLocation/CLLocation.h>

@implementation UserRoute

- (id)copyWithZone:(NSZone *)zone
{
    UserRoute *newRoute = [[[self class] alloc] init];
    if(newRoute) {
        [newRoute setUserId:[self userId]];
        [newRoute setTrailId:[self trailId]];
        [newRoute setRoute:[self.route copy]];
    }
    return newRoute;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.route forKey:@"route"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.route = [decoder decodeObjectForKey:@"route"];
    }
    return self;
}

+ (id)objectFromJSON:(id)json {
    UserRoute *route = [[UserRoute alloc] init];
    route.route = (NSMutableArray *)json;
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        route = [[UserRoute alloc] init];
        
        route.userId = [[json objectForKey:@"user_id"] integerValue];
        route.trailId = [[json objectForKey:@"trail_id"] integerValue];
        
        
        NSMutableArray *coordinateList = [[NSMutableArray alloc] init];
        id locationJson = [json objectForKey:@"location"];
        if (![locationJson isEqual:[NSNull null]]) {
            for (id routeJson in locationJson) {
                LocationCoordinate *coordinate = [LocationCoordinate objectFromJSON:routeJson];
                if (coordinate) {
                    [coordinateList addObject:coordinate];
                }
            }
        }
        route.route = [coordinateList copy];
    }
    return route;
}

- (NSDictionary *)objectToDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict safeSetObject:self.route forKey:@"user_route"];
    
    return [dict copy];
}


- (void)addRouteForTrail:(Trail *)trail callback:(ServiceCallback)callback {
    NSString *params = [NSString stringWithFormat:@"%ld",(long)trail.index];
    NSString *url = [self.class buildURLWithServiceName:@"api/trails" URL:params];
    
    NSMutableDictionary *bodyPayload = [[NSMutableDictionary alloc] init];
    NSMutableArray *coordsArray = [[NSMutableArray alloc] init];
    for (LocationCoordinate *coord in self.route) {
        NSDictionary *coordDictionary = [coord objectToDictionary];
        [coordsArray addObject:coordDictionary];
    }

    [bodyPayload safeSetObject:[coordsArray copy] forKey:@"location"];
    
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

+ (void)loadRouteForTrail:(Trail *)trail callback:(ServiceCallback)callback {
    NSString *params = [NSString stringWithFormat:@"%ld",(long)trail.index];
    NSString *url = [self.class buildURLWithServiceName:@"api/user-trails" URL:params];
    
    [self.class invokeWithRequestMethod:RequestMethodGet URL:url queryParameters:nil bodyPayload:nil callback:callback resultClass:[UserRoute class]];

}

@end
