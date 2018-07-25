//
//  User.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "User.h"
#import "Definitions.h"
#import "StringUtils.h"
#import "NSMutableDictionary+Additions.h"
#import "OpenUDID.h"

@implementation User

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:[NSNumber numberWithInteger:self.index ] forKey:@"id"];
	[encoder encodeObject:self.firstName forKey:@"first_name"];
	[encoder encodeObject:self.lastName forKey:@"last_name"];
	[encoder encodeObject:self.email forKey:@"email"];
	[encoder encodeObject:self.phone forKey:@"phone"];
	[encoder encodeObject:self.authKey forKey:@"token"];
	[encoder encodeObject:self.photoURL forKey:@"avatar"];
	
	
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.index = [[decoder decodeObjectForKey:@"id"] intValue];
		self.firstName = [decoder decodeObjectForKey:@"first_name"];
		self.lastName = [decoder decodeObjectForKey:@"last_name"];
		self.email = [decoder decodeObjectForKey:@"email"];
		self.phone = [decoder decodeObjectForKey:@"phone"];
		self.authKey = [decoder decodeObjectForKey:@"token"];
		self.photoURL = [decoder decodeObjectForKey:@"avatar"];
		
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	User *newUser = [[[self class] alloc] init];
	if(newUser) {
		[newUser setIndex:[self index]];
		[newUser setFirstName:[self firstName]];
		[newUser setLastName:[self lastName]];
		[newUser setEmail:[self email]];
		[newUser setPhone:[self phone]];
		[newUser setAuthKey:[self authKey]];
		[newUser setPhotoURL:[self photoURL]];
		
	}
	return newUser;
}

+ (id)objectFromJSON:(id)json {
	User *user = nil;
	if ([json isKindOfClass:[NSDictionary class]]) {
		user = [[User alloc] init];
		
		user.index = [[json objectForKey:@"id"] integerValue];
		user.firstName = [json objectForKey:@"first_name"];
		user.lastName = [json objectForKey:@"last_name"];
		user.email = [json objectForKey:@"email"];
		user.phone = [json objectForKey:@"phone"];
		user.photoURL = [json objectForKey:@"avatar"];
		user.authKey = [json objectForKey:@"token"];
		
        if(user.authKey) {
			[[NSUserDefaults standardUserDefaults] setObject:user.authKey  forKey:ksessionAuthKey];
            [[NSUserDefaults standardUserDefaults] setObject:json forKey:ksessionUserDict];
        }
	}
	return user;
}

+ (void)signup:(NSString *)email passwd:(NSString *)passwd firstname:(NSString *)firstname lastname:(NSString *)lastname callback:(ServiceCallback)callback
{
	NSString *url = [self.class buildURLWithServiceName:@"api/register" URL:@""];
	
	NSMutableDictionary *bodyPayload = [[NSMutableDictionary alloc] init];
	[bodyPayload setObject:passwd forKey:@"password"];
	[bodyPayload setObject:email forKey:@"email"];
	[bodyPayload setObject:firstname forKey:@"first_name"];
	[bodyPayload setObject:lastname forKey:@"last_name"];
	[bodyPayload setObject:[NSString stringWithFormat:@"%@",[OpenUDID value]] forKey:@"udid"];
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyPayload options:0 error:&error];
	if (!error) {
		[self.class invokeWithRequestMethod:RequestMethodPost URL:url queryParameters:nil bodyPayload:jsonData callback:callback resultClass:[User class]];
	} else {
		callback(nil,0,error);
	}
}

+ (void)signupWithFacebook:(NSString *)currentAccessToken callback:(ServiceCallback)callback
{
    NSString *url = [self.class buildURLWithServiceName:@"api/login" URL:@""];
    
    NSMutableDictionary *bodyPayload = [[NSMutableDictionary alloc] init];
    [bodyPayload setObject:currentAccessToken forKey:@"fb_token"];
    [bodyPayload setObject:[NSString stringWithFormat:@"%@",[OpenUDID value]] forKey:@"udid"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyPayload options:0 error:&error];
    if (!error) {
        [self.class invokeWithRequestMethod:RequestMethodPost URL:url queryParameters:nil bodyPayload:jsonData callback:callback resultClass:[User class]];
    } else {
        callback(nil,0,error);
    }
}

+ (void)login:(NSString *)email passwd:(NSString *)passwd callback:(ServiceCallback)callback
{
	NSString *url = [self.class buildURLWithServiceName:@"api/login" URL:@""];
	
	NSMutableDictionary *bodyPayload = [[NSMutableDictionary alloc] init];
	[bodyPayload setObject:email forKey:@"email"];
	[bodyPayload setObject:passwd forKey:@"password"];
	[bodyPayload setObject:[NSString stringWithFormat:@"%@",[OpenUDID value]] forKey:@"udid"];
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyPayload options:0 error:&error];
	if (!error) {
		[self.class invokeWithRequestMethod:RequestMethodPost URL:url queryParameters:nil bodyPayload:jsonData callback:callback resultClass:[User class]];
	} else {
		callback(nil,0,error);
	}
}

