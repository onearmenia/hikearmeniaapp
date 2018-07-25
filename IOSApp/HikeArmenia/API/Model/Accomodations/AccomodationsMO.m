//
//  AccomodationsMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "AccomodationsMO.h"
#import <UIKit/UIKit.h>

@implementation AccomodationsMO

@dynamic accomodationsArray;

- (id)copyWithZone:(NSZone *)zone
{
    AccomodationsMO *newAccomodations = [NSEntityDescription insertNewObjectForEntityForName:@"AccomodationsMO" inManagedObjectContext:[[self class] managedObjectContext]];
    if(newAccomodations) {
        [newAccomodations setAccomodationsArray:[self.accomodationsArray copy]];
    }
    return newAccomodations;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.accomodationsArray forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.accomodationsArray = [decoder decodeObjectForKey:@"data"];
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
