//
//  AccomodationMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "AccomodationMO.h"
#import <UIKit/UIKit.h>

@implementation AccomodationMO

@dynamic index;
@dynamic name;
@dynamic desc;
@dynamic phone;
@dynamic price;
@dynamic email;
@dynamic cover;
@dynamic facilities;
@dynamic url;

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
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    AccomodationMO *newAccomodation = [NSEntityDescription insertNewObjectForEntityForName:@"AccomodationMO" inManagedObjectContext:[[self class] managedObjectContext]];
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
    }
    return newAccomodation;
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
