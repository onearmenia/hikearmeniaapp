//
//  GuideReview.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "GuideReview.h"
#import "StringUtils.h"
#import "NSMutableDictionary+Additions.h"

@implementation GuideReview

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:@"gr_id"];
	[encoder encodeObject:[NSNumber numberWithInteger:self.userId] forKey:@"gr_user_id"];
	[encoder encodeObject:self.firstname forKey:@"user_first_name"];
	[encoder encodeObject:self.lastname forKey:@"user_last_name"];
	[encoder encodeObject:self.reviewText forKey:@"gr_review"];
	[encoder encodeObject:[NSNumber numberWithInteger:self.rating] forKey:@"gr_rating"];
	[encoder encodeObject:self.avatar forKey:@"user_avatar"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.index = [[decoder decodeObjectForKey:@"gr_id"] integerValue];
		self.userId = [[decoder decodeObjectForKey:@"gr_user_id"] integerValue];
		self.firstname = [decoder decodeObjectForKey:@"user_first_name"];
		self.lastname = [decoder decodeObjectForKey:@"user_last_name"];
		self.reviewText = [decoder decodeObjectForKey:@"gr_review"];
		self.rating = [[decoder decodeObjectForKey:@"gr_rating"] integerValue];
		self.avatar = [decoder decodeObjectForKey:@"user_avatar"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	GuideReview *newReview = [[[self class] alloc] init];
	if(newReview) {
		[newReview setIndex:[self index]];
		[newReview setUserId:[self userId]];
		[newReview setFirstname:[self firstname]];
		[newReview setLastname:[self lastname]];
		[newReview setReviewText:[self reviewText]];
		[newReview setRating:[self rating]];
		[newReview setAvatar:[self avatar]];
	}
	return newReview;
}

+ (id)objectFromJSON:(id)json {
	GuideReview *review = nil;
	if ([json isKindOfClass:[NSDictionary class]]) {
		review = [[GuideReview alloc] init];
		
		review.index = [[json objectForKey:@"gr_id"] integerValue];
		review.userId = [[json objectForKey:@"gr_user_id"] integerValue];
		review.firstname = [json objectForKey:@"user_first_name"];
		review.lastname = [json objectForKey:@"user_last_name"];
		review.reviewText = [json objectForKey:@"gr_review"];
		review.rating = [[json objectForKey:@"gr_rating"] integerValue];
		review.avatar = [json objectForKey:@"user_avatar"];
	}
	return review;
}

- (NSDictionary *)objectToDictionary {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict safeSetObject:[NSNumber numberWithInteger:self.index] forKey:@"gr_id"];
	[dict safeSetObject:[NSNumber numberWithInteger:self.userId] forKey:@"gr_user_id"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.firstname] forKey:@"user_first_name"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.lastname] forKey:@"user_last_name"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.reviewText] forKey:@"gr_review"];
	[dict safeSetObject:[NSNumber numberWithInteger:self.rating] forKey:@"gr_rating"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.avatar] forKey:@"user_avatar"];
	
	return [dict copy];
}

@end
