//
//  Trails.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@interface Trails : ServiceInvocation
@property (strong, nonatomic) NSMutableArray *trailsArray;

+ (void)loadTrailsWithCallback:(ServiceCallback)callback;
@end
