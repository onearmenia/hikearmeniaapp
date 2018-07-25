//
//  Accomodation.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/18/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"
#import "LocationCoordinate.h"

@interface Accomodation : ServiceInvocation
@property (assign, nonatomic)   NSInteger index;
@property (copy, nonatomic)		NSString  *name;
@property (copy, nonatomic)		NSString  *desc;
@property (copy, nonatomic)     NSString  *phone;
@property (copy, nonatomic)     NSString  *price;
@property (copy, nonatomic)		NSString  *email;
@property (copy, nonatomic)		NSString  *cover;
@property (copy, nonatomic)     NSString  *facilities;
@property (copy, nonatomic)     NSString  *url;
@property (copy, nonatomic)     NSString  *mapImg;
@property (strong, nonatomic) LocationCoordinate *coordinate;

- (void)loadAccomodationWithCallback:(ServiceCallback)callback;

@end
