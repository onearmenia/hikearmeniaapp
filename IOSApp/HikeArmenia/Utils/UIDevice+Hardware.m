//
//  UIDevice+Hardware.m
//  Stockfish
//
//  Created by Tigran Kirakosyan on 2/10/16.
//

#import "UIDevice+Hardware.h"
#import <sys/sysctl.h>

@implementation UIDevice (Hardware)

#pragma mark sysctlbyname utils
- (NSString *)sysInfoByName:(char *)typeSpecifier {
	size_t size;
	sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);

	char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);

	NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];

	free(answer);
	return results;
}

#pragma mark sysctl utils
- (NSUInteger)sysInfo:(uint)typeSpecifier {
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	return (NSUInteger) results;
}

+ (CGFloat) windowHeight   {
    return [UIScreen mainScreen].applicationFrame.size.height;
}

+ (CGFloat) windowWidth   {
    return [UIScreen mainScreen].applicationFrame.size.width;
}

@end
