//
//  TrailRoute.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/6/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailRoute.h"
#import "LocationCoordinate.h"

@implementation TrailRoute

- (id)copyWithZone:(NSZone *)zone
{
	TrailRoute *newRoute = [[[self class] alloc] init];
	if(newRoute) {
		[newRoute setRouteArray:[self.routeArray copy]];
	}
	return newRoute;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:self.routeArray forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.routeArray = [decoder decodeObjectForKey:@"data"];
	}
	return self;
}

+ (id)objectFromJSON:(id)json {
	TrailRoute *route = nil;
	route.routeArray = (NSMutableArray *)json;
	
	if ([json isKindOfClass:[NSArray class]]) {
		NSMutableArray *coordinateList = [[NSMutableArray alloc] init];
		for (id routeJson in json) {
			LocationCoordinate *coordinate = [LocationCoordinate objectFromJSON:routeJson];
			if (coordinate) {
				[coordinateList addObject:coordinate];
			}
		}
		route = [[TrailRoute alloc] init];
		route.routeArray = [coordinateList copy];
	}
	return route;
}

- (LocationCoordinate *)locationWithIndex:(NSInteger)index {
	return [self.routeArray objectAtIndex:index];
}

@end
