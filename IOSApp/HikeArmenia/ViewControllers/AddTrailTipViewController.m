//
//  AddTrailTipViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 5/1/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "AddTrailTipViewController.h"
#import "Trail.h"
#import "SCLAlertView.h"

@interface AddTrailTipViewController ()
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIButton *star1;
@property (weak, nonatomic) IBOutlet UIButton *star2;
@property (weak, nonatomic) IBOutlet UIButton *star3;
@property (weak, nonatomic) IBOutlet UIButton *star4;
@property (weak, nonatomic) IBOutlet UIButton *star5;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (assign, nonatomic) NSInteger selectedRate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewHeigntConstraint;
@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;
@end

@implementation AddTrailTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Regular" size:18.0f], NSKernAttributeName: @2.8};
	self.titleLbl.attributedText = [[NSAttributedString alloc] initWithString:@"WRITE A TRAIL TIP" attributes:attributes];
	
	if([[UIScreen mainScreen] bounds].size.height == 480.0)
		self.reviewHeigntConstraint.constant = 75.0;
	else
		self.reviewHeigntConstraint.constant = 180.0;
    
    self.reviewTextView.delegate = self;
    
    [self.star1 setImage:[UIImage imageNamed:@"StarFull_big"] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self.star2 setImage:[UIImage imageNamed:@"StarFull_big"] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self.star3 setImage:[UIImage imageNamed:@"StarFull_big"] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self.star4 setImage:[UIImage imageNamed:@"StarFull_big"] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [self.star5 setImage:[UIImage imageNamed:@"StarFull_big"] forState:(UIControlStateHighlighted | UIControlStateSelected)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    self.screenName = @"Add trail tip";
    
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:leftButtonItem];
	
    
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send  " style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    
    NSDictionary *attributesRightButton = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Bold" size:17.0f], NSKernAttributeName: @2.8};
    [rightButtonItem setTitleTextAttributes:attributesRightButton forState:UIControlStateNormal];
	[self.navigationItem setRightBarButtonItem:rightButtonItem];
	
	self.navigationItem.title = self.trail.name;
	UILabel *titleLabel = [UILabel new];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
	[titleLabel sizeToFit];
	self.navigationItem.titleView = titleLabel;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.reviewTextView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 300;
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSUInteger len = textView.text.length;
    NSUInteger charLeft = 300-len;
    if (charLeft == 1) {
        self.wordCountLabel.text=[NSString stringWithFormat:@"%lu character left",(unsigned long)charLeft];
    }
    else {
        self.wordCountLabel.text=[NSString stringWithFormat:@"%lu characters left",(unsigned long)charLeft];
    }
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

- (IBAction)rateButtonPressed:(id)sender {
	UIButton *button = sender;
	for(UIView *subview in self.view.subviews) {
		if([subview isKindOfClass:[UIButton class]]) {
			if(subview.tag != 0) {
				if(subview.tag <= button.tag) {
					((UIButton *)subview).selected = YES;
				}
				else {
					((UIButton *)subview).selected = NO;
				}
			}
		}
	}
	self.selectedRate = button.tag - 100;
}

- (void)saveButtonPressed {
	if([self.reviewTextView.text isEqualToString:@""]) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SlideInFromTop;
        alert.circleIconHeight = 30.0f;
        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Warning" subTitle:@"Please fill trail tip"  closeButtonTitle:@"OK" duration:0.0f];
		return;
	}
    
    __weak typeof(self) weakSelf = self;
    
	[self.trail addReview:self.reviewTextView.text withRating:self.selectedRate callback:^(id result,long long contentLength, NSError *error) {
		if (!error) {
			if([result boolValue])
			{
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Success" subTitle:@"Trail Tip posted"  closeButtonTitle:@"OK" duration:0.0f];

				[weakSelf.navigationController popViewControllerAnimated:YES];
			}
			else
			{
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
			}
		}
		else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost) {
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:@"The Internet connection appears to be offline"  closeButtonTitle:@"OK" duration:0.0f];
            } else {
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
            }
		}
	}];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
	
	[super touchesBegan:touches withEvent:event];
}

@end
