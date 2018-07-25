//
//  GuideReviewsViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/23/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "GuideReviewsViewController.h"
#import "Guide.h"
#import "GuideReviews.h"
#import "GuideReview.h"
#import "GuideReviewCell.h"
#import "AddGuideReviewViewController.h"
#import "Definitions.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "GuideViewCell.h"
#import "UIImage+ImageWithColor.h"
#import "HANavigationController.h"
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"
#import "Languages.h"
#import "Language.h"

#define VER_LESS_THAN_8_0 [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0
#define VER_GREATHER_OR_EQUAL_8_0 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface GuideReviewsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerViewAvatar;
@property (weak, nonatomic) IBOutlet UILabel *headerViewGuideName;
@property (weak, nonatomic) IBOutlet UIImageView *headerViewStar1;
@property (weak, nonatomic) IBOutlet UIImageView *headerViewStar2;
@property (weak, nonatomic) IBOutlet UIImageView *headerViewStar3;
@property (weak, nonatomic) IBOutlet UIImageView *headerViewStar4;
@property (weak, nonatomic) IBOutlet UIImageView *headerViewStar5;
@property (weak, nonatomic) IBOutlet UILabel *headerViewReviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoViewNoReviewsLabel;
@property (weak, nonatomic) IBOutlet UIView *languagesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guideNameLabelTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addGuideReviewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *languagesViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerAvatarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerPhoneButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *guideEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *guidePhoneButton;
@property (weak, nonatomic) IBOutlet UILabel *guideDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *info;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewNoReviewTopConstraint;

@end

@implementation GuideReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftButtonItem];
	
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
	[self.navigationItem setRightBarButtonItem:rightButtonItem];

	self.navigationItem.title = @"Guide Info";
	UILabel *titleLabel = [UILabel new];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
	
	self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.table.backgroundView = [[UIView alloc] init];
    
    self.infoViewNoReviewsLabel.text = [NSString stringWithFormat:@"%@ %@ doesn't have any reviews yet", self.guide.firstname, self.guide.lastname];
    self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBackground"]];
    
#ifdef VER_GREATHER_OR_EQUAL_8_0
	self.table.estimatedRowHeight = 65;
	self.table.rowHeight = UITableViewAutomaticDimension;
	
	[self.table setNeedsLayout];
	[self.table layoutIfNeeded];
#endif
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.headerPhoneButtonWidthConstraint.constant = 60.0;
    }
    
    self.table.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.table.estimatedSectionHeaderHeight = 60;
    self.table.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    
    CGFloat infoViewNoReviewTopConstraint = 22;
    if ([[UIScreen mainScreen] bounds].size.height == 736 && [UIScreen mainScreen].scale > 2)
    {
        infoViewNoReviewTopConstraint = -18;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        infoViewNoReviewTopConstraint = -50;
    }
    
    self.infoViewNoReviewTopConstraint.constant = - (self.headerView.frame.size.height + self.navigationController.navigationBar.frame.size.height + infoViewNoReviewTopConstraint);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.screenName = [NSString stringWithFormat:@"Guide %@ %@ reviews", self.guide.firstname, self.guide.lastname];
    
    [self configureNavBar];
	[self loadReviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.headerViewAvatar.layer.cornerRadius = self.headerViewAvatar.frame.size.height / 2.0;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    //Set the background color of the View
    view.tintColor = [UIColor blueColor];
}

- (void)configureNavBar {
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"Guide Info";
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

- (void)loadReviews {
	[CustomIndicatorLoadingView showIndicator];
	
	self.infoView.hidden = YES;
	[self.guide loadGuideWithCallback:^(id result,long long contentLength, NSError *error) {
		if (!error) {
			self.guide = result;
            if (self.guide.reviewCount == 0) {
                [self.addGuideReviewButton setTitle:@"Add guide review" forState:UIControlStateNormal];
            } else {
                [self.addGuideReviewButton setTitle:@"Add another guide review" forState:UIControlStateNormal];
            }
			if(self.guide.reviews.reviewsArray.count != 0) {
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
            [alert addButton:@"OK" actionBlock:^() {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:nil duration:0.0f];
		}
		[CustomIndicatorLoadingView hideIndicator];
	}];
}

- (void)backButtonPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)homeButtonPressed:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.guide.reviews.reviewsArray count];
}

