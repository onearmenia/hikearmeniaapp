//
//  Guide.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "Guide.h"
#import "GuideReviews.h"
#import "GuideReview.h"
#import "Languages.h"
#import "StringUtils.h"
#import "NSMutableDictionary+Additions.h"

@implementation Guide

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:@"guide_id"];
	[encoder encodeObject:self.firstname forKey:@"guide_first_name"];
	[encoder encodeObject:self.lastname forKey:@"guide_last_name"];
    [encoder encodeObject:self.guideDescription forKey:@"guide_description"];
	[encoder encodeObject:self.phone forKey:@"guide_phone"];
	[encoder encodeObject:self.email forKey:@"guide_email"];
	[encoder encodeFloat:self.averageRating forKey:@"average_rating"];
	[encoder encodeObject:[NSNumber numberWithInteger:self.reviewCount] forKey:@"review_count"];
	[encoder encodeObject:self.reviews forKey:@"reviews"];
	[encoder encodeObject:self.photoURL forKey:@"guide_image"];
	[encoder encodeObject:self.languages forKey:@"languages"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.index = [[decoder decodeObjectForKey:@"guide_id"] intValue];
		self.firstname = [decoder decodeObjectForKey:@"guide_first_name"];
		self.lastname = [decoder decodeObjectForKey:@"guide_last_name"];
        self.guideDescription = [decoder decodeObjectForKey:@"guide_description"];
		self.phone = [decoder decodeObjectForKey:@"guide_phone"];
		self.email = [decoder decodeObjectForKey:@"guide_email"];
		self.averageRating = [decoder decodeFloatForKey:@"average_rating"];
		self.reviewCount = [[decoder decodeObjectForKey:@"guide_id"] intValue];
		self.reviews = [decoder decodeObjectForKey:@"reviews"];
		self.photoURL = [decoder decodeObjectForKey:@"guide_image"];
		self.languages = [decoder decodeObjectForKey:@"languages"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	Guide *newGuide = [[[self class] alloc] init];
	if(newGuide) {
		[newGuide setIndex:[self index]];
		[newGuide setFirstname:[self firstname]];
		[newGuide setLastname:[self lastname]];
        [newGuide setGuideDescription:[self guideDescription]];
		[newGuide setPhone:[self phone]];
		[newGuide setEmail:[self email]];
		[newGuide setAverageRating:[self averageRating]];
        [newGuide setReviewCount:[self reviewCount]];
		[newGuide setReviews:[self reviews]];
		[newGuide setPhotoURL:[self photoURL]];
		[newGuide setLanguages:[self languages]];
	}
	return newGuide;
}

+ (id)objectFromJSON:(id)json {
	Guide *guide = nil;
	if ([json isKindOfClass:[NSDictionary class]]) {
		guide = [[Guide alloc] init];
		
		guide.index = [[json objectForKey:@"guide_id"] integerValue];
		guide.firstname = [json objectForKey:@"guide_first_name"];
		guide.lastname = [json objectForKey:@"guide_last_name"];
        guide.guideDescription = [json objectForKey:@"guide_description"];
		guide.phone = [[json objectForKey:@"guide_phone"] stringByReplacingOccurrencesOfString:@" " withString:@""];
		guide.email = [json objectForKey:@"guide_email"];
		guide.photoURL = [json objectForKey:@"guide_image"];
		guide.languages = [Languages objectFromJSON:[json objectForKey:@"languages"]];
		guide.averageRating = [[json objectForKey:@"average_rating"] floatValue];
		guide.reviewCount = [[json objectForKey:@"review_count"] integerValue];
		guide.reviews = [GuideReviews objectFromJSON:[json objectForKey:@"reviews"]];
	}
	return guide;
}


- (void)loadGuideWithCallback:(ServiceCallback)callback {
	NSString *params = [NSString stringWithFormat:@"%ld",(long)self.index];
	NSString *url = [self.class buildURLWithServiceName:@"api/guide" URL:params];
	
	[self.class invokeWithRequestMethod:RequestMethodGet URL:url queryParameters:nil bodyPayload:nil callback:callback resultClass:[Guide class]];
}

- (void)addReview:(NSString *)review withRating:(NSInteger)rating callback:(ServiceCallback)callback {
	NSString *params = [NSString stringWithFormat:@"%ld",(long)self.index];
	NSString *url = [self.class buildURLWithServiceName:@"api/guide-review" URL:params];
	
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
	
	[dict safeSetObject:[NSNumber numberWithInteger:self.index] forKey:@"guide_id"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.firstname] forKey:@"guide_first_name"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.lastname] forKey:@"guide_last_name"];
    [dict safeSetObject:[StringUtils safeStringWithString:self.guideDescription] forKey:@"guide_description"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.phone] forKey:@"guide_phone"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.email] forKey:@"guide_email"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.photoURL] forKey:@"guide_image"];
	[dict safeSetObject:self.languages forKey:@"languages"];
	[dict safeSetObject:[NSNumber numberWithFloat:self.averageRating] forKey:@"average_rating"];
	[dict safeSetObject:[NSNumber numberWithInteger:self.reviewCount] forKey:@"review_count"];
	
	return [dict copy];
}

@end
