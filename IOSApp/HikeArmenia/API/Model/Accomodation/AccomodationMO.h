//
//  AccomodationMO.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AccomodationMO : NSManagedObject

@property (assign, nonatomic)   NSInteger index;
@property (copy, nonatomic)		NSString  *name;
@property (copy, nonatomic)		NSString  *desc;
@property (copy, nonatomic)     NSString  *phone;
@property (copy, nonatomic)     NSString  *price;
@property (copy, nonatomic)		NSString  *email;
@property (copy, nonatomic)		NSString  *cover;
@property (copy, nonatomic)     NSString  *facilities;
@property (copy, nonatomic)     NSString  *url;

@end
