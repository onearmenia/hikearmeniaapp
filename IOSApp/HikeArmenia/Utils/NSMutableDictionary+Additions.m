//
//  NSMutableDictionary+Additions.m
//  Atlantic
//
//  Created by Tigran Kirakosyan on 12/18/15.
//  Copyright (c) 2015 BigBek Ltd. All rights reserved.
//

#import "NSMutableDictionary+Additions.h"

@implementation NSMutableDictionary (Additions)

- (void)safeSetObject:(id)object forKey:(id<NSCopying>)key {
	if (object) {
		[self setObject:object forKey:key];
	}
}

@end
