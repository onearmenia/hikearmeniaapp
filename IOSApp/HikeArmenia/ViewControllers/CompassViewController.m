//
//  CompassViewController.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/3/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "CompassViewController.h"
#import "GeoPointCompass.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "UIImage+ImageWithColor.h"
#import "SCLAlertView.h"

@interface CompassViewController ()
@property (strong, nonnull) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *compassBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *compassArrowImageView;

@end

@implementation CompassViewController
GeoPointCompass *geoPointCompass;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBg"]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBackground"]];
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
//    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//    alert.showAnimationType = SlideInFromTop;
//    alert.circleIconHeight = 30.0f;
//    if (! [CLLocationManager authorizationStatus] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:@"Please enable location services for HIKEArmenia application"  closeButtonTitle:@"OK" duration:0.0f];
//    } else
    
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
        [self startCompass];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"Compass";
    
    [self configureNavigationBar];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        [self startCompass];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startCompass {
//    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-500, [UIScreen mainScreen].bounds.size.height-500)];
//    self.arrowImageView.image = [UIImage imageNamed:@"compass"];
//    self.arrowImageView.center = self.view.center;
//    [self.view addSubview:self.arrowImageView];
    
    geoPointCompass = [[GeoPointCompass alloc] init];
    
    // Add the image to be used as the compass on the GUI
    //[geoPointCompass setArrowImageView:self.arrowImageView];
    [geoPointCompass setArrowImageView:self.compassArrowImageView];
    
    // Set the coordinates of the location to be used for calculating the angle
    geoPointCompass.latitudeOfTargetedPoint = self.locationManager.location.coordinate.latitude;
    geoPointCompass.longitudeOfTargetedPoint = self.locationManager.location.coordinate.longitude;
}

- (void)configureNavigationBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_icon"]];
}


- (void)menuButtonPressed:(id)sender {
    [HIKE_APP.homeController menuAction];
}

- (void)homeButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

