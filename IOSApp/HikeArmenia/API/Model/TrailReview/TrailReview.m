//
//  TrailReview.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailReview.h"
#import "StringUtils.h"
#import "NSMutableDictionary+Additions.h"

@implementation TrailReview

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:@"tr_id"];
	[encoder encodeObject:[NSNumber numberWithInteger:self.userId] forKey:@"tr_user_id"];
	[encoder encodeObject:self.firstname forKey:@"user_first_name"];
	[encoder encodeObject:self.lastname forKey:@"user_last_name"];
	[encoder encodeObject:self.reviewText forKey:@"tr_review"];
	[encoder encodeObject:[NSNumber numberWithInteger:self.rating] forKey:@"tr_rating"];
	[encoder encodeObject:self.avatar forKey:@"user_avatar"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.index = [[decoder decodeObjectForKey:@"tr_id"] integerValue];
		self.userId = [[decoder decodeObjectForKey:@"tr_user_id"] integerValue];
		self.firstname = [decoder decodeObjectForKey:@"user_first_name"];
		self.lastname = [decoder decodeObjectForKey:@"user_last_name"];
		self.reviewText = [decoder decodeObjectForKey:@"tr_review"];
		self.rating = [[decoder decodeObjectForKey:@"tr_rating"] integerValue];
		self.avatar = [decoder decodeObjectForKey:@"user_avatar"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	TrailReview *newReview = [[[self class] alloc] init];
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
	TrailReview *review = nil;
	if ([json isKindOfClass:[NSDictionary class]]) {
		review = [[TrailReview alloc] init];
		
		review.index = [[json objectForKey:@"tr_id"] integerValue];
		review.userId = [[json objectForKey:@"tr_user_id"] integerValue];
		review.firstname = [json objectForKey:@"user_first_name"];
		review.lastname = [json objectForKey:@"user_last_name"];
		review.reviewText = [json objectForKey:@"tr_review"];
		review.rating = [[json objectForKey:@"tr_rating"] integerValue];
		review.avatar = [json objectForKey:@"user_avatar"];
	}
	return review;
}

- (NSDictionary *)objectToDictionary {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict safeSetObject:[NSNumber numberWithInteger:self.index] forKey:@"tr_id"];
	[dict safeSetObject:[NSNumber numberWithInteger:self.userId] forKey:@"tr_user_id"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.firstname] forKey:@"user_first_name"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.lastname] forKey:@"user_last_name"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.reviewText] forKey:@"tr_review"];
	[dict safeSetObject:[NSNumber numberWithInteger:self.rating] forKey:@"tr_rating"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.avatar] forKey:@"user_avatar"];
	
	return [dict copy];
}

@end
