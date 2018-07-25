//
//  User.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ServiceInvocation.h"

@interface User : ServiceInvocation

@property (assign, nonatomic)   NSInteger index;
@property (copy, nonatomic)     NSString *firstName;
@property (copy, nonatomic)     NSString *lastName;
@property (copy, nonatomic)     NSString *email;
@property (copy, nonatomic)     NSString *phone;
@property (copy, nonatomic)     NSString *photoURL;
@property (strong, nonatomic)   UIImage *avatar;
@property (copy, nonatomic)     NSString *authKey;

+ (void)login:(NSString *)username passwd:(NSString *)passwd callback:(ServiceCallback)callback;

+ (void)signup:(NSString *)email passwd:(NSString *)passwd firstname:(NSString *)firstname lastname:(NSString *)lastname callback:(ServiceCallback)callback;
+ (void)signupWithFacebook:(NSString *)currentAccessToken callback:(ServiceCallback)callback;

+ (void)loadUserWithCallback:(ServiceCallback)callback;
- (void)saveUserWithCallback:(ServiceCallback)callback;
- (void)changePassword:(NSString *)newPassword oldPassword:(NSString *)oldPassword callback:(ServiceCallback)callback;
+ (void)logoutWithCallback:(ServiceCallback)callback;
- (void)forgotPasswordWithCallback:(ServiceCallback)callback;

@end
