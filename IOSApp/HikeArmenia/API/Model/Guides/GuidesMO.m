//
//  GuidesMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/9/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "GuidesMO.h"

@implementation GuidesMO

@dynamic guidesArray;

- (id)copyWithZone:(NSZone *)zone
{
    GuidesMO *newGuides = [NSEntityDescription insertNewObjectForEntityForName:@"GuidesMO" inManagedObjectContext:[[self class] managedObjectContext]];
    if(newGuides) {
        [newGuides setGuidesArray:[self.guidesArray copy]];
    }
    return newGuides;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.guidesArray forKey:@"guidesArray"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.guidesArray = [decoder decodeObjectForKey:@"guidesArray"];
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
