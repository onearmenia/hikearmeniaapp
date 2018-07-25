//
//  GuideMO.h
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/9/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface GuideMO : NSManagedObject

@property (assign, nonatomic)   NSInteger index;
@property (copy, nonatomic)		NSString *firstname;
@property (copy, nonatomic)     NSString *lastname;
@property (copy, nonatomic)     NSString *phone;
@property (copy, nonatomic)		NSString  *email;
@property (copy, nonatomic)     NSString *photo;
@property (assign, nonatomic)   float  averageRating;
@property (assign, nonatomic)   NSInteger reviewCount;
//@property (strong, nonatomic)	GuideReviews *reviews;
//@property (strong, nonatomic)	Languages *languages;

@end
