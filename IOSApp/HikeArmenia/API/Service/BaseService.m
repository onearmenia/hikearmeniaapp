//
//  BaseService.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "BaseService.h"
#import "UIDevice+Hardware.h"
#import "HikeAPI.h"
#import "Definitions.h"

NSString *const kHTTPGetMethod = @"GET";
NSString *const kHTTPPostMethod = @"POST";
NSString *const kHTTPPutMethod = @"PUT";
NSString *const kHTTPDeleteMethod = @"DELETE";

@interface BaseService ()

@property (copy, nonatomic) ServiceCallback callback;
@property (strong, nonatomic) AFURLSessionManager *manager;

@end

@implementation BaseService

- (id)init {
	self = [super init];
	if (self) {
		self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
		NSOperationQueue *operationQueue = self.manager.operationQueue;
		[self.manager.reachabilityManager startMonitoring];
		[self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
			switch (status) {
				case AFNetworkReachabilityStatusReachableViaWWAN:
				case AFNetworkReachabilityStatusReachableViaWiFi:
					[operationQueue setSuspended:NO];
					break;
				case AFNetworkReachabilityStatusNotReachable:
				default:
///					[operationQueue setSuspended:YES];
					break;
			}
		}];
	}
	return self;
}

+ (NSDictionary *)debugHeaders {
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
	
	// debug headers
	UIDevice *device = [UIDevice currentDevice];
	[headers setObject:[device systemName] forKey:@"os.name"];
	[headers setObject:[device systemVersion] forKey:@"os.version"];
	[headers setObject:[device sysInfoByName:"hw.machine"] forKey:@"os.arch"];
	[headers setObject:[device sysInfoByName:"hw.model"] forKey:@"device.model"];
	
	return [headers copy];
}

- (void)invokeWithCallback:(ServiceCallback)callback {
	self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
	//    self.manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.url];
	request.timeoutInterval = self.requestTimeout;
	request.cachePolicy = self.cachePolicy;
	request.HTTPMethod = self.requestMethod;
	if (self.bodyData) {
		request.HTTPBody = self.bodyData;
	}
	if (self.headers) {
		[request setAllHTTPHeaderFields:self.headers];
	}
	
	if(self.requestType == RequestTypeData)
	{
		NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
			if (error) {
				NSLog(@"Error: %@", error);
				
				NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
				[self requestFinishedWithResponseStatusCode:statusCode result:nil contentLength:1 error:error];
				
			} else {
				NSLog(@"%@ %@", response, responseObject);
				
				NSLog(@"Content-lent: %lld", [response expectedContentLength]);
				
				NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
				[self requestFinishedWithResponseStatusCode:statusCode result:responseObject contentLength:[response expectedContentLength] error:nil];
			}
		}];
		[dataTask resume];
	}
	else
	{
		NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
			NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
			return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
		} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
			NSLog(@"File downloaded to: %@\n response = %@,\nerror = %@,\nstatusCode = %ld", filePath.relativePath, response, error, (long)statusCode);
			
			NSMutableDictionary *path = [[NSMutableDictionary alloc] init];
			if(filePath.relativePath)
				[path setObject:filePath.relativePath forKey:@"download_path"];
			
			NSMutableDictionary *responseObject = [[NSMutableDictionary alloc] init];
			[responseObject setObject:path forKey:@"result"];
			
			NSLog(@"Content-lent: %lld", [response expectedContentLength]);
			
			[self requestFinishedWithResponseStatusCode:statusCode result:responseObject contentLength:[response expectedContentLength] error:error];
		}];
		[downloadTask resume];
	}
	self.callback = callback;
}

- (void)requestFinishedWithResponseStatusCode:(NSInteger)statusCode result:(id)result contentLength:(long long)contentLength error:(NSError *)error {
	if (self.callback) {
		self.callback(result,contentLength,error);
	}
}

-(NSHTTPCookie *) getSessionCookie:(NSString *)domain
{
	NSString *sessionCookieId = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionCookie];
	
	NSHTTPCookie *cookie = nil;
	if (sessionCookieId) {
		NSString *cookieDomain;
		if ([domain hasPrefix:@"https://"]) {
			cookieDomain = [domain stringByReplacingOccurrencesOfString:@"https://" withString:@""];
		}
		else{
			cookieDomain = [domain stringByReplacingOccurrencesOfString:@"http://" withString:@""];
		}
		
		//Create a cookie
		NSDictionary *properties = [[NSMutableDictionary alloc] init];
		[properties setValue:[sessionCookieId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:NSHTTPCookieValue];
		[properties setValue:@"PHPSESSID" forKey:NSHTTPCookieName];
		[properties setValue:cookieDomain forKey:NSHTTPCookieDomain];
		[properties setValue:[NSDate dateWithTimeIntervalSinceNow:365*24*60*60] forKey:NSHTTPCookieExpires];
		[properties setValue:@"/" forKey:NSHTTPCookiePath];
		cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
	}
	return cookie;
}

@end
