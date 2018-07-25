//
//  AppInfoViewController.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 5/4/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "AppInfoViewController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "LocalGuidesViewController.h"
#import "LoginViewController.h"
#import "TrailsViewController.h"
#import "UIImage+ImageWithColor.h"
#import "SCLAlertView.h"
#import "CompassViewController.h"

@interface AppInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *toolbarSavedTrailsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionLabelLeadingConstraint;

@end

@implementation AppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureContent];
    //self.logoWidthConstraint.constant /= 1.5;
    if ([UIScreen mainScreen].bounds.size.height <= 667.0) {
        self.logoHeightConstraint.constant  = [UIScreen mainScreen].bounds.size.height/7;
    }
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.versionLabelLeadingConstraint.constant = 150.0;
        self.versionLabel.font = [UIFont fontWithName:self.versionLabel.font.fontName size:self.versionLabel.font.pointSize+2.0];
        self.textLabel.font = [UIFont fontWithName:self.textLabel.font.fontName size:self.textLabel.font.pointSize+2.0];
        self.emailInfoLabel.font = [UIFont fontWithName:self.emailInfoLabel.font.fontName size:self.emailInfoLabel.font.pointSize+2.0];
    }
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize bound  = CGSizeMake([UIScreen mainScreen].bounds.size.width-2*self.versionLabelLeadingConstraint.constant, CGFLOAT_MAX);
    CGRect newRect = [self.textLabel.text boundingRectWithSize:bound
                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes:@{NSFontAttributeName:self.textLabel.font,NSParagraphStyleAttributeName: paragraph}
                                                     context:nil];
    
    self.textLabelHeightConstraint.constant = ceilf(newRect.size.height);

    
    
    
    
    NSLayoutConstraint *constraintVertical = [NSLayoutConstraint constraintWithItem:self.containerView
                                                                          attribute:NSLayoutAttributeCenterY
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.mainScrollView
                                                                          attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.0f
                                                                           constant:0.0f];
    [self.view layoutIfNeeded];
    if (self.containerView.frame.size.height < [UIScreen mainScreen].bounds.size.height) {
        [self.mainScrollView addConstraint:constraintVertical];
    }
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.mainScrollView removeConstraint:self.containerViewTopConstraint];
    }
}

- (CGFloat)getTextViewHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"About HikeArmenia";
    
    if (self.savedTrailsButtonState) {
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"stackForToolbar"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"All Trails" forState:UIControlStateNormal];
    } else {
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"savedtrails"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"Favorite Trails" forState:UIControlStateNormal];
    }
}

- (void)configureNavigationBar{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = @"App Info";
    UILabel *titleLabel = [UILabel new];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)configureContent {
    self.versionLabel.text = @"Version 1.0.0";
    
    self.textLabel.text = @"HIKEArmenia allows you to access the best hiking trails in Armenia, get in touch with local guides, and find out where to sleep in the area. Whether you’re into easy day-hikes or looking for intense, long trails, we’ll facilitate your discovery of Armenia’s amazing landscapes. \n So lace up your hiking boots, and come explore Armenia with us!";
    self.emailInfoLabel.text = @"If you have any questions, suggestions or issues please contact us at";
    [self.emailButton setTitle:@"contact@hikearmenia.com" forState:UIControlStateNormal];
    NSMutableAttributedString *str = [self.emailButton.titleLabel.attributedText mutableCopy];
    [str addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, str.length)];
    [self.emailButton setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)menuButtonPressed:(id)sender {
    [HIKE_APP.homeController menuAction];
}

- (void)homeButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)compassButtonPressed:(id)sender {
    CompassViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CompassViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)findGuidesButtonPressed:(id)sender {
	UINavigationController *nc = self.navigationController;
	LocalGuidesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LocalGuidesViewController"];
	//[self.navigationController popToRootViewControllerAnimated:NO];
	[nc pushViewController:vc animated:YES];
 
}

- (IBAction)savedTrailsButtonPressed:(id)sender {
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
	if (!token) {
		LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
		[self.navigationController pushViewController:vc animated:YES];
		return;
	}
	
	[self.navigationController popToRootViewControllerAnimated:YES];
	TrailsViewController *vc = (TrailsViewController *)self.navigationController.topViewController;
	vc.filterSavedTrails = !vc.filterSavedTrails;
	[vc updateTrailsAnimated:YES];
}
- (IBAction)emailButtonPressed:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *comp =[[MFMailComposeViewController alloc] init];
        if(comp == nil) return;
        
        [comp setMailComposeDelegate:self];
        [comp setToRecipients:[NSArray arrayWithObjects:self.emailButton.titleLabel.text, nil]];
        [comp setSubject:@"HIKEArmenia"];
        [comp setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:comp animated:YES completion:nil];
    }
    else {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SlideInFromTop;
        alert.circleIconHeight = 30.0f;
        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Couldn't send email" subTitle:@"Please, check email configurations and try again."  closeButtonTitle:@"OK" duration:0.0f];
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

- (IBAction)fbButtonPressed:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/1054399771264796"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/hikearmenia/"]];
    }
}
- (IBAction)instaButtonPressed:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=hike_armenia"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/hike_armenia/"]];
    }
}

- (IBAction)twitterButtonPressed:(id)sender {
    NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=HikeArmenia"];
    if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
        [[UIApplication sharedApplication] openURL:twitterURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/HikeArmenia"]];
    }

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
