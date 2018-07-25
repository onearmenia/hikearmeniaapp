//
//  LocationCoordinateMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/13/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "LocationCoordinateMO.h"
#import <UIKit/UIKit.h>

@implementation LocationCoordinateMO

@dynamic latitude;
@dynamic longitude;

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeDouble:self.latitude forKey:@"latitude"];
    [encoder encodeDouble:self.longitude forKey:@"longitude"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.latitude = [decoder decodeDoubleForKey:@"latitude"];
        self.longitude = [decoder decodeDoubleForKey:@"longitude"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LocationCoordinateMO *newCoordinate = [NSEntityDescription insertNewObjectForEntityForName:@"LocationCoordinateMO" inManagedObjectContext:[[self class] managedObjectContext]];
    if(newCoordinate) {
        [newCoordinate setLatitude:[self latitude]];
        [newCoordinate setLongitude:[self longitude]];
    }
    return newCoordinate;
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
