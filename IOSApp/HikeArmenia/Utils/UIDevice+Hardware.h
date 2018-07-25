//
//  UIDevice+Hardware.h
//  Stockfish
//
//  Created by Tigran Kirakosyan on 2/10/16.
//

#import <UIKit/UIKit.h>

#define IS_RETINA ([UIScreen mainScreen].scale == 2.0)

@interface UIDevice (Hardware)

- (NSString *)sysInfoByName:(char *)typeSpecifier;
- (NSUInteger)sysInfo:(uint)typeSpecifier;
+ (CGFloat) windowHeight;
+ (CGFloat) windowWidth;
@end
