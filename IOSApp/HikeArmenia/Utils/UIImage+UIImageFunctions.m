//
//  UIImage+UIImageFunctions.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "UIImage+UIImageFunctions.h"

@implementation UIImage (UIImageFunctions)

- (UIImage *)scaleToSize: (CGSize)size
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
	CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
	
	if(self.imageOrientation == UIImageOrientationRight)
	{
		CGContextRotateCTM(context, -M_PI_2);
		CGContextTranslateCTM(context, -size.height, 0.0f);
		CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
	}
	else if(self.imageOrientation == UIImageOrientationDown)
	{
		CGContextRotateCTM(context, M_PI);
		CGContextTranslateCTM(context, -size.width, -size.height);
		CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
	}
	else if(self.imageOrientation == UIImageOrientationLeft)
	{
		CGContextRotateCTM(context, M_PI_2);
		CGContextTranslateCTM(context, 0.0f,-size.width);
		CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
	}
	else
		CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
	
	CGImageRef scaledImage=CGBitmapContextCreateImage(context);
	
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	
	UIImage *image = [UIImage imageWithCGImage: scaledImage];
	
	CGImageRelease(scaledImage);
	
	return image;
}

- (UIImage *)scaleProportionalToSize:(CGSize)size1
{
	CGSize size = size1;
	if(self.size.width>self.size.height)
	{
		size1=CGSizeMake((self.size.width/self.size.height)*size1.height,size1.height);
	}
	else
	{
		size1=CGSizeMake(size1.width,(self.size.height/self.size.width)*size1.width);
	}

	if(size1.width > size.width)
	{
		size1=CGSizeMake((size.width/size1.width)*size1.width,(size.width/size1.width)*size1.height);
	}
	if(size1.height>size.height)
	{
		size1=CGSizeMake((size.height/size1.height)*size1.width,(size.height/size1.height)*size1.height);
	}
	
	return [self scaleToSize:size1];
}

+(UIImage*)MergeImage:(UIImage*)img1 withImage:(UIImage*)img2
{
//    //return value
//    UIImage* result = nil;
//    
//    //convert image1 from UIImage to CGImageRef to get Width and Height
//    CGImageRef img1Ref = img1.CGImage;
//    float img1W        = CGImageGetWidth(img1Ref);
//    float img1H        = CGImageGetHeight(img1Ref);
//    
//    //convert image2 from UIImage to CGImage to get Width and Height
//    CGImageRef img2Ref = img2.CGImage;
//    float img2W        = CGImageGetWidth(img2Ref);
//    float img2H        = CGImageGetHeight(img2Ref);
//    
//    //Create output image size
//    CGSize size = CGSizeMake(MAX(img1W, img2W), MAX(img1H, img2H));
//    
//    //Start image context to draw the two images
//    UIGraphicsBeginImageContext(size);
//    
//    //draw two images in the context
//    [img1 drawInRect:CGRectMake(0, 0, img1W, img1H)];
//    [img2 drawInRect:CGRectMake(img1W-img2W, img1H-img2H, img2W, img2H)];
//    
//    //get the result of drawing as UIImage
//    result = UIGraphicsGetImageFromCurrentImageContext();
//    
//    //End and close context
//    UIGraphicsEndImageContext();
//    
//    //release All CGImageRef 's
////    CGImageRelease(img2Ref);
////    CGImageRelease(img1Ref);
//    
//    //return value :)
//    return result;
    
    
    
    
    
    
    CGSize newSize = CGSizeMake(img1.size.width, img1.size.height);
    UIGraphicsBeginImageContext(newSize);
    
    // Use existing opacity as is
    [img1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity if applicable
    // Change xPos, yPos if applicable
    float x =img1.size.width-5*img2.size.width-20.0;
    float y = img1.size.height-5*img2.size.height-250.0;
    float width = 5*img2.size.width;
    float height = 5*img2.size.height;
    [img2 drawInRect:CGRectMake(x, y, width, height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}
@end
