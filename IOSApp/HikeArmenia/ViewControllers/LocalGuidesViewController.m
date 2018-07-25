//
//  LocalGuidesViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/8/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "LocalGuidesViewController.h"
#import "HANavigationController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "Guides.h"
#import "Guide.h"
#import "GuideReviewsViewController.h"
#import "UIImage+ImageWithColor.h"
#import "Languages.h"
#import "Language.h"
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"

@interface LocalGuidesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@end

@implementation LocalGuidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
    
    if(self.embedMode) {
		self.table.scrollEnabled = NO;
	}
	else {
		self.table.scrollEnabled = YES;
        [self loadGuides];
	}
    self.infoView.hidden = YES;
    if (!self.embedMode) {
        //self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBg"]];
        self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBackground"]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (!self.embedMode) {
        self.screenName = @"Guides";
    }
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	UIBarButtonItem *leftButtonItem;
	if(self.filtered) {
		leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	}
	else {
		leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
	}
	[self.navigationItem setLeftBarButtonItem:leftButtonItem];
	
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
	[self.navigationItem setRightBarButtonItem:rightButtonItem];
	
	if(!self.embedMode) {
		self.navigationController.navigationBar.translucent = NO;
		self.navigationController.navigationBar.shadowImage = [UIImage new];
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
		
        self.navigationItem.title = self.trailName? self.trailName : @"Local guides";
		UILabel *titleLabel = [UILabel new];
		NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
		titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
		[titleLabel sizeToFit];
		self.navigationItem.titleView = titleLabel;
	}
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.embedMode) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)updateGuides {
    //[self loadGuides];
	[self.table reloadData];
}

- (void)loadGuides {
    if (!self.filtered) {
        [CustomIndicatorLoadingView showIndicator];
        [Guides loadGuidesWithCallback:^(id result,long long contentLength, NSError *error) {
            if (!error) {
                Guides *guideList = result;
                
                if(guideList.guidesArray.count != 0) {
                    self.infoView.hidden = YES;
                    self.guides = [[NSMutableArray alloc] initWithArray:guideList.guidesArray];
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
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
            }
            [CustomIndicatorLoadingView hideIndicator];
        }];

    } 
}

- (void)backButtonPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)menuButtonPressed:(id)sender {
	[HIKE_APP.homeController menuAction];
}

- (void)homeButtonPressed:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.guides count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.embedMode) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            return 120;
        }
    }
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Guide *guide = [self.guides objectAtIndex:indexPath.row];
	GuideViewCell *cell = (GuideViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GuideViewCell"];
    if(!self.embedMode) {
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            cell.guideName.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:20.0f];
        }
    }
    else {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
	[cell setSelectedBackgroundView:bgColorView];
	
	cell.delegate = self;
	[cell updateWithGuide:guide];
	
	return cell;
}

-(void) tableView:(UITableView *) tableView willDisplayCell:(GuideViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.avatar.layer.cornerRadius = [tableView rectForRowAtIndexPath:indexPath].size.height *0.75 /2.0;
    cell.avatar.clipsToBounds = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    Guide *guide = [self.guides objectAtIndex:indexPath.row];

    GuideReviewsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GuideReviewsViewController"];
    vc.guide = guide;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GuideViewCellDelegate

- (void)emailGuideWithIndex:(NSInteger)index {
	NSUInteger ind = [self.guides indexOfObjectPassingTest:
					  ^BOOL(Guide *object, NSUInteger idx, BOOL *stop)
					  {
						  return (object.index == index);
					  }
					  ];
	if(ind != NSNotFound) {
		Guide *guide = [self.guides objectAtIndex:ind];
        if (guide.email.length > 0) {
            if([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *comp =[[MFMailComposeViewController alloc] init];
                if(comp == nil) return;
                
                [comp setMailComposeDelegate:self];
                [comp setToRecipients:[NSArray arrayWithObjects:guide.email, nil]];
                [comp setSubject:@"Hike Armenia"];
                [comp setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:comp animated:YES completion:nil];
            }
            else {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Couldn't send email" subTitle:@"Your device couldn't send email. Check email configurations and try again."  closeButtonTitle:@"OK" duration:0.0f];
            }
        }
		
	}
}

- (void)callGuideWithIndex:(NSInteger)index {
	NSUInteger ind = [self.guides indexOfObjectPassingTest:
					  ^BOOL(Guide *object, NSUInteger idx, BOOL *stop)
					  {
						  return (object.index == index);
					  }
					  ];
	if(ind != NSNotFound) {
		Guide *guide = [self.guides objectAtIndex:ind];
        if (guide.phone.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",guide.phone]]];
        }
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	NSString *message;
    NSString *title;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[self dismissViewControllerAnimated:YES completion:NULL];
			return;
			break;
		case MFMailComposeResultSent:
			message = @"Your email has been sent.";
            title = @"Success";
			break;
		case MFMailComposeResultFailed:
			message = @"Email couldn't be sent, try again later.";
            title = @"Email";
			break;
		case MFMailComposeResultSaved:
			[self dismissViewControllerAnimated:YES completion:NULL];
			return;
			break;
		default:
			message = @"Email couldn't be sent, try again later.";
            title = @"Email";
			break;
	}
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.showAnimationType = SlideInFromTop;
    alert.circleIconHeight = 30.0f;
    [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:title subTitle:message  closeButtonTitle:@"OK" duration:0.0f];
    
	[self dismissViewControllerAnimated:YES completion:NULL];
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
