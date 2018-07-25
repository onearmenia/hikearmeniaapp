//
//  ChangePasswordViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/15/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "HikeAPI.h"
#import "User.h"
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCenterYConstraint;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftButtonItem];

	self.navigationItem.title = @"Change Password";
	UILabel *titleLabel = [UILabel new];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
	
	self.oldPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Old Password" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.confirmPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Change password";
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)backButtonPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
	if([self.oldPasswordField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""] || [self.confirmPasswordField.text isEqualToString:@""]) {
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SlideInFromTop;
        alert.circleIconHeight = 30.0f;
        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Warning" subTitle:@"Please fill empty fields"  closeButtonTitle:@"OK" duration:0.0f];
	}
	else {
		if(![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Warning" subTitle:@"Please, make sure confirmation password matches with the new password"  closeButtonTitle:@"OK" duration:0.0f];
			return;
		}
		[CustomIndicatorLoadingView showIndicator];
		
		[HIKE_APP.user changePassword:self.passwordField.text oldPassword:self.oldPasswordField.text callback:^(id result, long long contentLength, NSError *error) {
			if(!error)
			{
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Success" subTitle:@"Password successfully changed."  closeButtonTitle:@"OK" duration:0.0f];
                [self.navigationController popViewControllerAnimated:YES];
			}
			else{
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Change Password Failed" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
			}
			[CustomIndicatorLoadingView hideIndicator];
		}];
	}
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
