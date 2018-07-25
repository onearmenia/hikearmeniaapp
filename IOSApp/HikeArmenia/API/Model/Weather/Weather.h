//
//  Weather.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/16/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@interface Weather : ServiceInvocation
@property (copy, nonatomic)		NSString *temperature;
@property (copy, nonatomic)		NSString *weatherIcon;
@end