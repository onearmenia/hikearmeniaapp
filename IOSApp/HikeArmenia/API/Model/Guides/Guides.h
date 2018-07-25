//
//  Guides.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@interface Guides : ServiceInvocation
@property (strong, nonatomic) NSMutableArray *guidesArray;

+ (void)loadGuidesWithCallback:(ServiceCallback)callback;
+ (void)loadGuidesForTrailId:(NSInteger)trailId WithCallback:(ServiceCallback)callback;
@end
