//
//  UIView+Additions.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 7/5/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

+ (void)addGradientBottomToView:(UIView *)view
{
    view.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //gradient.opacity = 0.5f;
    //gradient.frame = view.bounds;
    float x = view.frame.origin.x;
    float y =view.frame.size.height/2;
    float width = view.frame.size.width;
    float height = view.frame.size.height/2;
    gradient.frame = CGRectMake(x, y, width, height);
    gradient.colors = @[(id)([UIColor clearColor].CGColor), (id)[[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7] CGColor]];
    [view.layer insertSublayer:gradient atIndex:0];
}

+ (void)addGradientTopToView:(UIView *)view
{
    view.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //gradient.opacity = 0.5f;
    //gradient.frame = view.bounds;
    float x = 0;
    float y = 0;
    float width = view.frame.size.width;
    float height = view.frame.size.height/2;
    gradient.frame = CGRectMake(x, y, width, height);
    gradient.colors = @[(id)[[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7] CGColor], (id)([UIColor clearColor].CGColor)];
    [view.layer insertSublayer:gradient atIndex:0];
}

@end
