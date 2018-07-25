//
//  UserRoute.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ServiceInvocation.h"
#import "Trail.h"

@interface UserRoute : ServiceInvocation

@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) NSInteger trailId;
@property (strong, nonatomic) NSArray *route;

- (void)addRouteForTrail:(Trail *)trail callback:(ServiceCallback)callback;
+ (void)loadRouteForTrail:(Trail *)trail callback:(ServiceCallback)callback;

@end
