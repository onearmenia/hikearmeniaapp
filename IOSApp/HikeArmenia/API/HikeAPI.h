//
//  HikeAPI.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HikeAPI : NSObject

@property (copy, nonatomic) NSString *serviceAPIBaseURL;
@property (copy, nonatomic) NSString *serviceAPIVersion;
@property (copy, nonatomic) NSString *sessionToken;

+ (HikeAPI *)instance;

- (void)setConfiguration:(NSDictionary *)configuration;

+ (NSString *)serviceAPIBaseURL;
+ (NSString *)serviceAPIVersion;
+ (NSString *)sessionToken;

@end
