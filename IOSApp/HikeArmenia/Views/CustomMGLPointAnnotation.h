//
//  CustomMGLPointAnnotation.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 7/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/MGLPointAnnotation.h>
#import "Trail.h"
#import "Accomodation.h"

@interface CustomMGLPointAnnotation : MGLPointAnnotation

@property (strong, nonatomic) NSObject *obj;

@end
