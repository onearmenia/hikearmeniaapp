//
//  Guide.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@class GuideReviews;
@class Languages;

@interface Guide : ServiceInvocation

@property (assign, nonatomic)   NSInteger index;
@property (copy, nonatomic)		NSString *firstname;
@property (copy, nonatomic)     NSString *lastname;
@property (copy, nonatomic)     NSString *guideDescription;
@property (copy, nonatomic)     NSString *phone;
@property (copy, nonatomic)		NSString  *email;
@property (copy, nonatomic)     NSString *photoURL;
@property (assign, nonatomic)   float  averageRating;
@property (assign, nonatomic)   NSInteger reviewCount;
@property (strong, nonatomic)	GuideReviews *reviews;
@property (strong, nonatomic)	Languages *languages;

- (void)loadGuideWithCallback:(ServiceCallback)callback;
- (void)addReview:(NSString *)review withRating:(NSInteger)rating callback:(ServiceCallback)callback;

@end
