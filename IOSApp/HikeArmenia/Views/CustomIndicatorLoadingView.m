//
//  CustomIndicatorLoadingView.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 5/27/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "CustomIndicatorLoadingView.h"
static UIImageView *indicatorImageView;
static UIView *bgView;
static NSInteger counter;
static CustomIndicatorLoadingView * staticCustomIndicatorLoadingView;

@interface CustomIndicatorLoadingView()
@end


@implementation CustomIndicatorLoadingView

- (id)init {
    if (!staticCustomIndicatorLoadingView) {
        self = [super init];
        staticCustomIndicatorLoadingView = self;
        indicatorImageView = [[UIImageView alloc] init];
        bgView = [[UIView alloc] init];
        counter = 0;
    }
    return staticCustomIndicatorLoadingView;
}


+ (void)showIndicator
{
    if (!staticCustomIndicatorLoadingView) {
        staticCustomIndicatorLoadingView = [[CustomIndicatorLoadingView alloc] init];
    }

    counter ++;
    if (counter <= 1) {
        [staticCustomIndicatorLoadingView configureIndicatorView];
    }
}

+ (void)hideIndicator
{
    counter--;
    if(counter < 1){
        counter = 0;
        [indicatorImageView stopAnimating];
        bgView.hidden = YES;
    }
}


- (void)configureIndicatorView {
    NSArray *images = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"animation_0000_Layer-36"],
                       [UIImage imageNamed:@"animation_0001_Layer-35"],
                       [UIImage imageNamed:@"animation_0002_Layer-34"],
                       [UIImage imageNamed:@"animation_0003_Layer-33"],
                       [UIImage imageNamed:@"animation_0004_Layer-32"],
                       [UIImage imageNamed:@"animation_0005_Layer-31"],
                       [UIImage imageNamed:@"animation_0006_Layer-30"],
                       [UIImage imageNamed:@"animation_0007_Layer-29"],
                       [UIImage imageNamed:@"animation_0008_Layer-28"],
                       [UIImage imageNamed:@"animation_0009_Layer-27"],
                       [UIImage imageNamed:@"animation_0010_Layer-26"],
                       [UIImage imageNamed:@"animation_0011_Layer-25"],
                       [UIImage imageNamed:@"animation_0012_Layer-24"],
                       [UIImage imageNamed:@"animation_0013_Layer-23"],
                       [UIImage imageNamed:@"animation_0014_Layer-22"],
                       [UIImage imageNamed:@"animation_0015_Layer-21"],
                       [UIImage imageNamed:@"animation_0016_Layer-20"],
                       [UIImage imageNamed:@"animation_0017_Layer-19"],
                       [UIImage imageNamed:@"animation_0018_Layer-18"],
                       [UIImage imageNamed:@"animation_0019_Layer-17"],
                       [UIImage imageNamed:@"animation_0020_Layer-16"],
                       [UIImage imageNamed:@"animation_0021_Layer-15"],
                       [UIImage imageNamed:@"animation_0022_Layer-14"],
                       [UIImage imageNamed:@"animation_0023_Layer-13"],
                       [UIImage imageNamed:@"animation_0024_Layer-12"],
                       [UIImage imageNamed:@"animation_0025_Layer-11"],
                       [UIImage imageNamed:@"animation_0026_Layer-10"],
                       [UIImage imageNamed:@"animation_0027_Layer-9"],
                       [UIImage imageNamed:@"animation_0028_Layer-8"],
                       [UIImage imageNamed:@"animation_0029_Layer-7"],
                       [UIImage imageNamed:@"animation_0030_Layer-6"],
                       [UIImage imageNamed:@"animation_0031_Layer-5"],
                       [UIImage imageNamed:@"animation_0032_Layer-4"],
                       [UIImage imageNamed:@"animation_0033_Layer-3"],
                       [UIImage imageNamed:@"animation_0034_Layer-2"],
                       [UIImage imageNamed:@"animation_0035_Layer-1"], nil];
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    indicatorImageView = [[UIImageView alloc] init];
    [bgView addSubview:indicatorImageView];
    
    indicatorImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [indicatorImageView addConstraint:[NSLayoutConstraint constraintWithItem:indicatorImageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:50.0]];
    [indicatorImageView addConstraint:[NSLayoutConstraint constraintWithItem:indicatorImageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:50.0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:indicatorImageView
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:bgView
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1
                                                        constant:0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:indicatorImageView
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:bgView
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1
                                                        constant:0]];
    
    
    indicatorImageView.animationImages =  images;
    indicatorImageView.animationDuration = 1.0;
    [indicatorImageView startAnimating];
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
}

@end
