//
//  ImageContentView.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/28/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ImageContentView.h"
#import "UIImageView+AFNetworking.h"

@implementation ImageContentView

- (void)layoutImage:(NSString *)urlStr {
    if(urlStr) {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [self.imageView setImageWithURLRequest:imageRequest
                              placeholderImage:[UIImage imageNamed:@"placeholderForTrail"]
                                       success:nil
                                       failure:nil];
    }
}

@end
