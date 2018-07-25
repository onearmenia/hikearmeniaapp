//
//  LocationCoordinateMO.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/13/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface LocationCoordinateMO : NSManagedObject

@property (assign, nonatomic)   double latitude;
@property (assign, nonatomic)   double longitude;

@end
