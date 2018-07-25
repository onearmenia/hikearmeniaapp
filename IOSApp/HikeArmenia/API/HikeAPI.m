//
//  HikeAPI.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "HikeAPI.h"

static NSString *const kServiceAPIBaseURLKey = @"ServiceAPIBaseURL";
static NSString *const kServiceAPIVersionKey = @"ServiceAPIVersion";

@implementation HikeAPI

+ (HikeAPI *)instance {
	static dispatch_once_t singletonPredicate;
	static HikeAPI *singleton = nil;
	
	dispatch_once(&singletonPredicate, ^{
		singleton = [[super allocWithZone:nil] init];
	});
	
	return singleton;
}

- (void)setConfiguration:(NSDictionary *)configuration {
	self.serviceAPIBaseURL = [configuration objectForKey:kServiceAPIBaseURLKey];
	self.serviceAPIVersion = [configuration objectForKey:kServiceAPIVersionKey];
}

+ (NSString *)serviceAPIBaseURL {
	return [[HikeAPI instance] serviceAPIBaseURL];
}

+ (NSString *)serviceAPIVersion {
	return [[HikeAPI instance] serviceAPIVersion];
}

+ (NSString *)sessionToken {
	return [[HikeAPI instance] sessionToken];
}

@end
