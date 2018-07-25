//
//  TrailRouteMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/13/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailRouteMO.h"
#import <UIKit/UIKit.h>
    
@implementation TrailRouteMO

@dynamic routeArray;

- (id)copyWithZone:(NSZone *)zone
{
    TrailRouteMO *newRoute = [NSEntityDescription insertNewObjectForEntityForName:@"TrailRouteMO" inManagedObjectContext:[[self class] managedObjectContext]];
    if(newRoute) {
        [newRoute setRouteArray:[self.routeArray copy]];
    }
    return newRoute;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.routeArray forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.routeArray = [decoder decodeObjectForKey:@"data"];
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
