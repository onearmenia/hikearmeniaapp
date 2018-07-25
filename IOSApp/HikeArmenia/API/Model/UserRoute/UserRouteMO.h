//
//  UserRouteMO.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/19/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UserRouteMO : NSManagedObject

@property (assign, nonatomic) NSNumber *trailId;
@property (assign, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSArray *route;
@property (assign, nonatomic) BOOL isSaved;

@end
