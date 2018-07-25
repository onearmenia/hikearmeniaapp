//
//  APIService.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "BaseService.h"

extern NSString *const kAPIErrorDomain;
extern NSInteger const kServerErrorCode;
extern NSInteger const kInvalidDataErrorCode;

@interface APIService : BaseService

+ (APIService *)instance;

@end
