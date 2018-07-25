//
//  GuideReviews.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "GuideReviews.h"
#import "GuideReview.h"

@implementation GuideReviews

- (id)copyWithZone:(NSZone *)zone
{
	GuideReviews *newReviews = [[[self class] alloc] init];
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
	GuideReviews *reviews = nil;
	reviews.reviewsArray = (NSMutableArray *)json;
	
	if ([json isKindOfClass:[NSArray class]]) {
		NSMutableArray *reviewsList = [[NSMutableArray alloc] init];
		for (id reviewJson in json) {
			GuideReview *review = [GuideReview objectFromJSON:reviewJson];
			if (review) {
				[reviewsList addObject:review];
			}
		}
		reviews = [[GuideReviews alloc] init];
		reviews.reviewsArray = [reviewsList copy];
	}
	return reviews;
}


@end
