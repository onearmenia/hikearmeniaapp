//
//  TrailReviewMO.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TrailReviewMO : NSManagedObject

@property (assign, nonatomic)   NSInteger index;
@property (assign, nonatomic)   NSInteger userId;
@property (copy, nonatomic)		NSString *firstname;
@property (copy, nonatomic)     NSString *lastname;
@property (copy, nonatomic)     NSString *avatar;
@property (copy, nonatomic)		NSString  *reviewText;
@property (assign, nonatomic)   NSInteger rating;

@end
