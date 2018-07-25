//
//  ImageContentView.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/28/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageContentView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)layoutImage:(NSString *)urlStr;
@end
