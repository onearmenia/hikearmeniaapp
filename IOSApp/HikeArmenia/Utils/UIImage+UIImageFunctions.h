//
//  UIImage+UIImageFunctions.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageFunctions)
- (UIImage *)scaleProportionalToSize:(CGSize)size1;
+(UIImage*)MergeImage:(UIImage*)img1 withImage:(UIImage*)img2;
@end
