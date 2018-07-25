//
//  RootViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "RootViewController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "HikeAPI.h"
#import "User.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self setupRootViewController];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setupRootViewController {
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
	if (token) {
		[HikeAPI instance].sessionToken = token;
		[User loadUserWithCallback:^(id result, long long contentLength, NSError *error) {
			if (!error) {
				HIKE_APP.user = result;
			}
			else {
                if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost) {
                    HIKE_APP.user = [User objectFromJSON:[[NSUserDefaults standardUserDefaults] objectForKey:ksessionUserDict]];
                } else {
                    [HikeAPI instance].sessionToken = nil;
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ksessionAuthKey];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ksessionUserDict];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
				NSLog(@"ERROR: %@",[error description]);
			}
		}];
	}

	HomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
	[[[[UIApplication sharedApplication] delegate] window] setRootViewController:vc];
	[[[UIApplication sharedApplication] delegate].window makeKeyAndVisible];
}

@end
