//
//  Languages.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/17/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "Languages.h"
#import "Language.h"

@implementation Languages

- (id)copyWithZone:(NSZone *)zone
{
	Languages *newLanguages = [[[self class] alloc] init];
	if(newLanguages) {
		[newLanguages setLanguageArray:[self.languageArray copy]];
	}
	return newLanguages;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	
	[encoder encodeObject:self.languageArray forKey:@"data"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if((self = [super init])) {
		self.languageArray = [decoder decodeObjectForKey:@"data"];
	}
	return self;
}

+ (id)objectFromJSON:(id)json {
	Languages *languages = nil;
	languages.languageArray = (NSMutableArray *)json;
	
	if ([json isKindOfClass:[NSArray class]]) {
		NSMutableArray *languagesList = [[NSMutableArray alloc] init];
		for (id languageJson in json) {
			Language *language = [Language objectFromJSON:languageJson];
			if (language) {
				[languagesList addObject:language];
			}
		}
		languages = [[Languages alloc] init];
		languages.languageArray = [languagesList copy];
	}
	return languages;
}

@end
