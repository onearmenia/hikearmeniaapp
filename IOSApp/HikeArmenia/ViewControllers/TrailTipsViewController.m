//
//  TrailTipsViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/29/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailTipsViewController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "Trail.h"
#import "TrailReviews.h"
#import "TrailReview.h"
#import "TrailTipCell.h"
#import "UIImage+ImageWithColor.h"

@interface TrailTipsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@end

@implementation TrailTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	self.table.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTips {
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
	return [self.trail.reviews.reviewsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 110.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TrailReview *review = [self.trail.reviews.reviewsArray objectAtIndex:indexPath.row];
	
	TrailTipCell *cell = (TrailTipCell *)[tableView dequeueReusableCellWithIdentifier:@"TrailTipCell"];
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
	[cell setSelectedBackgroundView:bgColorView];
		
	[cell updateWithTrailTip:review];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
