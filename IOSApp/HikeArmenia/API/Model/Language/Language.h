//
//  Language.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/17/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@interface Language : ServiceInvocation
@property (copy, nonatomic)		NSString *code;
@property (copy, nonatomic)     NSString *imageUrl;
@end
