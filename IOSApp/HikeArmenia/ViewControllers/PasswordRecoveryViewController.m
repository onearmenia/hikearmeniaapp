//
//  PasswordRecoveryViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/15/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "PasswordRecoveryViewController.h"
#import "User.h"
#import "UIImage+ImageWithColor.h"
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"

@interface PasswordRecoveryViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCenterYConstraint;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@end

@implementation PasswordRecoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftButtonItem];
	
	self.navigationItem.title = @"Password Recovery";
	UILabel *titleLabel = [UILabel new];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
	
	self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];

	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Password recovery";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recoveryButtonPressed:(id)sender {
	if([self.emailField.text isEqualToString:@""]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SlideInFromTop;
        alert.circleIconHeight = 30.0f;
        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Warning" subTitle:@"Please fill email"  closeButtonTitle:@"OK" duration:0.0f];
	}
	else {
		if(![self validateEmail:self.emailField.text]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Invalid email" subTitle:@"Please, provide a valid email address"  closeButtonTitle:@"OK" duration:0.0f];
			return;
		}
		[CustomIndicatorLoadingView showIndicator];
		
		User *user = [[User alloc] init];
		user.email = self.emailField.text;
		[user forgotPasswordWithCallback:^(id result, long long contentLength, NSError *error) {
			if(!error)
			{
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Success" subTitle:@"Please check your email."  closeButtonTitle:@"OK" duration:0.0f];
                [self.navigationController popViewControllerAnimated:YES];
			}
			else{
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Password Recovery Failed" subTitle:@"Couldn’t recover password, please try again later"  closeButtonTitle:@"OK" duration:0.0f];
			}
			[CustomIndicatorLoadingView hideIndicator];
		}];
	}
}

- (BOOL) validateEmail: (NSString *) candidate {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
	return [emailTest evaluateWithObject:candidate];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if(self.containerCenterYConstraint.constant != -40.0) {
		self.containerCenterYConstraint.constant = -40.0;
		
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
