//
//  LocationCoordinate.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/6/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "LocationCoordinate.h"
#import "NSMutableDictionary+Additions.h"

@implementation LocationCoordinate

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeDouble:self.latitude forKey:@"latitude"];
	[encoder encodeDouble:self.longitude forKey:@"longitude"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.latitude = [decoder decodeDoubleForKey:@"latitude"];
		self.longitude = [decoder decodeDoubleForKey:@"longitude"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	LocationCoordinate *newCoordinate = [[[self class] alloc] init];
	if(newCoordinate) {
		[newCoordinate setLatitude:[self latitude]];
		[newCoordinate setLongitude:[self longitude]];
	}
	return newCoordinate;
}

+ (id)objectFromJSON:(id)json {
	LocationCoordinate *coordinate = nil;
	if ([json isKindOfClass:[NSDictionary class]]) {
		coordinate = [[LocationCoordinate alloc] init];
		
		coordinate.latitude = [[json objectForKey:@"latitude"] doubleValue];
		coordinate.longitude = [[json objectForKey:@"longitude"] doubleValue];
	}
	return coordinate;
}

- (NSDictionary *)objectToDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict safeSetObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    [dict safeSetObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    
    return [dict copy];
}
@end
