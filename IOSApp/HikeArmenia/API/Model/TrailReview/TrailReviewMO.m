//
//  TrailReviewMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailReviewMO.h"
#import <UIKit/UIKit.h>

@implementation TrailReviewMO

@dynamic index;
@dynamic userId;
@dynamic firstname;
@dynamic lastname;
@dynamic avatar;
@dynamic reviewText;
@dynamic rating;


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
    TrailReviewMO *newReview = [NSEntityDescription insertNewObjectForEntityForName:@"TrailReviewMO" inManagedObjectContext:[[self class] managedObjectContext]];
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

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
