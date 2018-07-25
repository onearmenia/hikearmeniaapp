//
//  CustomCalloutView.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 7/6/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMGLPointAnnotation.h"
@import Mapbox;

@interface CustomCalloutView : UIView <MGLCalloutView>

@property (strong, nonatomic)CustomMGLPointAnnotation *annotation;
@end
