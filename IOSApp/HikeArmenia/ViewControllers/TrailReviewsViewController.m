//
//  TrailReviewViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/30/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailReviewsViewController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "Trail.h"
#import "TrailReviews.h"
#import "TrailReview.h"
#import "TrailReviewCell.h"
#import "UIImage+ImageWithColor.h"
#import "LoginViewController.h"
#import "AddTrailTipViewController.h"
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"

#define VER_LESS_THAN_8_0 [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0
#define VER_GREATHER_OR_EQUAL_8_0 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface TrailReviewsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) TrailReviews *trailReviews;
@end

@implementation TrailReviewsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	[self loadTips];
#ifdef VER_GREATHER_OR_EQUAL_8_0
	self.table.estimatedRowHeight = 65;
	self.table.rowHeight = UITableViewAutomaticDimension;
	
	[self.table setNeedsLayout];
	[self.table layoutIfNeeded];
#endif
    
    self.titleLabel.text = self.trail.name;
    self.titleLabel.textColor = [UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0];
    self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBackground"]];
}



- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.screenName = @"Trail reviews";

	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftButtonItem];
	
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
	[self.navigationItem setRightBarButtonItem:rightButtonItem];
	
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
	
	self.navigationItem.title = @"TRAIL TIPS";
	UILabel *titleLabel = [UILabel new];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)loadTips {
	[CustomIndicatorLoadingView showIndicator];
	
	self.infoView.hidden = YES;
	[self.trail loadTrailTipsWithCallback:^(id result,long long contentLength, NSError *error) {
		if (!error) {
			TrailReviews *trailReviews = result;
			
			if(trailReviews.reviewsArray.count != 0) {
				self.trailReviews = result;
				[self.table reloadData];
			}
			else {
				self.infoView.hidden = NO;
			}
		}
		else {
			NSLog(@"ERROR: %@",[error description]);
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost) {
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:@"The Internet connection appears to be offline"  closeButtonTitle:@"OK" duration:0.0f];
            } else {
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
            }

		}
		[CustomIndicatorLoadingView hideIndicator];
	}];
}

- (void)reloadTips {
	if(self.trailReviews.reviewsArray.count > 0)
		self.infoView.hidden = YES;
	else
		self.infoView.hidden = NO;
	[self.table reloadData];
}

- (void)backButtonPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)homeButtonPressed:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)mapButtonPressed:(id)sender {
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.trailReviews.reviewsArray count];
}

#ifdef VER_LESS_THAN_8_0
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrailReviewCell *cell = (TrailReviewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 65.0 + cell.reviewTextLabelHeightConstraint.constant;
    }
    
	return 55.0 + cell.reviewTextLabelHeightConstraint.constant;
}
#endif

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TrailReview *review = [self.trailReviews.reviewsArray objectAtIndex:indexPath.row];
	
	TrailReviewCell *cell = (TrailReviewCell *)[tableView dequeueReusableCellWithIdentifier:@"TrailReviewCell"];
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
	[cell setSelectedBackgroundView:bgColorView];
		
	[cell updateWithTrailReview:review];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)addTrailTipButtonPressed:(id)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    if (!token) {
        UINavigationController *nc = self.navigationController;
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //[self.navigationController popToRootViewControllerAnimated:NO];
        [nc pushViewController:vc animated:YES];
        if (self.navigationController.viewControllers.count > 2) {
            NSMutableArray *viewControllersMutable = [self.navigationController.viewControllers mutableCopy];
            [viewControllersMutable removeObjectsInRange:NSMakeRange(1, viewControllersMutable.count-2)];
            self.navigationController.viewControllers = viewControllersMutable;
        }
        return;
    }
    
    AddTrailTipViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTrailTipViewController"];
    vc.trail = self.trail;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
