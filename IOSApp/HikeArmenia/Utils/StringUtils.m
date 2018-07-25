//
//  StringUtils.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+ (NSString *)safeStringWithString:(NSString *)string {
	NSString *result = nil;
	if (string) {
		result = [NSString stringWithFormat:@"%@", string];
	}
	return result;
}

+ (NSString *)safeStringOrEmptyIfNilWithString:(NSString *)string {
	NSString *result = [self safeStringWithString:string];
	if (!result) {
		result = @"";
	}
	return result;
}

@end
