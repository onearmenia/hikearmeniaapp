//
//  Accomodation.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "Accomodation.h"
#import "StringUtils.h"
#import "NSMutableDictionary+Additions.h"

@implementation Accomodation

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:@"acc_id"];
	[encoder encodeObject:self.name forKey:@"acc_name"];
	[encoder encodeObject:self.desc forKey:@"acc_description"];
	[encoder encodeObject:self.phone forKey:@"acc_phone"];
	[encoder encodeObject:self.price forKey:@"acc_price"];
	[encoder encodeObject:self.email forKey:@"acc_email"];
	[encoder encodeObject:self.cover forKey:@"acc_cover"];
	[encoder encodeObject:self.facilities forKey:@"acc_facilities"];
	[encoder encodeObject:self.url forKey:@"acc_url"];
    [encoder encodeObject:self.mapImg forKey:@"map_img"];
    [encoder encodeObject:self.coordinate forKey:@"coordinate"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.index = [[decoder decodeObjectForKey:@"acc_id"] integerValue];
		self.name = [decoder decodeObjectForKey:@"acc_name"];
		self.desc = [decoder decodeObjectForKey:@"acc_description"];
		self.phone = [decoder decodeObjectForKey:@"acc_phone"];
		self.price = [decoder decodeObjectForKey:@"acc_price"];
		self.email = [decoder decodeObjectForKey:@"acc_email"];
		self.cover = [decoder decodeObjectForKey:@"acc_cover"];
		self.facilities = [decoder decodeObjectForKey:@"acc_facilities"];
		self.url = [decoder decodeObjectForKey:@"acc_url"];
        self.mapImg = [decoder decodeObjectForKey:@"map_img"];
        self.coordinate = [decoder decodeObjectForKey:@"coordinate"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	Accomodation *newAccomodation = [[[self class] alloc] init];
	if(newAccomodation) {
		[newAccomodation setIndex:[self index]];
		[newAccomodation setName:[self name]];
		[newAccomodation setDesc:[self desc]];
		[newAccomodation setEmail:[self email]];
		[newAccomodation setCover:[self cover]];
		[newAccomodation setPhone:[self phone]];
		[newAccomodation setPrice:[self price]];
		[newAccomodation setFacilities:[self facilities]];
		[newAccomodation setUrl:[self url]];
        [newAccomodation setMapImg:[self mapImg]];
        [newAccomodation setCoordinate:[[self coordinate] copy]];
	}
	return newAccomodation;
}

- (void)loadAccomodationWithCallback:(ServiceCallback)callback {
	NSString *params = [NSString stringWithFormat:@"%ld",(long)self.index];
	NSString *url = [self.class buildURLWithServiceName:@"api/accommodations" URL:params];
	
	[self.class invokeWithRequestMethod:RequestMethodGet URL:url queryParameters:nil bodyPayload:nil callback:callback resultClass:[Accomodation class]];
}

+ (id)objectFromJSON:(id)json {
	Accomodation *accomodation = nil;
	if ([json isKindOfClass:[NSDictionary class]]) {
		accomodation = [[Accomodation alloc] init];

		accomodation.index = [[json objectForKey:@"acc_id"] integerValue];
		accomodation.name = [json objectForKey:@"acc_name"];
		accomodation.desc = [json objectForKey:@"acc_description"];
		accomodation.phone = [[json objectForKey:@"acc_phone"] stringByReplacingOccurrencesOfString:@" " withString:@""];
		accomodation.price = [json objectForKey:@"acc_price"];
		accomodation.email = [json objectForKey:@"acc_email"];
		accomodation.cover = [json objectForKey:@"acc_cover"];
		accomodation.facilities = [json objectForKey:@"acc_facilities"];
		accomodation.url = [json objectForKey:@"acc_url"];
        accomodation.mapImg = [json objectForKey:@"acc_map_image"];
        accomodation.coordinate = [[LocationCoordinate alloc] init];
        accomodation.coordinate.latitude = [[json objectForKey:@"acc_lat"] floatValue];
        accomodation.coordinate.longitude = [[json objectForKey:@"acc_long"] floatValue];
	}
	return accomodation;
}

- (NSDictionary *)objectToDictionary {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict safeSetObject:[NSNumber numberWithInteger:self.index] forKey:@"acc_id"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.name] forKey:@"acc_name"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.desc] forKey:@"acc_description"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.phone] forKey:@"acc_phone"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.price] forKey:@"acc_price"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.email] forKey:@"acc_email"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.cover] forKey:@"acc_cover"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.facilities] forKey:@"acc_facilities"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.url] forKey:@"acc_url"];
    [dict safeSetObject:[StringUtils safeStringWithString:self.mapImg] forKey:@"acc_map_image"];
	[dict safeSetObject:[NSNumber numberWithFloat:self.coordinate.latitude] forKey:@"acc_lat"];
    [dict safeSetObject:[NSNumber numberWithFloat:self.coordinate.longitude] forKey:@"acc_long"];
    
	return [dict copy];
}

@end
