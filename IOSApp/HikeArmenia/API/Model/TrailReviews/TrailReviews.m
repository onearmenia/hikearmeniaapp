//
//  TrailReviews.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailReviews.h"
#import "TrailReview.h"

@implementation TrailReviews

- (id)copyWithZone:(NSZone *)zone
{
	TrailReviews *newReviews = [[[self class] alloc] init];
	if(newReviews) {
		[newReviews setReviewsArray:[self.reviewsArray copy]];
	}
	return newReviews;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:self.reviewsArray forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.reviewsArray = [decoder decodeObjectForKey:@"data"];
	}
	return self;
}

+ (id)objectFromJSON:(id)json {
	TrailReviews *reviews = nil;
	reviews.reviewsArray = (NSMutableArray *)json;
	
	if ([json isKindOfClass:[NSArray class]]) {
		NSMutableArray *reviewsList = [[NSMutableArray alloc] init];
		for (id reviewJson in json) {
			TrailReview *review = [TrailReview objectFromJSON:reviewJson];
			if (review) {
				[reviewsList addObject:review];
			}
		}
		reviews = [[TrailReviews alloc] init];
		reviews.reviewsArray = [reviewsList copy];
	}
	return reviews;
}

@end
