//
//  GuideMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/9/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "GuideMO.h"

@implementation GuideMO

@dynamic index;
@dynamic firstname;
@dynamic lastname;
@dynamic phone;
@dynamic email;
@dynamic photo;
@dynamic averageRating;
@dynamic reviewCount;
//@dynamic reviews;
//@dynamic languages;

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:[NSNumber numberWithInteger:self.index] forKey:@"guide_id"];
    [encoder encodeObject:self.firstname forKey:@"guide_first_name"];
    [encoder encodeObject:self.lastname forKey:@"guide_last_name"];
    [encoder encodeObject:self.phone forKey:@"guide_phone"];
    [encoder encodeObject:self.email forKey:@"guide_email"];
    [encoder encodeFloat:self.averageRating forKey:@"average_rating"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.reviewCount] forKey:@"review_count"];
    //[encoder encodeObject:self.reviews forKey:@"reviews"];
    [encoder encodeObject:self.photo forKey:@"guide_image"];
    //[encoder encodeObject:self.languages forKey:@"languages"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.index = [[decoder decodeObjectForKey:@"guide_id"] intValue];
        self.firstname = [decoder decodeObjectForKey:@"guide_first_name"];
        self.lastname = [decoder decodeObjectForKey:@"guide_last_name"];
        self.phone = [decoder decodeObjectForKey:@"guide_phone"];
        self.email = [decoder decodeObjectForKey:@"guide_email"];
        self.averageRating = [decoder decodeFloatForKey:@"average_rating"];
        self.reviewCount = [decoder decodeInt32ForKey:@"review_count"];
        //self.reviews = [decoder decodeObjectForKey:@"reviews"];
        self.photo = [decoder decodeObjectForKey:@"guide_image"];
        //self.languages = [decoder decodeObjectForKey:@"guide_languages"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    GuideMO *newGuide = [NSEntityDescription insertNewObjectForEntityForName:@"GuideMO" inManagedObjectContext:[[self class] managedObjectContext]];
    if(newGuide) {
        [newGuide setIndex:[self index]];
        [newGuide setFirstname:[self firstname]];
        [newGuide setLastname:[self lastname]];
        [newGuide setPhone:[self phone]];
        [newGuide setEmail:[self email]];
        [newGuide setAverageRating:[self averageRating]];
        [newGuide setReviewCount:[self reviewCount]];
        //[newGuide setReviews:[self reviews]];
        [newGuide setPhoto:[self photo]];
        //[newGuide setLanguages:[self languages]];
    }
    return newGuide;
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
