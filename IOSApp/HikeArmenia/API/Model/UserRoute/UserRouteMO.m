//
//  UserRouteMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/19/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "UserRouteMO.h"
#import <UIKit/UIKit.h>

@implementation UserRouteMO

@dynamic trailId;
@dynamic userId;
@dynamic route;
@dynamic isSaved;


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.trailId forKey:@"trailId"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.route forKey:@"route"];
    [encoder encodeBool:self.isSaved forKey:@"isSaved"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.trailId = [decoder decodeObjectForKey:@"trailId"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.route = [decoder decodeObjectForKey:@"route"];
        self.isSaved = [decoder decodeBoolForKey:@"isSaved"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    UserRouteMO *newUserRoute = [NSEntityDescription insertNewObjectForEntityForName:@"UserRouteMO" inManagedObjectContext:[[self class] managedObjectContext]];
    if(newUserRoute) {
        [newUserRoute setTrailId:[self trailId]];
        [newUserRoute setUserId:[self userId]];
        [newUserRoute setRoute:[[self route] copy]];
        [newUserRoute setIsSaved:[self isSaved]];
    }
    return newUserRoute;
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
