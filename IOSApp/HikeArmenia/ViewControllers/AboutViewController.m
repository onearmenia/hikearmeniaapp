//
//  AboutViewController.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 5/4/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "AboutViewController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "LocalGuidesViewController.h"
#import "LoginViewController.h"
#import "TrailsViewController.h"
#import "UIImage+ImageWithColor.h"
#import "CompassViewController.h"
#import "SCLAlertView.h"
#import "TakePhotoViewController.h"

@interface AboutViewController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *toolbarSavedTrailsButton;
@property (weak, nonatomic) IBOutlet UILabel *HAVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *HATextLabel;
@property (weak, nonatomic) IBOutlet UILabel *HAEmailInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *HAEmailButton;
@property (weak, nonatomic) IBOutlet UIView *HAContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *parentScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToolbarheightConstraint;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self configureContent];
}

- (float)calculateSizeForLabel:(UILabel *)label leadingConstraint:(float)leading {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize bound  = CGSizeMake([UIScreen mainScreen].bounds.size.width-2*leading, CGFLOAT_MAX);
    CGRect newRect = [label.text boundingRectWithSize:bound
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName:label.font,NSParagraphStyleAttributeName: paragraph}
                                              context:nil];
    return ceilf(newRect.size.height);
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"About";
    
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
    
    self.navigationItem.title = @"About";
    UILabel *titleLabel = [UILabel new];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)configureContent {
    self.HATextLabel.text = @"Our goal is to promote Armenia as a premier hiking destination with world class trails, unique homestay options, various cultural and historical sites, and knowledgable, trained guides.\n\nHIKEArmenia is committed to the general promotion of Armenia as a hiking and ecotourism destination for international visitors and locals alike, to allow them to discover the undiscovered nature and treasures which remain still unknown to most. Starting with our interactive website, housed in a modern resource center in the heart of downtown Yerevan, and an expanded mobile application, we are creating physical and digital resources that connect users to people and organizations in the regions of Armenia they hope to visit.";
    self.HAEmailInfoLabel.text = @"If you have any questions, suggestions or issues please contact us at";
    
    [self.HAEmailButton setTitle:@"info@hikearmenia.org" forState:UIControlStateNormal];
    NSMutableAttributedString *str = [self.HAEmailButton.titleLabel.attributedText mutableCopy];
    [str addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, str.length)];
    [self.HAEmailButton setAttributedTitle:str forState:UIControlStateNormal];
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

- (IBAction)takeAPhotoButtonPressed:(id)sender {
    TakePhotoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TakePhotoViewController"];
    [self presentViewController:vc animated:YES completion:nil];
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
    //[vc reloadTrails];
    [vc updateTrailsAnimated:YES];
}

- (IBAction)HAfbButtonPressed:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/1054399771264796"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/hikearmenia/"]];
    }
}
- (IBAction)HAinstaButtonPressed:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=hike_armenia"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/hike_armenia/"]];
    }
}

- (IBAction)HAtwitterButtonPressed:(id)sender {
    NSURL *twitterURL = [NSURL URLWithString:@"twitter://user?screen_name=HikeArmenia"];
    if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
        [[UIApplication sharedApplication] openURL:twitterURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/HikeArmenia"]];
    }
    
}

- (IBAction)HAEmailButtonPressed:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *comp =[[MFMailComposeViewController alloc] init];
        if(comp == nil) return;
        
        [comp setMailComposeDelegate:self];
        [comp setToRecipients:[NSArray arrayWithObjects:self.HAEmailButton.titleLabel.text, nil]];
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


@end
