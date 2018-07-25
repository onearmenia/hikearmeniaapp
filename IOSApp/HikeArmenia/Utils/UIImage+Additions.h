//
//  UIImage+Additions.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (id)imageWithSize:(CGSize)size color:(UIColor *)color;

- (UIImage *)duplicateImageWithSize:(CGSize)size;
- (UIImage *)maskWithImage:(UIImage *)maskImage;
- (UIImage *)duplicateImageWithOverlayImage:(UIImage *)overlayImage;
- (UIImage *)subImageWithRect:(CGRect)rect;
- (UIImage *)resizeImageWithInverseCapInsets:(UIEdgeInsets)insets toSize:(CGSize)size;
- (UIImage *)imageTintedWithColor:(UIColor *)tintColor;

+ (UIImage *)imageWithView:(UIView *)view;
+ (UIImage *)slicedImage:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath size:(CGSize)size;
+ (NSArray *)renderSlicesFromView:(UIView *)view numberOfcolumns:(NSInteger)numberOfColumns;

@end
