//
//  Language.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/17/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "Language.h"
#import "StringUtils.h"
#import "NSMutableDictionary+Additions.h"

@implementation Language

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:self.code forKey:@"lang_code"];
	[encoder encodeObject:self.imageUrl forKey:@"lang_img"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {

		self.code = [decoder decodeObjectForKey:@"lang_code"];
		self.imageUrl = [decoder decodeObjectForKey:@"lang_img"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	Language *newLanguage = [[[self class] alloc] init];
	if(newLanguage) {
		[newLanguage setCode:[self code]];
		[newLanguage setImageUrl:[self imageUrl]];
	}
	return newLanguage;
}

+ (id)objectFromJSON:(id)json {
	Language *language = nil;
	if ([json isKindOfClass:[NSDictionary class]]) {
		language = [[Language alloc] init];
		
		language.code = [json objectForKey:@"lang_code"];
		language.imageUrl = [json objectForKey:@"lang_img"];
	}
	return language;
}

- (NSDictionary *)objectToDictionary {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict safeSetObject:[StringUtils safeStringWithString:self.code] forKey:@"lang_code"];
	[dict safeSetObject:[StringUtils safeStringWithString:self.imageUrl] forKey:@"lang_img"];
	
	return [dict copy];
}

@end
