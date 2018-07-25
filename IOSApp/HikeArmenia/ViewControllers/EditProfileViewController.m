//
//  EditProfileViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/14/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "HikeAPI.h"
#import "User.h"
#import "UIButton+AFNetworking.h"
#import "TrailsViewController.h"
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"
//#import "UIImage+UIImageFunctions.h"

@interface EditProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UITextField *firstnameField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerCenterYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNameTextfieldLeadingConstraint;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
	self.avatar.clipsToBounds = YES;
    [self.avatar.imageView setContentMode:UIViewContentModeScaleAspectFill];
	
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:barButtonItem];

	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save " style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    rightButtonItem.tintColor = [UIColor colorWithRed:65.0/255.0 green:117.0/255.0 blue:5.0/255.0 alpha:1];
	[self.navigationItem setRightBarButtonItem:rightButtonItem];

	self.firstnameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.lastnameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];
	self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.8 alpha:1.0]}];

    if([[UIScreen mainScreen] bounds].size.height == 480.0) {
        self.infoTopConstraint.constant = 35.0;
        self.scrollViewContentTopConstraint.constant = 75.0;
    }
    else {
		self.infoTopConstraint.constant = 85.0;
    }
    [self loadUserAvatar];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.firstNameTextfieldLeadingConstraint.constant = 180.0;
    }

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    self.screenName = @"Edit profile";
    
	self.navigationItem.title = @"Edit Account";
	UILabel *titleLabel = [UILabel new];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;

	self.firstnameField.text = HIKE_APP.user.firstName;
	self.lastnameField.text = HIKE_APP.user.lastName;
	self.phoneField.text = HIKE_APP.user.phone;
	self.emailField.text = HIKE_APP.user.email;
    
    self.scrollContentBottomConstraint.constant = 0.0;
    self.containerCenterYConstraint.constant = 0.0;
}

- (void)loadUserAvatar {
    NSLog(@"user avatar %@",HIKE_APP.user.photoURL);
    
    NSURL *url = [NSURL URLWithString:HIKE_APP.user.photoURL];
    if(HIKE_APP.user.photoURL && ![HIKE_APP.user.photoURL isEqualToString:@""]) {
        [self.avatar setImageForState:UIControlStateNormal
                              withURL:url];
    }
    else
        [self.avatar setImage:[UIImage imageNamed:@"profpic"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuButtonPressed:(id)sender {
	[HIKE_APP.homeController menuAction];
}

- (IBAction)changePasswordButtonPressed:(id)sender {
	ChangePasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
	[self.navigationController pushViewController:vc animated:YES];

	[self.view endEditing:YES];
	[UIView animateWithDuration:0.2 animations:^{
		[self.view layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];
}

- (IBAction)changePhotoButtonPressed:(id)sender {
    [self.view endEditing:YES];
    self.scrollContentBottomConstraint.constant = 0.0;
    self.containerCenterYConstraint.constant = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {
    }];

    
	NSString *actionSheetTitle = @"Choose";
	NSString *destructiveTitle = @"Camera";
	NSString *cancelTitle = @"Cancel";
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:actionSheetTitle
								  delegate:self
								  cancelButtonTitle:cancelTitle
								  destructiveButtonTitle:destructiveTitle
								  otherButtonTitles:@"Gallery", nil];
	
	[actionSheet showInView:self.view];
}

- (IBAction)deletePhotoButtonPressed:(id)sender {
    [self.avatar setImage:[UIImage imageNamed:@"profpic"] forState:UIControlStateNormal];
}

- (IBAction)logoutButtonPressed:(id)sender {
	[User logoutWithCallback:^(id result,long long contentLength, NSError *error) {
		if (!error) {
			if([result boolValue]) {
				NSLog(@"logout: Done");
			}
			else
				NSLog(@"logout: Failed");
		}
		else {
			NSLog(@"ERROR: %@",[error description]);
		}
	}];
	[HikeAPI instance].sessionToken = nil;
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:ksessionAuthKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ksessionUserDict];
	
///	UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavController"];
///	[[[[UIApplication sharedApplication] delegate] window] setRootViewController:nc];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	TrailsViewController *vc = (TrailsViewController *)self.navigationController.topViewController;
	vc.filterSavedTrails = NO;
	[vc reloadTrails];
}

- (void)saveButtonPressed {
	if([self.firstnameField.text isEqualToString:@""] || [self.lastnameField.text isEqualToString:@""] || [self.emailField.text isEqualToString:@""]) {
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
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Invalid email" subTitle:@"Invalid email address, please make sure to enter a valid email address"  closeButtonTitle:@"OK" duration:0.0f];
			return;
		}

		[CustomIndicatorLoadingView showIndicator];
		
		User *user = HIKE_APP.user;
		if(self.avatar.imageView.image)
			user.avatar = self.avatar.imageView.image;
		user.firstName = self.firstnameField.text;
		user.lastName = self.lastnameField.text;
		user.phone = self.phoneField.text;
		user.email = self.emailField.text;
		
		[user saveUserWithCallback:^(id result, long long contentLength, NSError *error) {
			if (!error) {
				HIKE_APP.user = result;
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert addButton:@"OK" actionBlock:^() {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Success" subTitle:@"Changes successfully saved"  closeButtonTitle:nil duration:0.0f];
			}
			else {
				NSLog(@"ERROR: %@",[error description]);
                
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Save Profile Failed" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
			}
			[CustomIndicatorLoadingView hideIndicator];
		}];
	}
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	if([buttonTitle isEqualToString:@"Gallery"])
	{
		UIImagePickerController *imageControl = [[UIImagePickerController alloc] init];
		imageControl.delegate=self;
		imageControl.allowsEditing = YES;
		imageControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imageControl.modalPresentationStyle=UIModalPresentationCurrentContext;
		[self presentViewController:imageControl animated:YES completion:nil];
	}
	if([buttonTitle isEqualToString:@"Camera"])
	{
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		
		[self presentViewController:picker animated:YES completion:NULL];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *receivedImage = [info valueForKey:UIImagePickerControllerEditedImage];
//	if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
//		receivedImage = [info valueForKey:UIImagePickerControllerEditedImage];
//	else
//		receivedImage = [receivedImage scaleProportionalToSize:CGSizeMake(self.avatar.bounds.size.width, self.avatar.bounds.size.height)];
	
	[picker dismissViewControllerAnimated:YES completion:^{
        [self.avatar setImage:receivedImage forState:UIControlStateNormal];
	}];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger shift = [UIScreen mainScreen].bounds.size.height * 0.1;
    if(self.containerCenterYConstraint.constant != -shift) {
        if ([[UIScreen mainScreen] bounds].size.height == 480.0) {
            self.scrollContentBottomConstraint.constant = 180.0;
        } else {
            self.scrollContentBottomConstraint.constant = 80.0;
        }
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
	
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
    self.scrollContentBottomConstraint.constant = 0.0;
    self.containerCenterYConstraint.constant = 0.0;
	
	[UIView animateWithDuration:0.5 animations:^{
		[self.view layoutIfNeeded];
	} completion: ^(BOOL finished) {
	}];
	
	[super touchesBegan:touches withEvent:event];
}

- (BOOL)validateEmail: (NSString *) candidate {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
	return [emailTest evaluateWithObject:candidate];
}
- (IBAction)avatarButtonPressed:(id)sender {
    [self changePhotoButtonPressed:self];
}

- (IBAction)tappedOnScreen:(id)sender {
    [self.view endEditing:YES];
    self.scrollContentBottomConstraint.constant = 0.0;
    self.containerCenterYConstraint.constant = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {
    }];

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