#ifdef VER_LESS_THAN_8_0
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
	paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    GuideReviewCell *cell = (GuideReviewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 75.0 + cell.reviewTextLabelHeightConstraint.constant;
    }

	return 65.0 + cell.reviewTextLabelHeightConstraint.constant;
}
#endif

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	GuideReview *review = [self.guide.reviews.reviewsArray objectAtIndex:indexPath.row];
	GuideReviewCell *cell = (GuideReviewCell *)[tableView dequeueReusableCellWithIdentifier:@"GuideReviewCell"];
	cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
	[cell setSelectedBackgroundView:bgColorView];
	
	[cell updateWithGuideReview:review];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)addReviewButtonPressed:(id)sender {
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
	if (!token) {
		UINavigationController *nc = self.navigationController;
		LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
		//[self.navigationController popToRootViewControllerAnimated:NO];
        if (self.navigationController.viewControllers.count > 2) {
            NSMutableArray *viewControllersMutable = [self.navigationController.viewControllers mutableCopy];
            [viewControllersMutable removeObjectsInRange:NSMakeRange(1, viewControllersMutable.count-2)];
            self.navigationController.viewControllers = viewControllersMutable;
        }
		[nc pushViewController:vc animated:YES];
		
		return;
	}

	AddGuideReviewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddGuideReviewViewController"];
	vc.guide = self.guide;
	[self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.headerViewGuideName.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:20.0f];
        }
        self.headerViewAvatar.clipsToBounds = YES;
        if (self.guide.photoURL.length) {
            [self.headerViewAvatar setImageWithURL:[NSURL URLWithString:self.guide.photoURL]];
        } else {
            [self.headerViewAvatar setImage:[UIImage imageNamed:@"tempAvatar"]];
        }
        self.headerViewGuideName.text = [NSString stringWithFormat:@"%@ %@", self.guide.firstname, self.guide.lastname];
        self.headerViewGuideName.adjustsFontSizeToFitWidth = YES;
        self.headerViewGuideName.minimumScaleFactor = 0.7f;
        self.headerViewReviewCountLabel.text = [NSString stringWithFormat:@"( %ld reviews )",(long)self.guide.reviewCount];
        self.headerViewStar1.image = (self.guide.averageRating >= 1) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
        self.headerViewStar2.image = (self.guide.averageRating >= 2) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
        self.headerViewStar3.image = (self.guide.averageRating >= 3) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
        self.headerViewStar4.image = (self.guide.averageRating >= 4) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
        self.headerViewStar5.image = (self.guide.averageRating >= 5) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"Star"];
        self.guideDescriptionLabel.text = self.guide.guideDescription;
    
        UIImage *imagePhone = [[UIImage imageNamed:@"phone"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.guidePhoneButton setImage:imagePhone forState:UIControlStateNormal];
        
        UIImage *imageEmail = [[UIImage imageNamed:@"mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.guideEmailButton setImage:imageEmail forState:UIControlStateNormal];
        
        if (!(self.guide.phone.length > 0)) {
            self.guidePhoneButton.tintColor = [UIColor lightGrayColor];
        } else {
            self.guidePhoneButton.tintColor = [UIColor colorWithRed:65.0/255.0 green:118.0/255.0 blue:5.0/255.0 alpha:1.0];
        }
        if (!(self.guide.email.length > 0)) {
            self.guideEmailButton.tintColor = [UIColor lightGrayColor];
            
        } else {
            self.guideEmailButton.tintColor = [UIColor colorWithRed:65.0/255.0 green:118.0/255.0 blue:5.0/255.0 alpha:1.0];
        }
        
        [self configureLanguagesView];
    
        return self.headerView;
}

- (void)configureLanguagesView
{
    double langIconLeading = 0.0;
    double langImgSize = 18.0;
    double langImgSpacing = 5.0;
    if (self.guide.languages.languageArray.count > 0) {
        self.languagesViewHeightConstraint.constant = 18.0;
    } else {
        self.languagesViewHeightConstraint.constant = 0;
    }
    [self.languagesView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    for (int i = 0; i<self.guide.languages.languageArray.count; i++) {
        UIImageView *langImgView = [[UIImageView alloc] init];
        [langImgView setImageWithURL:[NSURL URLWithString:[self.guide.languages.languageArray[i] imageUrl]]];
        [self.languagesView addSubview:langImgView];
        langImgView.translatesAutoresizingMaskIntoConstraints = NO;
        [langImgView addConstraint:[NSLayoutConstraint constraintWithItem:langImgView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:langImgSize]];
        [langImgView addConstraint:[NSLayoutConstraint constraintWithItem:langImgView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:langImgSize]];
        [self.languagesView addConstraint:[NSLayoutConstraint constraintWithItem:langImgView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.languagesView
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0
                                                                        constant:langIconLeading]];
        [self.languagesView addConstraint:[NSLayoutConstraint constraintWithItem:langImgView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.languagesView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:0]];
        langIconLeading += langImgSize+langImgSpacing;
    }
}

- (IBAction)guideEmailButtonPressed:(id)sender {
    if (self.guide.email.length > 0) {
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *comp =[[MFMailComposeViewController alloc] init];
            if(comp == nil) return;
            
            [comp setMailComposeDelegate:self];
            [comp setToRecipients:[NSArray arrayWithObjects:self.guide.email, nil]];
            [comp setSubject:@"Hike Armenia"];
            [comp setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:comp animated:YES completion:nil];
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Couldn't open email" subTitle:@"Please, check email configurations and try again."  closeButtonTitle:@"OK" duration:0.0f];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString *message;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self dismissViewControllerAnimated:YES completion:NULL];
            return;
            break;
        case MFMailComposeResultSent:
            message = @"Your email has been sent.";
            break;
        case MFMailComposeResultFailed:
            message = @"Email couldn't be sent, try again later.";
            break;
        case MFMailComposeResultSaved:
            [self dismissViewControllerAnimated:YES completion:NULL];
            return;
            break;
        default:
            message = @"Email couldn't be sent, try again later.";
            break;
    }
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.showAnimationType = SlideInFromTop;
    alert.circleIconHeight = 30.0f;
    [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Email" subTitle:message  closeButtonTitle:@"OK" duration:0.0f];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)guidePhoneButtonPressed:(id)sender {
    if (self.guide.phone.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.guide.phone]]];
    }
}
@end
