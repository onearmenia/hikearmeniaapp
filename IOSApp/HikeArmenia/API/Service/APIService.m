//
//  APIService.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "APIService.h"
#import "AppDelegate.h"
#import "Definitions.h"

NSString *const kAPIErrorDomain = @"APIErrorDomain";
NSInteger const kServerErrorCode = 1;
NSInteger const kIvalidDataErrorCode = 2;
static NSString *internetReachabilityMessage = @"Please turn on your internet and enjoy HikeArmenia";


@implementation APIService

+ (APIService *)instance {
	static dispatch_once_t singletonPredicate;
	static APIService *singleton = nil;
	
	dispatch_once(&singletonPredicate, ^{
		singleton = [[super allocWithZone:nil] init];
	});
	
	return singleton;
}

- (void)requestFinishedWithResponseStatusCode:(NSInteger)statusCode result:(id)result contentLength:(long long) contentLength error:(NSError *)error {
	if (result) {
		if ([result isKindOfClass:[NSDictionary class]]) {
			id errorObject = [result valueForKey:@"error"];
			if ([errorObject isKindOfClass:[NSDictionary class]]) {
				NSString *errorMessage = [errorObject valueForKey:@"message"];
				NSInteger errorCode = [[errorObject valueForKey:@"code"] integerValue];
				NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil];
				error = [[NSError alloc] initWithDomain:kAPIErrorDomain code:errorCode userInfo:userInfo];
			} else {
				result = [result valueForKey:@"result"];
			}
		} else {
			result = [result valueForKey:@"result"];
		}
	}
	
	[super requestFinishedWithResponseStatusCode:statusCode result:result contentLength:contentLength error:error];
}

@end
