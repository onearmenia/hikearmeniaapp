//
//  TakePhotoViewController.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 7/21/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "SCLAlertView.h"
#import "UIImage+ImageWithColor.h"
#import "Definitions.h"
#import "HANavigationController.h"
#import "AppDelegate.h"
#import "UIImage+UIImageFunctions.h"

@interface TakePhotoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageTaken;
@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self presentViewController:imagePickerController animated:NO completion:nil];
            }];
        }
        else{
            [self presentViewController:imagePickerController animated:NO completion:nil];
        }
    }
    

    
    [self configureNavBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"Take photo";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   }

- (void)configureNavBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_icon"]];
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
       // [picker dismissViewControllerAnimated:YES completion:^{
        
            UIImage *logo = [UIImage imageNamed:@"imageLogo2"];
            UIImage *newImage = [UIImage MergeImage:image withImage:logo];
            UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
        
            self.imageTaken.image = newImage;
      //  }];
}
- (IBAction)shareButtonPressed:(id)sender {
    ///	UIImage *shareImage = [UIImage imageNamed:@"Smbataberd.jpg"];
    
    NSArray *items = [NSArray arrayWithObjects:self.imageTaken.image,/* shareImage,*/ nil];
    UIActivityViewController *activityView = [[UIActivityViewController alloc]
                                              initWithActivityItems:items
                                              applicationActivities:nil];
    
    [activityView setExcludedActivityTypes:
     @[UIActivityTypeAssignToContact,
       UIActivityTypeAddToReadingList,
       UIActivityTypeCopyToPasteboard,
       UIActivityTypePrint,
       UIActivityTypeSaveToCameraRoll,
       UIActivityTypePostToWeibo,
       UIActivityTypeMessage,
       UIActivityTypePostToFlickr,
       UIActivityTypePostToVimeo,
       UIActivityTypePostToTencentWeibo,
       UIActivityTypeAirDrop]];
    
    [self presentViewController:activityView animated:YES completion:nil];
    UIPopoverPresentationController *presentationController =[activityView popoverPresentationController];
    
    presentationController.sourceView = self.shareButton;
    //presentationController.popoverLayoutMargins = UIEdgeInsetsMake(50.0, 50.0, 0, 0);
    presentationController.sourceRect = CGRectMake(self.shareButton.frame.size.width/2,self.shareButton.frame.size.height,0,0);
    //[presentationController setSourceRect:self.shareButton.frame];
    
    [activityView setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSLog(@"completed: %@, \n%d, \n%@, \n%@,", activityType, completed, returnedItems, activityError);
//        NSString *serviceMsg = nil;
//        serviceMsg = @"Shared successfully";
//        if ( [activityType isEqualToString:UIActivityTypeMail] ) {
//            serviceMsg = @"Mail sent!";
//        }
//        if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )  serviceMsg = @"Shared successfully on Twitter";
//        if ( [activityType isEqualToString:UIActivityTypePostToFacebook] ) serviceMsg = @"Shared successfully on Facebook";
//        
//        if ( completed )
//        {
//            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//            alert.showAnimationType = SlideInFromTop;
//            alert.circleIconHeight = 30.0f;
//            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"" subTitle:serviceMsg  closeButtonTitle:@"OK" duration:0.0f];
//        }
    }];
}
- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
