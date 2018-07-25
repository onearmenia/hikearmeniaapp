//
//  MGLMapViewController.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/30/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "MGLMapViewController.h"
#import "Trail.h"
#import "UIImage+ImageWithColor.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "HANavigationController.h"
#import <Mapbox/MGLPointAnnotation.h>
#import "LocationCoordinate.h"
#import "TrailRoute.h"
#import <Mapbox/MGLMapView.h>
#import <Mapbox/MGLAnnotationImage.h>
#import "CustomCalloutView.h"
#import "CustomMGLPointAnnotation.h"
#import "TrailDetailViewController.h"
#import "PathTracker.h"
#import "SCLAlertView.h"
#import "SCLMacros.h"
#import "OfflineTrailsViewController.h"

@interface MGLMapViewController ()

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *annotations;
@property (weak, nonatomic) IBOutlet UIButton *trackingButton;
@property (strong, nonatomic) PathTracker *pathTracker;
@property (strong, nonatomic) NSMutableArray *coordinates;
@property (strong, nonatomic) UIButton *checkmark;

@end


@implementation MGLMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    
    //[self.currenLocationButton setTitleColor:[UIColor colorWithRed:65.0/255.0 green:117.0/255.0 blue:5.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTrailSavedStatusChangedNotification:)
                                                 name:@"trailSavedStatusChangedNotification"
                                               object:nil];
    self.mapView.camera.centerCoordinate = CLLocationCoordinate2DMake(40.1792, 44.4991);
    [self drawFlags];
    [self.currentLocationButton setTitleColor:[UIColor colorWithRed:65.0/255.0 green:117.0/255.0 blue:5.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    self.pathTracker = [PathTracker sharedPathTracker];
    self.pathTracker.delegate = self;
    
    self.trackingButton.hidden = YES;
}


- (void) receiveTrailSavedStatusChangedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"trailSavedStatusChangedNotification"]) {
        if (self.showSavedTrails) {
//            Trail *updatedTrail = [notification.userInfo objectForKey:@"trail"];
//            for (int i = 0; i<self.trails.count; i++) {
//                Trail *trail = [self.trails objectAtIndex:i];
//                if (trail.index == updatedTrail.index) {
//                        trail.isSaved = !trail.isSaved;
//                    
//                    
//                }
//            }
            [self drawFlags];
        }
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureNavigationBar];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)drawFlags {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    self.annotations = [[NSMutableArray alloc] init];
    
    if (self.showSavedTrails) {
        for (Trail *trail in self.trails) {
            if (trail.isSaved) {
                if (!isnan(trail.startLocation.latitude) && !isnan(trail.startLocation.longitude)) {
                    CustomMGLPointAnnotation *annotation =[self drawFlagForTrail:trail];
                    annotation.obj = trail;
                    annotation.title = @"";
                    if (annotation) {
                        [self.annotations addObject:annotation];
                    }
                }
            }
        }

    } else {
        for (Trail *trail in self.trails) {
            if (!isnan(trail.startLocation.latitude) && !isnan(trail.startLocation.longitude)) {
                CustomMGLPointAnnotation *annotation =[self drawFlagForTrail:trail];
                annotation.obj = trail;
                annotation.title = @"";
                if (annotation) {
                    [self.annotations addObject:annotation];
                }
                
            }
        }
    }
    
    
    [self.mapView showAnnotations:self.annotations animated:YES];
    
   }

- (CustomMGLPointAnnotation *)drawFlagForTrail:(Trail *)trail {
    CustomMGLPointAnnotation *pointAnnotation = [[CustomMGLPointAnnotation alloc] init];
    if (!isnan(trail.startLocation.latitude) && !isnan(trail.startLocation.longitude)) {
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(trail.startLocation.latitude, trail.startLocation.longitude);
        [self.mapView addAnnotation:pointAnnotation];
    }
    return pointAnnotation;
}

- (void)configureNavigationBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    if (self.showSavedTrails) {
        self.navigationItem.title = @"Favorite Trails";
        UILabel *titleLabel = [UILabel new];
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;
    } else {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_icon"]];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"Trails map";
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self configureNavigationBar];
    
    [self.trackingButton setImage:[UIImage imageNamed:self.pathTracker.isTracking?@"stopTrackingBig":@"startTrackingBig"] forState:UIControlStateNormal];
    
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
    
}

- (void)menuButtonPressed:(id)sender {
    [HIKE_APP.homeController menuAction];
}

- (void)homeButtonPressed:(id)sender {
    if (self.isOffline) {
        
        
        [UIView transitionFromView:self.view toView:self.offlineTrailsViewController.view duration:0.7 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            [self.navigationController popToViewController:self.offlineTrailsViewController animated:NO];
        }];
    } else {
        NSArray *viewControllers = self.navigationController.viewControllers;
        UIViewController *rootViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
        
        
        [UIView transitionFromView:self.view toView:rootViewController.view duration:0.7 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
//    [UIView transitionWithView:self.navigationController.view
//                      duration:0.7
//                       options:UIViewAnimationOptionTransitionFlipFromLeft
//                    animations:^{
//                        [self.navigationController popToRootViewControllerAnimated:NO];
//                    }
//                    completion:nil];
}

- (IBAction)currentLocationButtonPressed:(id)sender {
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    } else if(!([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways) && !([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)){
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SlideInFromTop;
        alert.circleIconHeight = 30.0f;
        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"" subTitle:@"Please, enable location services for HIKEArmenia."  closeButtonTitle:@"OK" duration:0.0f];
    }
    
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma MGLMapViewDelegate methods
- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"flag"];
    
    if ( ! annotationImage)
    {
        UIImage *image = [UIImage imageNamed:@"flag"];
        
        //image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(100.0, 0, 0, 0)];
        
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"flag"];
    }
    
    return annotationImage;
}