+ (void)loadUserWithCallback:(ServiceCallback)callback {
	NSString *url = [self.class buildURLWithServiceName:@"api/user" URL:@""];
	
	[self.class invokeWithRequestMethod:RequestMethodGet URL:url queryParameters:nil bodyPayload:nil callback:callback resultClass:[User class]];
}

- (void)saveUserWithCallback:(ServiceCallback)callback {
	NSString *url = [self.class buildURLWithServiceName:[NSString stringWithFormat:@"api/user/%lu",(long)self.index] URL:@""];
	
	NSMutableDictionary *bodyPayload = [[NSMutableDictionary alloc] init];
	[bodyPayload setObject:self.firstName forKey:@"first_name"];
	[bodyPayload setObject:self.lastName forKey:@"last_name"];
	[bodyPayload setObject:self.phone forKey:@"phone"];
	[bodyPayload setObject:self.email forKey:@"email"];
	NSString *imageString = [UIImageJPEGRepresentation(self.avatar, 0.2f) base64EncodedStringWithOptions:0];
	if(imageString)
		[bodyPayload setObject:imageString forKey:@"avatar"];
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyPayload options:0 error:&error];
	if (!error) {
		[self.class invokeWithRequestMethod:RequestMethodPut URL:url queryParameters:nil bodyPayload:jsonData callback:callback resultClass:[User class]];
	} else {
		callback(nil,0,error);
	}
}

- (void)changePassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword callback:(ServiceCallback)callback
{
	NSString *url = [self.class buildURLWithServiceName:@"api/change-password" URL:@""];
	
	NSMutableDictionary *bodyPayload = [[NSMutableDictionary alloc] init];
	[bodyPayload setObject:oldPassword forKey:@"old_password"];
	[bodyPayload setObject:newPassword forKey:@"new_password"];
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyPayload options:0 error:&error];
	if (!error) {
		[self.class invokeWithRequestMethod:RequestMethodPost URL:url queryParameters:nil bodyPayload:jsonData callback:^(id result,long long contentLength, NSError *error) {
			if(!error)
			{
				if ([result isKindOfClass:[NSDictionary class]]) {
					NSInteger code = [[result objectForKey:@"code"] integerValue];
					if(code == 200)
						callback([NSNumber numberWithBool:YES],1, nil);
					else
						callback([NSNumber numberWithBool:NO],1, nil);
				}
				else
					callback([NSNumber numberWithBool:NO],1, error);
			}
			else
			{
				callback([NSNumber numberWithBool:NO],1, error);
			}
			
		} resultClass:nil];
	} else {
		callback(nil,0,error);
	}
}

+ (void)logoutWithCallback:(ServiceCallback)callback {
	NSString *url = [self.class buildURLWithServiceName:@"api/logout" URL:@""];
	
	[self.class invokeWithRequestMethod:RequestMethodPost URL:url queryParameters:nil bodyPayload:nil callback:^(id result,long long contentLength, NSError *error) {
		if(!error)
		{
			if ([result isKindOfClass:[NSDictionary class]]) {
				NSInteger code = [[result objectForKey:@"code"] integerValue];
				if(code == 200)
					callback([NSNumber numberWithBool:YES],1, nil);
				else
					callback([NSNumber numberWithBool:NO],1, nil);
			}
			else
				callback([NSNumber numberWithBool:NO],1, error);
		}
		else
		{
			callback([NSNumber numberWithBool:NO],1, error);
		}
		
	} resultClass:nil];
}

- (void)forgotPasswordWithCallback:(ServiceCallback)callback {
	NSString *url = [self.class buildURLWithServiceName:@"api/forgot-password" URL:@""];
	
	NSMutableDictionary *bodyPayload = [[NSMutableDictionary alloc] init];
	[bodyPayload setObject:self.email forKey:@"email"];
	
	NSError *error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyPayload options:0 error:&error];
	if (!error) {
		[self.class invokeWithRequestMethod:RequestMethodPost URL:url queryParameters:nil bodyPayload:jsonData callback:^(id result,long long contentLength, NSError *error) {
			if(!error)
			{
				if ([result isKindOfClass:[NSDictionary class]]) {
					NSInteger code = [[result objectForKey:@"code"] integerValue];
					if(code == 200)
						callback([NSNumber numberWithBool:YES],1, nil);
					else
						callback([NSNumber numberWithBool:NO],1, nil);
				}
				else
					callback([NSNumber numberWithBool:NO],1, error);
			}
			else
			{
				callback([NSNumber numberWithBool:NO],1, error);
			}
			
		} resultClass:nil];
	} else {
		callback(nil,0,error);
	}
}

- (NSDictionary *)objectToDictionary {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict safeSetObject:[NSNumber numberWithInteger:self.index] forKey:@"id"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.firstName] forKey:@"first_name"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.lastName] forKey:@"last_name"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.email] forKey:@"email"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.phone] forKey:@"phone"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.photoURL] forKey:@"avatar"];
	return [dict copy];
}

@end
