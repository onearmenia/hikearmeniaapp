//
//  Guides.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "Guides.h"
#import "Guide.h"
#import "Trail.h"

@implementation Guides

- (id)copyWithZone:(NSZone *)zone
{
	Guides *newGuides = [[[self class] alloc] init];
	if(newGuides) {
		[newGuides setGuidesArray:[self.guidesArray copy]];
	}
	return newGuides;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:self.guidesArray forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.guidesArray = [decoder decodeObjectForKey:@"data"];
	}
	return self;
}

+ (void)loadGuidesWithCallback:(ServiceCallback)callback {
	NSString *language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
	NSString *params = [NSString stringWithFormat:@"?language=%@",language];
	NSString *url = [self.class buildURLWithServiceName:@"api/guide" URL:params];

	[self.class invokeWithRequestMethod:RequestMethodGet URL:url queryParameters:nil bodyPayload:nil callback:callback resultClass:[Guides class]];
}

+ (void)loadGuidesForTrailId:(NSInteger)trailId WithCallback:(ServiceCallback)callback {
    NSString *params = [NSString stringWithFormat:@"%ld",(long)trailId];
    NSString *url = [self.class buildURLWithServiceName:@"api/trail-guides" URL:params];
    
    [self.class invokeWithRequestMethod:RequestMethodGet URL:url queryParameters:nil bodyPayload:nil callback:callback resultClass:[Guides class]];
}

+ (id)objectFromJSON:(id)json {
	Guides *guides = nil;
	guides.guidesArray = (NSMutableArray *)json;
	
	if ([json isKindOfClass:[NSArray class]]) {
		NSMutableArray *guidesList = [[NSMutableArray alloc] init];
		for (id guideJson in json) {
			Guide *guide = [Guide objectFromJSON:guideJson];
			if (guide) {
				[guidesList addObject:guide];
			}
		}
		guides = [[Guides alloc] init];
		guides.guidesArray = [guidesList copy];
	}
	return guides;
}

@end