- (UIView<MGLCalloutView> *)mapView:(__unused MGLMapView *)mapView calloutViewForAnnotation:(id<MGLAnnotation>)annotation
{
    CustomCalloutView *calloutView = [[CustomCalloutView alloc] init];
    calloutView.annotation = annotation;
    calloutView.representedObject = annotation;
    calloutView.delegate = self;
    return calloutView;
}


- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    // Always try to show a callout when an annotation is tapped.
    return YES;
}


-(void)mapView:(MGLMapView *)mapView tapOnCalloutForAnnotation:(id<MGLAnnotation>)annotation{
    CustomMGLPointAnnotation *annotationTrail = (CustomMGLPointAnnotation *)annotation;
    if (annotationTrail && annotationTrail.obj) {
        TrailDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrailDetailViewController"];
        if ([annotationTrail.obj isKindOfClass:[Trail class]]) {
            Trail *trail = (Trail *)annotationTrail.obj;
            vc.trail = trail;
        }
        
        vc.isOffline = self.isOffline;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)locationTrackingButtonPressed:(id)sender {
    
    if (self.pathTracker.isTracking) {
        [self.pathTracker stopTracking];
        
        [self.trackingButton setImage:[UIImage imageNamed:@"startTrackingBig"] forState:UIControlStateNormal];
    } else {
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
            self.mapView.showsUserLocation = YES;
            [self.locationManager requestAlwaysAuthorization];
            [self.pathTracker startTracking];
            [self.trackingButton setImage:[UIImage imageNamed:@"stopTrackingBig"] forState:UIControlStateNormal];
            
        } else if(!([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways) && !([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)){
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"" subTitle:@"Please, enable location services for HIKEArmenia."  closeButtonTitle:@"OK" duration:0.0f];
        } else {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if (![userDefaults boolForKey:@"doNotShowTrackingMessage"]) {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                self.checkmark = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 20.0, 20.0)];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
                [self.checkmark addTarget:self action:NSSelectorFromString(@"checkmarkPressed") forControlEvents:UIControlEventTouchUpInside];
                [self.checkmark setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
                [self.checkmark setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                [view addSubview:self.checkmark];
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0, 210.0, 50.0)];
                text.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:14.0];
                text.numberOfLines = 0;
                text.textColor = UIColorFromHEX(0x4D4D4D);
                text.preferredMaxLayoutWidth = text.frame.size.width;
                text.text = @"Don't show me this message again";
                [view addSubview:text];
                [alert addCustomView:view];
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"" subTitle:@"Start tracking your route"  closeButtonTitle:@"OK" duration:0.0f];
            }

            [self.pathTracker startTracking];
            [self.trackingButton setImage:[UIImage imageNamed:@"stopTrackingBig"] forState:UIControlStateNormal];
        }
    }
    self.coordinates = [self.pathTracker.coordinates copy];
   // [self updatePolyline];
    
}

- (void) checkmarkPressed {
    self.checkmark.selected = !self.checkmark.selected;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.checkmark.selected) {
        [userDefaults setBool:YES forKey:@"doNotShowTrackingMessage"];
    } else {
        [userDefaults setBool:NO forKey:@"doNotShowTrackingMessage"];
    }
    
    [userDefaults synchronize];
}

- (void)updatePolyline {
    NSUInteger coordinatesCount = self.coordinates.count;
    
    CLLocationCoordinate2D coordinatesToDraw[coordinatesCount];
    for (NSUInteger index = 0; index < coordinatesCount; index++)
    {
        CLLocationCoordinate2D old_coordinate;
        [[self.coordinates objectAtIndex:index] getValue:&old_coordinate];
        coordinatesToDraw[index] = CLLocationCoordinate2DMake(old_coordinate.latitude, old_coordinate.longitude);
    }
    
    MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinatesToDraw count:coordinatesCount];
    
    //[self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:polyline];
    
}
- (IBAction)defaultMapStyleButtonPressed:(id)sender {
    self.mapView.styleURL = nil;
}
- (IBAction)sateliteMapStyleButtonPressed:(id)sender {
    self.mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/mapbox/satellite-streets-v9"];
}

- (IBAction)TerrainMapStyleButtonPressed:(id)sender {
//    self.mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/hovhlusine/cityeuvn600cy2iqg7e2ghqjv"];
    self.mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/hovhlusine/citzoystx00g32iqg46g1vqe1"];
    
}
#pragma PathTrackerDelegate methods
- (void)userLocationUpdated {
    PathTracker *tracker = [PathTracker sharedPathTracker];
    self.coordinates = [tracker.coordinates copy];
    //[self updatePolyline];
}

#pragma CLLocationManagerDelegate methods
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse) {
        MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
        point.coordinate = self.locationManager.location.coordinate;
        NSMutableArray *annotationsWithCurrentLocMutable = [[NSMutableArray alloc] init];
        [annotationsWithCurrentLocMutable addObjectsFromArray:self.annotations];
        [annotationsWithCurrentLocMutable addObject:point];
        NSArray *annotationsWithCurrentLoc = [annotationsWithCurrentLocMutable copy];
        
        
        
        
        MGLPointAnnotation *currentLoc = [[MGLPointAnnotation alloc] init];
        currentLoc.coordinate = self.locationManager.location.coordinate;
        
        
        [self.mapView showAnnotations:annotationsWithCurrentLoc animated:YES];
        
        self.mapView.showsUserLocation = YES;

    }
}
@end
