//
//  AccomodationViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/3/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "AccomodationViewController.h"
#import "Accomodation.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageWithColor.h"
#import "HikeAPI.h"
#import "Definitions.h"
#import "SCLAlertView.h"
#import "MGLAccomodationMapViewController.h"

@interface AccomodationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *accomodationImageView;
@property (weak, nonatomic) IBOutlet UITextView *facilitiesTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *accomodationPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facilitiesHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *howToGetThereHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *facilitiesLabel;
@property (weak, nonatomic) IBOutlet UIView *howToGetThereView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facilitiesLabelTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facilitiesLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facilitiesTextTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *facilitiesTextBottomConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@end

@implementation AccomodationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	//NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:42.0/255.0 green:76.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:16.0f], NSKernAttributeName: @3.0};
	//self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:@"DESCRIPTION" attributes:attributes];
	//self.facilitiesLabel.attributedText = [[NSAttributedString alloc] initWithString:@"HOW TO GET THERE" attributes:attributes];

	NSLog(@"accomodation image url = %@",self.accomodation.cover);
    if(self.accomodation.cover) {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.accomodation.cover]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [self.accomodationImageView setImageWithURLRequest:imageRequest
                              placeholderImage:[UIImage imageNamed:@"placeholderForTrail"]
                                       success:nil
                                       failure:nil];
    }
	
    self.facilitiesTextView.text = self.accomodation.facilities;
    self.descriptionTextView.text = self.accomodation.desc;
   
	self.accomodationPriceLabel.text = self.accomodation.price;
	
	self.facilitiesHeightConstraint.constant = [self.facilitiesTextView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-70.0, CGFLOAT_MAX)].height;
	
	self.descriptionHeightConstraint.constant = [self.descriptionTextView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-70.0, CGFLOAT_MAX)].height;
	
    
    if (self.accomodation.mapImg.length > 0) {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.accomodation.mapImg]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [self.mapImageView setImageWithURLRequest:imageRequest
                                          placeholderImage:[UIImage imageNamed:@"mapImgPlaceholder"]
                                                   success:nil
                                                   failure:nil];
    } else {
        [self.mapImageView setImage:[UIImage imageNamed:@"mapImgPlaceholder"]];
    }
    
    
    if (self.accomodation.facilities.length > 0) {
        self.howToGetThereHeightConstraint.constant = self.facilitiesLabelTopConstraint.constant +
        self.facilitiesLabelHeightConstraint.constant +
        self.facilitiesHeightConstraint.constant +
        self.facilitiesTextTopConstraint.constant +
        self.facilitiesTextBottomConstraint.constant;
    } else {
        self.separatorView.hidden = YES;
        self.facilitiesLabelTopConstraint.constant = 0;
        self.howToGetThereHeightConstraint.constant = 0;
        self.facilitiesHeightConstraint.constant = 0;
        self.facilitiesTextTopConstraint.constant = 0;
        self.facilitiesLabelHeightConstraint.constant = 0;
        self.facilitiesTextBottomConstraint.constant = 0;
    }
	[self updateViewConstraints];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBackground"]];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion: nil];
    
    
    UIImage *phoneImg = [[UIImage imageNamed:@"phone_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.phoneButton setImage:phoneImg forState:UIControlStateNormal];
    UIImage *emailImg = [[UIImage imageNamed:@"mail_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.emailButton setImage:emailImg forState:UIControlStateNormal];
    UIImage *webImg = [[UIImage imageNamed:@"web_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.webButton setImage:webImg forState:UIControlStateNormal];

    
    if (!(self.accomodation.phone.length > 0)) {
        [self.phoneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.phoneButton setTintColor:[UIColor lightGrayColor]];
        self.phoneButton.userInteractionEnabled = NO;
    } else {
        [self.phoneButton setTintColor:[UIColor whiteColor]];
        self.phoneButton.userInteractionEnabled = YES;
    }
    if (!(self.accomodation.email.length > 0)) {
        [self.emailButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.emailButton setTintColor:[UIColor lightGrayColor]];
        self.emailButton.userInteractionEnabled = NO;
    } else {
        [self.emailButton setTintColor:[UIColor whiteColor]];
        self.emailButton.userInteractionEnabled = YES;
    }
    if (!(self.accomodation.url.length > 0)) {
        [self.webButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.webButton setTintColor:[UIColor lightGrayColor]];
        self.webButton.userInteractionEnabled = NO;
        
    } else {
        [self.webButton setTintColor:[UIColor whiteColor]];
        self.webButton.userInteractionEnabled = YES;
    }


}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.screenName = @"Accomodation detail";
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftButtonItem];
	
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
	[self.navigationItem setRightBarButtonItem:rightButtonItem];
	
	self.navigationController.navigationBar.translucent = NO;
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	
	self.navigationItem.title = self.accomodation.name;
	UILabel *titleLabel = [UILabel new];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)homeButtonPressed:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)phoneButtonPressed:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.accomodation.phone]]];
}

- (IBAction)emailButtonPressed:(id)sender {
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *comp =[[MFMailComposeViewController alloc] init];
		if(comp == nil) return;
		
		[comp setMailComposeDelegate:self];
		[comp setToRecipients:[NSArray arrayWithObjects:self.accomodation.email, nil]];
		[comp setSubject:self.accomodation.name];
		[comp setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
		[self presentViewController:comp animated:YES completion:nil];
	}
	else {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SlideInFromTop;
        alert.circleIconHeight = 30.0f;
        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Couldn't send email" subTitle:@"Please Check your email configurations and try again."  closeButtonTitle:@"OK" duration:0.0f];
	}
}

- (IBAction)webButtonPressed:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.accomodation.url]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"accomodationMapEmbed"]) {
        MGLAccomodationMapViewController *vc = (MGLAccomodationMapViewController *)[segue destinationViewController];
        vc.isEmbed = YES;
        vc.accomodation = self.accomodation;
    }
}
@end
