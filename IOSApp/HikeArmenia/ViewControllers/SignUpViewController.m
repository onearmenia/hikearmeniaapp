//
//  SignUpViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/8/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "SignUpViewController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "User.h"
#import "HikeAPI.h"
#import "UIImage+ImageWithColor.h"
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstnameField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNameLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCenterYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentBottomConstraint;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftButtonItem];

	self.navigationItem.title = @"Sign up";
	UILabel *titleLabel = [UILabel new];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
	
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];

	self.navigationController.navigationBarHidden = NO;
	
	self.firstnameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.lastnameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.confirmPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
    
    //self.firstnameField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 10, 0);
    self.firstnameField.delegate = self;
    self.lastnameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    self.confirmPasswordField.delegate = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.firstNameLabelLeadingConstraint.constant = 200.0;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Sign up";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signupButtonPressed:(id)sender {
	if([self.emailField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""] || [self.firstnameField.text isEqualToString:@""] || [self.lastnameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""] || [self.confirmPasswordField.text isEqualToString:@""]) {
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
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Invalid email" subTitle:@"Please, provide a valid email address"  closeButtonTitle:@"OK" duration:0.0f];
			return;
		}
		if(![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Warning" subTitle:@"Please, make sure passwords match"  closeButtonTitle:@"OK" duration:0.0f];
			return;
		}

		[CustomIndicatorLoadingView showIndicator];

		[User signup:self.emailField.text passwd:self.passwordField.text firstname:self.firstnameField.text lastname:self.lastnameField.text callback:^(id result,long long contentLength, NSError *error) {
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
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"SignUp Failed" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
			}
			[CustomIndicatorLoadingView hideIndicator];
		}];

	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	NSInteger shift = [UIScreen mainScreen].bounds.size.height * 0.12;
	if(self.containerCenterYConstraint.constant != -shift) {
		self.scrollContentBottomConstraint.constant = 80.0;
		self.containerCenterYConstraint.constant -= shift;
		
		[UIView animateWithDuration:0.5 animations:^{
			[self.view layoutIfNeeded];
		} completion: ^(BOOL finished) {
		}];
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	self.scrollContentBottomConstraint.constant = 0.0;
	self.containerCenterYConstraint.constant = 0.0;
	
	[UIView animateWithDuration:0.5 animations:^{
		[self.view layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];
	
    if (textField == self.firstnameField) {
        [self.lastnameField becomeFirstResponder];
    } else if (textField == self.lastnameField) {
        [self.emailField becomeFirstResponder];
    } else if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self.confirmPasswordField becomeFirstResponder];
    } else if (textField == self.confirmPasswordField) {
        [self signupButtonPressed:nil];
    }
    return YES;
}

- (IBAction)tapGesture:(id)sender {
	[self.view endEditing:YES];
	
	self.scrollContentBottomConstraint.constant = 0.0;
	self.containerCenterYConstraint.constant = 0.0;
	
	[UIView animateWithDuration:0.5 animations:^{
		[self.view layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];
}

- (BOOL)validateEmail: (NSString *) candidate {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
	return [emailTest evaluateWithObject:candidate];
}

@end
