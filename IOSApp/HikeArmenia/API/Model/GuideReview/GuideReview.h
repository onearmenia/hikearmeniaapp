//
//  GuideReview.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@interface GuideReview : ServiceInvocation
@property (assign, nonatomic)   NSInteger index;
@property (assign, nonatomic)   NSInteger userId;
@property (copy, nonatomic)		NSString *firstname;
@property (copy, nonatomic)     NSString *lastname;
@property (copy, nonatomic)     NSString *avatar;
@property (copy, nonatomic)		NSString  *reviewText;
@property (assign, nonatomic)   NSInteger rating;
@end
