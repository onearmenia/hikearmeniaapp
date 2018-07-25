//
//  TrailRoute.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/6/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@class LocationCoordinate;

@interface TrailRoute : ServiceInvocation
@property (strong, nonatomic) NSMutableArray *routeArray;

- (LocationCoordinate *)locationWithIndex:(NSInteger)index;

@end
