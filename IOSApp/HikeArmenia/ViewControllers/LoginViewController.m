//
//  LoginViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/8/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "LoginViewController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "PasswordRecoveryViewController.h"
#import "HikeAPI.h"
#import "User.h"
#import "UIImage+ImageWithColor.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCenterYConstraint;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    self.screenName = @"Login";
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
	self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HamburgerWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:barButtonItem];
	
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.view endEditing:YES];
	self.containerCenterYConstraint.constant = 0.0;
	[UIView animateWithDuration:0.2 animations:^{
		[self.view layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];
}

- (void)menuButtonPressed:(id)sender {
	[HIKE_APP.homeController menuAction];
}

- (IBAction)signupButtonPressed:(id)sender {
	UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)forgotPasswordButtonPressed:(id)sender {
	PasswordRecoveryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PasswordRecoveryViewController"];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginButtonPressed:(id)sender {
	if([self.emailField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SlideInFromTop;
        alert.circleIconHeight = 30.0f;
        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Warning" subTitle:@"Please fill empty fields"  closeButtonTitle:@"OK" duration:0.0f];
	}
	else {
		if(![self validateEmail:self.emailField.text]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Invalid email" subTitle:@"Invalid email address"  closeButtonTitle:@"OK" duration:0.0f];
            return;
		}
		[CustomIndicatorLoadingView showIndicator];

		[User login:self.emailField.text passwd:self.passwordField.text callback:^(id result,long long contentLength, NSError *error) {
			if (!error) {
				HIKE_APP.user = result;
				
				[HikeAPI instance].sessionToken = HIKE_APP.user.authKey;
				[[NSUserDefaults standardUserDefaults] setObject:HIKE_APP.user.authKey forKey:ksessionAuthKey];
				
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"userLoggedIn"
                 object:self
                 userInfo:nil];
                if (self.returnAfterLogin) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    HomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:vc];
                }
                
            }
			else {
				NSLog(@"ERROR: %@",[error description]);
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Login Failed" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
			}
			[CustomIndicatorLoadingView hideIndicator];
		}];
	}
}

- (IBAction)facebookConnectButtonPressed:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if ([result isCancelled]) {
        }
        else if (!error) {
             [CustomIndicatorLoadingView showIndicator];
             [User signupWithFacebook:[FBSDKAccessToken currentAccessToken].tokenString callback:^(id result,long long contentLength, NSError *error) {
                 if (!error) {
                     HIKE_APP.user = result;
                     
                     [HikeAPI instance].sessionToken = HIKE_APP.user.authKey;
                     [[NSUserDefaults standardUserDefaults] setObject:HIKE_APP.user.authKey forKey:ksessionAuthKey];
                     HomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                     [[[[UIApplication sharedApplication] delegate] window] setRootViewController:vc];
                     NSLog(@"Successful register");
                 }
                 else {
                     NSLog(@"ERROR: %@",[error description]);
                     SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                     alert.showAnimationType = SlideInFromTop;
                     alert.circleIconHeight = 30.0f;
                     [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Login with facebook failed" subTitle:@"Couldn’t login to Facebook, please try again later"  closeButtonTitle:@"OK" duration:0.0f];
                 }
                 [CustomIndicatorLoadingView hideIndicator];
             }];

         }  else {
             SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
             alert.showAnimationType = SlideInFromTop;
             alert.circleIconHeight = 30.0f;
             [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Process error" subTitle:@"Couldn’t acquire Facebook permission, please try again later"  closeButtonTitle:@"OK" duration:0.0f];
        }
     }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	NSInteger shift = -130.0;
	if([UIScreen mainScreen].bounds.size.height > 568.0) {
		shift = -80.0;
	}
	
	if(self.containerCenterYConstraint.constant != shift) {
		self.containerCenterYConstraint.constant = shift;
		
		[UIView animateWithDuration:0.5 animations:^{
			[self.view layoutIfNeeded];
		} completion: ^(BOOL finished) {
		}];
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	self.containerCenterYConstraint.constant = 0.0;
	
	[UIView animateWithDuration:0.5 animations:^{
		[self.view layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];

	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
	self.containerCenterYConstraint.constant = 0.0;
	
	[UIView animateWithDuration:0.5 animations:^{
		[self.view layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];
	
	[super touchesBegan:touches withEvent:event];
}

- (BOOL) validateEmail: (NSString *) candidate {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
	return [emailTest evaluateWithObject:candidate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
