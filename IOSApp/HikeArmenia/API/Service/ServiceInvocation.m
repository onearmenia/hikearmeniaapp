//
//  ServiceInvocation.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"
#import "HikeAPI.h"
#import "UIDevice+Hardware.h"

NSString *const kCharset = @"UTF-8";

@implementation QueryParameter

- (id)initWithKey:(NSString *)key value:(NSObject<NSCopying> *)value {
	self = [super init];
	if (self) {
		self.key = key;
		self.value = value;
	}
	return self;
}
@end

@interface ServiceInvocation ()

+ (NSString *)urlEncodeKey:(NSString *)key value:(NSString *)value;
+ (NSDictionary *)defaultHeaders;
+ (APIService *)createServiceConnectionWithURL:(NSString *)url query:(NSString *)query;
+ (APIService *)createGetConnectionWithURL:(NSString *)url query:(NSString *)query;
+ (APIService *)createPostConnectionWithURL:(NSString *)url query:(NSString *)query bodyPayload:(NSData *)bodyPayload;
+ (APIService *)createPutConnectionWithURL:(NSString *)url query:(NSString *)query bodyPayload:(NSData *)bodyPayload;
+ (APIService *)createDeleteConnectionWithURL:(NSString *)url query:(NSString *)query;
+ (NSString *)createQueryWithQueryParameters:(NSArray *)params;

@end

@implementation ServiceInvocation

+ (NSString *)createFilterWithFields:(NSArray *)fields {
	NSMutableString *filter = [[NSMutableString alloc] init];
	for (NSString *field in fields) {
		if ([filter length] > 0) {
			[filter appendString:@","];
		}
		[filter appendString:[[NSString alloc] initWithFormat:@"%@", field]];
	}
	return [filter copy];
}

+ (NSString *)buildURLWithServiceName:(NSString *)serviceName URL:(NSString *)url {
	
	if([url isEqualToString:@""])
		return [[NSString alloc] initWithFormat:@"%@/%@", [HikeAPI serviceAPIBaseURL], serviceName];
	else
		return [[NSString alloc] initWithFormat:@"%@/%@/%@", [HikeAPI serviceAPIBaseURL], serviceName, url];
	
}

