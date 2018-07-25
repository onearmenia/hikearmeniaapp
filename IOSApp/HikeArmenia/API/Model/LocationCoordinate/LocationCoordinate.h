//
//  LocationCoordinate.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/6/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@interface LocationCoordinate : ServiceInvocation
@property (assign, nonatomic)   double latitude;
@property (assign, nonatomic)   double longitude;
@end
