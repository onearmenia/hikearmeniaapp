//
//  HomeViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/8/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "HomeViewController.h"
#import "HANavigationController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "TrailsViewController.h"
#import "LocalGuidesViewController.h"
#import "EditProfileViewController.h"
#import "LoginViewController.h"
#import "AppInfoViewController.h"
#import "AboutViewController.h"
#import "CompassViewController.h"
#import "OfflineTrailsViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerTrailingConstraint;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HIKE_APP.homeController = self;
    _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeActionOnView)];
    self.swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeRecognizer];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuAction {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    if (token && HIKE_APP.user) {
        [self.profileButton setTitle:@"MY PROFILE" forState:UIControlStateNormal];
        [self.profileButton setTitle:@"MY PROFILE" forState:UIControlStateHighlighted];
    }
    else {
        [self.profileButton setTitle:@"SIGN IN" forState:UIControlStateNormal];
        [self.profileButton setTitle:@"SIGN IN" forState:UIControlStateHighlighted];
    }
    if(self.containerLeadingConstraint.constant == 0) {
        self.containerTrailingConstraint.constant -= 280.0;
        self.containerLeadingConstraint.constant += 280.0;
        [self.view addGestureRecognizer:self.tapRecognizer];
        self.navController.topViewController.view.userInteractionEnabled = NO;
    }
    else {
        self.containerTrailingConstraint.constant += 280.0;
        self.containerLeadingConstraint.constant -= 280.0;
        [self.view removeGestureRecognizer:self.tapRecognizer];
        self.navController.topViewController.view.userInteractionEnabled = YES;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {
    }];
}

- (void)swipeActionOnView {
    if(self.containerLeadingConstraint.constant != 0) {
        self.containerTrailingConstraint.constant += 280.0;
        self.containerLeadingConstraint.constant -= 280.0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {
        [self.view removeGestureRecognizer:self.tapRecognizer];
        self.navController.topViewController.view.userInteractionEnabled = YES;
    }];
}

- (IBAction)trailsButtonPressed:(id)sender {
    [self.navController popToRootViewControllerAnimated:YES];
    TrailsViewController *vc = (TrailsViewController *)self.navController.topViewController;
    vc.filterSavedTrails = NO;
    [vc reloadTrails];
    [self closeLeftMenuFor:vc];
}

- (IBAction)guidesButtonPressed:(id)sender {
    LocalGuidesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LocalGuidesViewController"];
    //[self.navController popToRootViewControllerAnimated:NO];
    if (![self.navController.topViewController isKindOfClass:[vc class]]) {
        [self.navController pushViewController:vc animated:YES];
    }
    [self closeLeftMenuFor:vc];
}

- (IBAction)profileButtonPressed:(id)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    if (token && HIKE_APP.user) {
        EditProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
        //[self.navController popToRootViewControllerAnimated:NO];
        if (![self.navController.topViewController isKindOfClass:[vc class]]) {
            [self.navController pushViewController:vc animated:YES];
        }
        [self closeLeftMenuFor:vc];
    }
    else {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //[self.navController popToRootViewControllerAnimated:NO];
        if (![self.navController.topViewController isKindOfClass:[vc class]]) {
            [self.navController pushViewController:vc animated:YES];
        }
        [self closeLeftMenuFor:vc];
    }
}

- (IBAction)savedTrailsButtonPressed:(id)sender {
    //[self.navController popToRootViewControllerAnimated:YES];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    if (!token) {
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //[self.navController popToRootViewControllerAnimated:NO];
        if (![self.navController.topViewController isKindOfClass:[vc class]]) {
            [self.navController pushViewController:vc animated:YES];
        }
        [self closeLeftMenuFor:vc];
        return;
    }
    TrailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrailsViewController"];
    vc.filterSavedTrails = YES;
    if (![self.navController.topViewController isKindOfClass:[vc class]] || ([self.navController.topViewController isKindOfClass:[vc class]] && vc.filterSavedTrails)) {
        [self.navController pushViewController:vc animated:YES];
    }
    [vc reloadTrails];
    [self closeLeftMenuFor:vc];
}
- (IBAction)offlineTrailsButtonPressed:(id)sender {
    OfflineTrailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineTrailsViewController"];
    if (![self.navController.topViewController isKindOfClass:[vc class]] || ([self.navController.topViewController isKindOfClass:[vc class]])) {
        [self.navController pushViewController:vc animated:YES];
    }
//    [vc reloadTrails];
    TrailsViewController *rootVc = (TrailsViewController *)[self.navController.viewControllers firstObject];
    vc.savedTrailsButtonState = rootVc.filterSavedTrails;
    [self closeLeftMenuFor:vc];
}

- (IBAction)appInfoButtonPressed:(id)sender {
    AppInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppInfoViewController"];
    //[self.navController popToRootViewControllerAnimated:NO];
    if (![self.navController.topViewController isKindOfClass:[vc class]]) {
        [self.navController pushViewController:vc animated:YES];
    }
    TrailsViewController *rootVc = (TrailsViewController *)[self.navController.viewControllers firstObject];
    vc.savedTrailsButtonState = rootVc.filterSavedTrails;
    [self closeLeftMenuFor:vc];
    
}
- (IBAction)CompassButtonPressed:(id)sender {
    CompassViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CompassViewController"];
    //[self.navController popToRootViewControllerAnimated:NO];
    if (![self.navController.topViewController isKindOfClass:[vc class]]) {
        [self.navController pushViewController:vc animated:YES];
    }
    [self closeLeftMenuFor:vc];

}

- (IBAction)aboutButtonPressed:(id)sender {
    AboutViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
    //[self.navController popToRootViewControllerAnimated:NO];
    if (![self.navController.topViewController isKindOfClass:[vc class]]) {
        [self.navController pushViewController:vc animated:YES];
    }
    TrailsViewController *rootVc = (TrailsViewController *)[self.navController.viewControllers firstObject];
    vc.savedTrailsButtonState = rootVc.filterSavedTrails;
    [self closeLeftMenuFor:vc];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if(self.containerLeadingConstraint.constant != 0) {
        self.containerTrailingConstraint.constant += 280.0;
        self.containerLeadingConstraint.constant -= 280.0;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion: ^(BOOL finished) {
            [self.view removeGestureRecognizer:self.tapRecognizer];
            self.navController.topViewController.view.userInteractionEnabled = YES;
        }];
    }
}

- (void)closeLeftMenuFor:(UIViewController *)vc {
    if (self.navController.viewControllers.count > 2) {
        NSMutableArray *viewControllersMutable = [self.navController.viewControllers mutableCopy];
        [viewControllersMutable removeObjectsInRange:NSMakeRange(1, viewControllersMutable.count-2)];
        self.navController.viewControllers = viewControllersMutable;
    }
    [self.view layoutIfNeeded];
    if (self.containerTrailingConstraint.constant < 0 && self.containerLeadingConstraint.constant > 0) {
        self.containerTrailingConstraint.constant += 280.0;
        self.containerLeadingConstraint.constant -= 280.0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {
        [self.view removeGestureRecognizer:self.tapRecognizer];
        UIViewController *rootViewController = [[self.navController viewControllers] firstObject];
        rootViewController.view.userInteractionEnabled = YES;
        self.navController.topViewController.view.userInteractionEnabled = YES;
        vc.view.userInteractionEnabled = YES;
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"Navigation"]) {
        self.navController = [segue destinationViewController];
    }
}
@end