+ (NSString *)urlEncodeKey:(NSString *)key value:(NSString *)value {
	return [[NSString alloc] initWithFormat:@"%@=%@",
			[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
			[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSDictionary *)defaultHeaders {
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
	[headers setObject:kCharset forKey:@"Accept-Charset"];
	[headers setObject:[HikeAPI serviceAPIVersion] forKey:@"HikeArmenia-VERSION"];
	NSString *sessionToken = [HikeAPI sessionToken];
	if (sessionToken) {
		[headers setObject:[NSString stringWithFormat:@"%@", sessionToken] forKey:@"X_HTTP_AUTH_TOKEN"];
	}
	
	[headers addEntriesFromDictionary:[APIService debugHeaders]];
	
	return [headers copy];
}

+ (APIService *)createServiceConnectionWithURL:(NSString *)url query:(NSString *)query {
	//	APIService *request = [APIService instance];
	APIService *request = [[APIService alloc] init];// ???
	NSMutableString *urlString = [[NSMutableString alloc] init];
	[urlString appendString:url];
	if ([query length] > 0) {
		[urlString appendFormat:@"?%@", query];
	}
	request.url = [[NSURL alloc] initWithString:urlString];
	request.requestTimeout = 20.0;
	request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
	request.headers = [self defaultHeaders];
	request.bodyData = nil;
	return request;
}

+ (APIService *)createGetConnectionWithURL:(NSString *)url query:(NSString *)query {
	APIService *request = [self createServiceConnectionWithURL:url query:query];
	request.requestMethod = kHTTPGetMethod;
	request.requestType = RequestTypeData;
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
	[headers setObject:[[NSString alloc] initWithFormat:@"application/json; charset=%@", kCharset] forKey:@"Content-Type"];
	request.headers = [headers copy];
	return request;
}

+ (APIService *)createGetDownloadConnectionWithURL:(NSString *)url query:(NSString *)query {
	APIService *request = [self createServiceConnectionWithURL:url query:query];
	request.requestMethod = kHTTPGetMethod;
	request.requestType = RequestTypeDownload;
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
	[headers setObject:[[NSString alloc] initWithFormat:@"application/x-www-form-urlencoded"] forKey:@"Content-Type"];
	request.headers = [headers copy];
	request.bodyData = nil;
	return request;
}

+ (APIService *)createPostDownloadConnectionWithURL:(NSString *)url query:(NSString *)query bodyPayload:(NSData *)bodyPayload {
	APIService *request = [self createServiceConnectionWithURL:url query:query];
	request.requestMethod = kHTTPPostMethod;
	request.requestType = RequestTypeDownload;
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
	[headers setObject:[[NSString alloc] initWithFormat:@"application/x-www-form-urlencoded"] forKey:@"Content-Type"];
	request.headers = [headers copy];
	request.bodyData = bodyPayload;
	return request;
}

+ (APIService *)createPostConnectionWithURL:(NSString *)url query:(NSString *)query bodyPayload:(NSData *)bodyPayload {
	APIService *request = [self createServiceConnectionWithURL:url query:query];
	request.requestMethod = kHTTPPostMethod;
	request.requestType = RequestTypeData;
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
	[headers setObject:[[NSString alloc] initWithFormat:@"application/json; charset=%@", kCharset] forKey:@"Content-Type"];
	request.headers = [headers copy];
	request.bodyData = bodyPayload;
	return request;
}

+ (APIService *)createPutConnectionWithURL:(NSString *)url query:(NSString *)query bodyPayload:(NSData *)bodyPayload {
	APIService *request = [self createServiceConnectionWithURL:url query:query];
	request.requestMethod = kHTTPPutMethod;
	request.requestType = RequestTypeData;
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
	[headers setObject:[[NSString alloc] initWithFormat:@"application/json; charset=%@", kCharset] forKey:@"Content-Type"];
	request.headers = [headers copy];
	request.bodyData = bodyPayload;
	return request;
}

+ (APIService *)createDeleteConnectionWithURL:(NSString *)url query:(NSString *)query {
	APIService *request = [self createServiceConnectionWithURL:url query:query];
	request.requestMethod = kHTTPDeleteMethod;
	request.requestType = RequestTypeData;
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
	[headers setObject:[[NSString alloc] initWithFormat:@"application/json; charset=%@", kCharset] forKey:@"Content-Type"];
	request.headers = [headers copy];
	return request;
}

+ (NSString *)createQueryWithQueryParameters:(NSArray *)params {
	NSMutableString *query = [[NSMutableString alloc] init];
	for (QueryParameter *param in params) {
		if ([query length] > 0) {
			[query appendString:@"&"];
		}
		[query appendString:[self urlEncodeKey:param.key value:[[NSString alloc] initWithFormat:@"%@", param.value]]];
	}
	return [query copy];
}

+ (void)invokeWithRequestMethod:(RequestMethod)method URL:(NSString *)url queryParameters:(NSArray *)queryParams
					bodyPayload:(NSData *)bodyPayload callback:(ServiceCallback)callback resultClass:(Class)cls {
	[self invokeWithRequestMethod:method URL:url queryParameters:queryParams bodyPayload:bodyPayload additionalHeaders:nil callback:callback resultClass:cls];
}

+ (void)invokeWithRequestMethod:(RequestMethod)method URL:(NSString *)url queryParameters:(NSArray *)queryParams
					bodyPayload:(NSData *)bodyPayload additionalHeaders:(NSDictionary *)additionalHeaders callback:(ServiceCallback)callback resultClass:(Class)cls {
	NSString *query = [self createQueryWithQueryParameters:queryParams];
	
	APIService *request = nil;
	switch (method) {
		case RequestMethodGet:
			request = [self createGetConnectionWithURL:url query:query];
			break;
		case RequestMethodPost:
			request = [self createPostConnectionWithURL:url query:query bodyPayload:bodyPayload];
			break;
		case RequestMethodPut:
			request = [self createPutConnectionWithURL:url query:query bodyPayload:bodyPayload];
			break;
		case RequestMethodDelete:
			request = [self createDeleteConnectionWithURL:url query:query];
			break;
		case RequestMethodGetDownload:
			request = [self createGetDownloadConnectionWithURL:url query:query];
			break;
		case RequestMethodPostDownload:
			request = [self createPostDownloadConnectionWithURL:url query:query bodyPayload:bodyPayload];
			break;
		default:
			break;
	}
	
	if (request) {
		if (additionalHeaders) {
			NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:request.headers];
			[headers addEntriesFromDictionary:additionalHeaders];
			request.headers = [headers copy];
		}
		[request invokeWithCallback:^(id result,long long contentLength, NSError *error) {
			id object;
			if ([cls respondsToSelector:@selector(objectFromJSON:)]) {
				object = [cls objectFromJSON:result];
			} else {
				object = result;
			}
			callback(object, contentLength, error);
		}];
	}
}

+ (id)objectFromJSON:(id)json {
	return json;
}

- (NSDictionary *)objectToDictionary {
	return nil;
}

- (NSArray *)objectsToArray {
	return nil;
}

@end
