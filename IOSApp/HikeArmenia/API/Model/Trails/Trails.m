//
//  Trails.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "Trails.h"
#import "Trail.h"

@implementation Trails

- (id)copyWithZone:(NSZone *)zone
{
	Trails *newTrails = [[[self class] alloc] init];
	if(newTrails) {
		[newTrails setTrailsArray:[self.trailsArray copy]];
	}
	return newTrails;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:self.trailsArray forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.trailsArray = [decoder decodeObjectForKey:@"data"];
	}
	return self;
}


+ (void)loadTrailsWithCallback:(ServiceCallback)callback {
	NSString *url = [self.class buildURLWithServiceName:@"api/trails" URL:@""];
	
	[self.class invokeWithRequestMethod:RequestMethodGet URL:url queryParameters:nil bodyPayload:nil callback:callback resultClass:[Trails class]];
}

+ (id)objectFromJSON:(id)json {
	Trails *trails = nil;
	trails.trailsArray= (NSMutableArray *)json;
	
	if ([json isKindOfClass:[NSArray class]]) {
		NSMutableArray *trailsList = [[NSMutableArray alloc] init];
		for (id trailJson in json) {
			Trail *trail = [Trail objectFromJSON:trailJson];
			if (trail) {
				[trailsList addObject:trail];
			}
		}
//        
//#warning fake data for parallax demo. TO BE DELETED
//        for (id trailJson in json) {
//            Trail *trail = [Trail objectFromJSON:trailJson];
//            if (trail) {
//                [trailsList addObject:trail];
//            }
//        }
//        
        
		trails = [[Trails alloc] init];
		trails.trailsArray = [trailsList copy];
	}
	return trails;
}

@end
