//
//  NSMutableDictionary+Additions.h
//  Atlantic
//
//  Created by Tigran Kirakosyan on 12/18/15.
//  Copyright (c) 2015 BigBek Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Additions)

- (void)safeSetObject:(id)object forKey:(id<NSCopying>)key;

@end

