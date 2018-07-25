//
//  BaseService.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

extern NSString *const kHTTPGetMethod;
extern NSString *const kHTTPPostMethod;
extern NSString *const kHTTPPutMethod;
extern NSString *const kHTTPDeleteMethod;


typedef enum {
	RequestTypeData,
	RequestTypeDownload,
	RequestTypeUpload,
} RequestType;

typedef void(^ServiceCallback)(id result, long long contentLength, NSError *error);

@interface BaseService : NSObject

@property (copy, nonatomic) NSURL *url;
@property (copy, nonatomic) NSString *requestMethod;
@property (assign, nonatomic) RequestType requestType;
@property (copy, nonatomic) NSData *bodyData;
@property (copy, nonatomic) NSDictionary *headers;
@property (assign, nonatomic) NSTimeInterval requestTimeout;
@property (assign, nonatomic) NSURLRequestCachePolicy cachePolicy;

+ (NSDictionary *)debugHeaders;

- (void)invokeWithCallback:(ServiceCallback)callback;

- (void)requestFinishedWithResponseStatusCode:(NSInteger)statusCode result:(id)result contentLength:(long long) contentLength error:(NSError *)error;

@end
