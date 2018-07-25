//
//  TrailReviewsMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailReviewsMO.h"
#import <UIKit/UIKit.h>

@implementation TrailReviewsMO

@dynamic reviewsArray;

- (id)copyWithZone:(NSZone *)zone
{
    TrailReviewsMO *newReviews = [NSEntityDescription insertNewObjectForEntityForName:@"TrailReviewsMO" inManagedObjectContext:[[self class] managedObjectContext]];
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

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
@end
