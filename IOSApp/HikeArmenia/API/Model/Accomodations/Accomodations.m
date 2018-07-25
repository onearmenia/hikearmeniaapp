//
//  Accomodations.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "Accomodations.h"
#import "Accomodation.h"

@implementation Accomodations

- (id)copyWithZone:(NSZone *)zone
{
	Accomodations *newAccomodations = [[[self class] alloc] init];
	if(newAccomodations) {
		[newAccomodations setAccomodationsArray:[self.accomodationsArray copy]];
	}
	return newAccomodations;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:self.accomodationsArray forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.accomodationsArray = [decoder decodeObjectForKey:@"data"];
	}
	return self;
}


+ (id)objectFromJSON:(id)json {
	Accomodations *accomodations = nil;
	accomodations.accomodationsArray = (NSMutableArray *)json;
	
	if ([json isKindOfClass:[NSArray class]]) {
		NSMutableArray *accomodationsList = [[NSMutableArray alloc] init];
		for (id accomodationJson in json) {
			Accomodation *accomodation = [Accomodation objectFromJSON:accomodationJson];
			if (accomodation) {
				[accomodationsList addObject:accomodation];
			}
		}
		accomodations = [[Accomodations alloc] init];
		accomodations.accomodationsArray = [accomodationsList copy];
	}
	return accomodations;
}

@end
