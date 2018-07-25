//
//  ProfileViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "ProfileViewController.h"
#import "Definitions.h"
#import "HikeAPI.h"
#import "User.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2;
	self.avatar.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSString *fullName = HIKE_APP.user.firstName;
	fullName = [[fullName stringByAppendingString:@" "] stringByAppendingString:HIKE_APP.user.lastName];
	self.nameLabel.text = fullName;
	
	
	NSLog(@"%@",HIKE_APP.user.photoURL);
	
	NSURL *url = [NSURL URLWithString:HIKE_APP.user.photoURL];
	if(![HIKE_APP.user.photoURL isEqualToString:@""])
		[self.avatar setImageWithURL:url];
	else
		self.avatar.image = [UIImage imageNamed:@"profpic"];

	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:barButtonItem];
	
//	[self.navigationController.navigationBar setTitleTextAttributes:@{
//																	  NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0],
//																	  NSFontAttributeName:[UIFont systemFontOfSize:15.0f]
//																	  }];
	self.navigationItem.title = @"Profile";
	UILabel *titleLabel = [UILabel new];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
	
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonPressed:)];
	[self.navigationItem setRightBarButtonItem:rightButtonItem];
	self.navigationController.navigationBarHidden = NO;
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
	
	UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavController"];
	[[[[UIApplication sharedApplication] delegate] window] setRootViewController:nc];
}

- (IBAction)disconnectFacebookButtonPressed:(id)sender {
}

- (IBAction)editAccountButtonPressed:(id)sender {
}

- (void)menuButtonPressed:(id)sender {
	[HIKE_APP.homeController menuAction];
}

- (void)mapButtonPressed:(id)sender {
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
