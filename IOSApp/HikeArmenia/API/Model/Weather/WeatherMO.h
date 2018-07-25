//
//  WeatherMO.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface WeatherMO : NSManagedObject

@property (copy, nonatomic)		NSString *temperature;
@property (copy, nonatomic)		NSString *weatherIcon;

@end
