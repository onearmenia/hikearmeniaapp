//
//  MGLAccomodationMapViewController.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 9/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "MGLAccomodationMapViewController.h"
#import "CustomMGLPointAnnotation.h"
#import "Accomodation.h"
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
#import "TrailDetailViewController.h"
#import "PathTracker.h"
#import "SCLAlertView.h"
#import "SCLMacros.h"

@interface MGLAccomodationMapViewController ()

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;

@property (strong, nonatomic) NSMutableArray *annotations;

@end

@implementation MGLAccomodationMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    
    [self drawAnnotation];
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

- (void)configureNavigationBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Stack_Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(homeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_icon"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.screenName = @"Trails map";
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self configureNavigationBar];
    
}

- (void)drawAnnotation {
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    self.annotations = [[NSMutableArray alloc] init];
   
    if (!isnan(self.accomodation.coordinate.latitude) && !isnan(self.accomodation.coordinate.longitude) && self.accomodation.coordinate.latitude != 0 && self.accomodation.coordinate.longitude != 0) {
        CustomMGLPointAnnotation *annotation =[self drawFlagForAccomodation:self.accomodation];
        annotation.title = @"";
        if (annotation) {
            [self.annotations addObject:annotation];
        }
                
    } else {
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(40.1792, 44.4991);
        self.mapView.zoomLevel = 6.0f;
    }
    
    
}


- (CustomMGLPointAnnotation *)drawFlagForAccomodation:(Accomodation *)accomodation {
    CustomMGLPointAnnotation *pointAnnotation = [[CustomMGLPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(accomodation.coordinate.latitude, accomodation.coordinate.longitude);
    pointAnnotation.obj = self.accomodation;
    [self.mapView addAnnotation:pointAnnotation];
    
    [self.mapView setCenterCoordinate:pointAnnotation.coordinate];
    [self.mapView setZoomLevel:11.0f animated:NO];

    
    return pointAnnotation;
}

- (void)menuButtonPressed:(id)sender {
    [HIKE_APP.homeController menuAction];
}

- (void)homeButtonPressed:(id)sender {
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *rootViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
        
        
    [UIView transitionFromView:self.view toView:rootViewController.view duration:0.7 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma MGLMapViewDelegate methods
- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"markerNew"];
    
    if ( ! annotationImage)
    {
        UIImage *image = [UIImage imageNamed:@"markerNew"];
        
        //image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(100.0, 0, 0, 0)];
        
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"markerNew"];
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

@end
