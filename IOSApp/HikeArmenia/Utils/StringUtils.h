//
//  StringUtils.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject
+ (NSString *)safeStringWithString:(NSString *)string;
+ (NSString *)safeStringOrEmptyIfNilWithString:(NSString *)string;
@end
