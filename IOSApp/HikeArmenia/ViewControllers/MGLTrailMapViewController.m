//
//  MGLTrailMapViewController.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/22/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "MGLTrailMapViewController.h"
#import <Mapbox/MGLMapView.h>
#import <Mapbox/MGLUserLocation.h>
#import <Mapbox/MGLPolyline.h>
#import "Trail.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "HANavigationController.h"
#import "TrailRoute.h"
#import "LocationCoordinate.h"
#import "UIImage+ImageWithColor.h"
#import "SCLAlertView.h"
#import <Mapbox/Mapbox.h>
#import <Mapbox/MGLPointAnnotation.h>
#import <Mapbox/MGLAnnotationImage.h>
#import "PathTracker.h"
#import "SCLMacros.h"
#import "UserRoute.h"
#import "UserRouteMO.h"
#import "LoginViewController.h"
#import "CustomMGLPointAnnotation.h"
#import "User.h"

@interface MGLTrailMapViewController ()

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (strong, nonatomic) NSMutableArray *coordinates;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MGLPolyline *polyline;
@property (strong, nonatomic) MGLPolyline *userRoutePolyline;
@property (strong, nonatomic) CustomMGLPointAnnotation *userRouteStart;
@property (strong, nonatomic) CustomMGLPointAnnotation *userRouteEnd;
@property (strong, nonatomic) PathTracker *pathTracker;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *trailNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UIButton *locationTrackingButton;
@property (strong, nonatomic) UIButton *checkmark;

@property (assign, nonatomic) NSInteger currentMapStyleIndex;

@end

@implementation MGLTrailMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
    
    self.trailNameLabel.text = self.trail.name;
    self.difficultyLabel.text = self.trail.difficultly;
    self.star1.image = (self.trail.averageRating >= 1) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    self.star2.image = (self.trail.averageRating >= 2) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    self.star3.image = (self.trail.averageRating >= 3) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    self.star4.image = (self.trail.averageRating >= 4) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    self.star5.image = (self.trail.averageRating >= 5) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    
    [self drawRoute];
    
    self.pathTracker = [PathTracker sharedPathTracker];
    self.pathTracker.delegate = self;
    self.coordinates = [[NSMutableArray alloc] init];
    
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    if (token && !self.isOffline) {
        [self loadRoute];
    }
    
    self.currentMapStyleIndex = 0;
    
}

- (void)loadRoute {
    [UserRoute loadRouteForTrail:self.trail callback:^(id result, long long contentLength, NSError *error) {
        if (!error) {
            UserRoute *userRoute = result;
            [self drawUserRoute:userRoute.route];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger trailBeingTracked = [[NSUserDefaults standardUserDefaults] integerForKey:ktrailBeingTracked];
    if (trailBeingTracked && trailBeingTracked != self.trail.index) {
        self.locationTrackingButton.userInteractionEnabled = NO;
        self.locationTrackingButton.alpha = 0.5;
    }
    self.screenName = @"Trail map";
    
    [self configureNavigationBar];
    
    
    [self.locationTrackingButton setImage:[UIImage imageNamed:self.pathTracker.isTracking?@"stopTrackingBig":@"startTrackingBig"] forState:UIControlStateNormal];
    
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
    
    [self deleteTrailFromShowTipsList];
    
    [self showUserRoute];
}

- (void)deleteTrailFromShowTipsList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *trailsToShowTip = [defaults objectForKey:ktrailsToShowTip];
    if (trailsToShowTip && [trailsToShowTip containsObject:[NSString stringWithFormat:@"%ld", (long)self.trail.index]]) {
        NSMutableArray *trailsToShowTipMutable = [trailsToShowTip mutableCopy];
        [trailsToShowTipMutable removeObject:[NSString stringWithFormat:@"%ld", (long)self.trail.index]];
        trailsToShowTip = [trailsToShowTipMutable copy];
    }
    [defaults setObject:trailsToShowTip forKey:ktrailsToShowTip];
    [defaults synchronize];
}

- (void)showUserRoute {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserRouteMO"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"trailId == %d", self.trail.index]];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
//    if(token) {
//        [request setPredicate:[NSPredicate predicateWithFormat:@"token == %@", token]];
//    } else {
//        [request setPredicate:[NSPredicate predicateWithFormat:@"token == 0"]];
//    }
    
    NSError *error = nil;
    NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching UserRouteMO objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    NSArray *notSaved = [results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSaved == nil"]];
    
    if (HIKE_APP.user && notSaved.count > 0 && !self.isOffline) {
        NSArray *withToken = [notSaved filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId == %d", HIKE_APP.user.index]];
        UserRouteMO *userRouteNotSaved;
        if (withToken.count > 0) {
            userRouteNotSaved = (UserRouteMO *)[withToken lastObject];
        } else {
            userRouteNotSaved = (UserRouteMO *)[notSaved lastObject];
        }
        UserRoute *userRoute = [[UserRoute alloc] init];
        userRoute.route = userRouteNotSaved.route;
        [self sendRequestToSaveRoute:userRoute];
        
    }
    
    UserRouteMO *userRouteMO;
    NSArray *withToken = [results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId == %d", HIKE_APP.user.index]];
    if (token && withToken.count > 0) {
        userRouteMO= (UserRouteMO *)[withToken lastObject];
    } else {
        NSArray *withoutToken = [results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId == nil"]];
        userRouteMO= (UserRouteMO *)[withoutToken lastObject];
    }
    
    [self drawUserRoute:userRouteMO.route];

}

- (void)drawUserRoute:(NSArray *)route {
    NSUInteger coordinatesCount = route.count;
    
    CLLocationCoordinate2D coordinatesToDraw[coordinatesCount];
    for (NSUInteger index = 0; index < coordinatesCount; index++)
    {
        LocationCoordinate *coordinate = [route objectAtIndex:index];
        coordinatesToDraw[index] = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    }
    
//    self.userRouteStart = [[CustomMGLPointAnnotation alloc] init];
//    self.userRouteStart.isUser = YES;
//    LocationCoordinate *locationStart = [route firstObject];
//    self.userRouteStart.coordinate = CLLocationCoordinate2DMake(locationStart.latitude, locationStart.longitude);
//    [self.mapView addAnnotation:self.userRouteStart];
//    self.userRouteEnd = [[CustomMGLPointAnnotation alloc] init];
//    self.userRouteEnd.isUser = YES;
//    LocationCoordinate *locationEnd = [route lastObject];
//    self.userRouteEnd.coordinate = CLLocationCoordinate2DMake(locationEnd.latitude, locationEnd.longitude);
//    [self.mapView addAnnotation:self.userRouteEnd];
//
//    
//    CustomMGLPointAnnotation *start = [[CustomMGLPointAnnotation alloc] init];
//    NSString *lat1 = [[route firstObject] objectForKey:@"latitude"];
//    NSString *lon1 = [[route firstObject] objectForKey:@"longitude"];
//    start.coordinate = CLLocationCoordinate2DMake([lat1 floatValue], [lon1 floatValue]);
//    [self.mapView addAnnotation:start];
//    CustomMGLPointAnnotation *end = [[CustomMGLPointAnnotation alloc] init];
//    NSString *lat2 = [[route lastObject] objectForKey:@"latitude"];
//    NSString *lon2 = [[route lastObject] objectForKey:@"longitude"];
//    end.coordinate = CLLocationCoordinate2DMake([lat2 floatValue], [lon2 floatValue]);
//    [self.mapView addAnnotation:end];
    
    
    
    self.userRoutePolyline = [MGLPolyline polylineWithCoordinates:coordinatesToDraw count:coordinatesCount];
    CustomMGLPointAnnotation *currentLoc = [[CustomMGLPointAnnotation alloc] init];
    currentLoc.coordinate = self.locationManager.location.coordinate;
    
    [self.mapView addAnnotation:self.userRoutePolyline];
    NSMutableArray *objToShow = [[NSMutableArray alloc] init];
    NSInteger trailBeingTracked = [[NSUserDefaults standardUserDefaults] integerForKey:ktrailBeingTracked];
    if (self.userRoutePolyline.pointCount > 0 && trailBeingTracked && trailBeingTracked==self.trail.index) {
        [objToShow addObject:self.userRoutePolyline];
    }
    [objToShow addObject:self.polyline];
    [self.mapView showAnnotations:[objToShow copy] animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeMapStyleButtonTapped {
    self.currentMapStyleIndex ++;
    if (self.currentMapStyleIndex >= [[self styles] count]) {
        self.currentMapStyleIndex = 0;
    }
    if (self.currentMapStyleIndex == 0) {
        self.mapView.styleURL = nil;
    } else {
        NSString *style = [[self styles] objectAtIndex:self.currentMapStyleIndex];
        self.mapView.styleURL = [NSURL URLWithString:style];

    }
}

- (void)drawRoute {
    NSUInteger coordinatesCount = self.trail.route.routeArray.count;
    
    CLLocationCoordinate2D coordinatesToDraw[coordinatesCount];
    for (NSUInteger index = 0; index < coordinatesCount; index++)
    {
        LocationCoordinate *coordinate = [self.trail.route.routeArray objectAtIndex:index];
        coordinatesToDraw[index] = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    }
    

    CustomMGLPointAnnotation *start = [[CustomMGLPointAnnotation alloc] init];
    LocationCoordinate *locationStart = [self.trail.route.routeArray firstObject];
    start.coordinate = CLLocationCoordinate2DMake(locationStart.latitude, locationStart.longitude);
    [self.mapView addAnnotation:start];
    CustomMGLPointAnnotation *end = [[CustomMGLPointAnnotation alloc] init];
    LocationCoordinate *locationEnd = [self.trail.route.routeArray lastObject];
    end.coordinate = CLLocationCoordinate2DMake(locationEnd.latitude, locationEnd.longitude);
    [self.mapView addAnnotation:end];


    
    self.polyline = [MGLPolyline polylineWithCoordinates:coordinatesToDraw count:coordinatesCount];
    CustomMGLPointAnnotation *currentLoc = [[CustomMGLPointAnnotation alloc] init];
    currentLoc.coordinate = self.locationManager.location.coordinate;
    //[self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView addAnnotation:self.polyline];
    
    [self.mapView showAnnotations:[NSArray arrayWithObjects:self.polyline, nil] animated:YES];

}

//#pragma CLLocationManagerDelegate methods
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
//    
//    [self.coordinates addObject:[NSValue valueWithBytes:&loc objCType:@encode(CLLocationCoordinate2D)]];
//    
//}


#pragma MGLMapViewDelegate methods
//- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation {
//    //[self.mapView setCenterCoordinate:userLocation.location.coordinate
//    //                        zoomLevel:11
//    //                         animated:NO];
//    
//    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
//    
//    [self.coordinates addObject:[NSValue valueWithBytes:&loc objCType:@encode(CLLocationCoordinate2D)]];
//    
//    
//    //[self updatePolyline];
//    
//    
//}

- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation
{
    if ([annotation isEqual:self.polyline]) {
        return 3.0f;
    }
    return 3.0f;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation
{
    if ([annotation isEqual:self.polyline]) {
        return [UIColor colorWithRed:65.0/255.0 green:117.0/255.0 blue:5.0/255.0 alpha:1.0];
    }
    return [UIColor redColor];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"markerNewWithSpace"];
    
    if ( ! annotationImage)
    {
        UIImage *image = [UIImage imageNamed:@"markerNewWithSpace"];
    
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(100.0, 0, 0, 0)];
        
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"markerNewWithSpace"];
    }
    
    return annotationImage;
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


- (void)configureNavigationBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Stack_Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(changeMapStyleButtonTapped)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_icon"]];
}

- (IBAction)locationTrackingButtonPressed:(id)sender {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    if (self.pathTracker.isTracking) {
        
        UserRoute *userRoute = [self createUserRouteObj];
        
        [self deleteAnonymUserTrails];
        
        [self createOrUpdateUserRouteMOWithUserRoute:userRoute];
        
        if(!self.isOffline) {
            if (token) {
                [self sendRequestToSaveRoute:userRoute];
            } else {
                LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                vc.returnAfterLogin = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ktrailBeingTracked];
        [self.pathTracker stopTracking];
        [self.locationTrackingButton setImage:[UIImage imageNamed:@"startTrackingBig"] forState:UIControlStateNormal];
    } else {
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
        }
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
            self.mapView.showsUserLocation = YES;
            [self.locationManager requestAlwaysAuthorization];
            
        } else if(!([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways) && !([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)){
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"" subTitle:@"Please, enable location services for HIKEArmenia."  closeButtonTitle:@"OK" duration:0.0f];
        } else {
            [self showAlertForTrackingIfNeeded];
            if (self.userRoutePolyline) {
                [self.mapView removeAnnotation:self.userRoutePolyline];
            }
            [self.locationManager requestAlwaysAuthorization];
            [[NSUserDefaults standardUserDefaults] setInteger:self.trail.index forKey:ktrailBeingTracked];
            [self.pathTracker startTracking];
            [self.locationTrackingButton setImage:[UIImage imageNamed:@"stopTrackingBig"] forState:UIControlStateNormal];
        }
        
        
    }
    self.coordinates = [self.pathTracker.coordinates copy];
    [self updatePolyline];

}

- (void)showAlertForTrackingIfNeeded {
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
        [view addSubview:text];[alert addCustomView:view];
        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"" subTitle:@"Start tracking your route"  closeButtonTitle:@"OK" duration:0.0f];
    }

}

- (UserRoute *)createUserRouteObj {
    UserRoute *userRoute = [[UserRoute alloc] init];
    
    NSMutableArray *coordinates = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.coordinates.count; i++) {
        CLLocationCoordinate2D coordinate;
        [[self.coordinates objectAtIndex:i] getValue:&coordinate];
        LocationCoordinate *coordinateObj = [[LocationCoordinate alloc] init];
        coordinateObj.latitude = coordinate.latitude;
        coordinateObj.longitude = coordinate.longitude;
//        NSArray *keys = [[NSArray alloc] initWithObjects:@"latitude", @"longitude", nil];
//        NSArray *values = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:coordinate.latitude], [NSNumber numberWithDouble:coordinate.longitude], nil];
//        NSDictionary *coordinateDictionary = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
//        [coordinates addObject:coordinateDictionary];
        [coordinates addObject:coordinateObj];
    }
    
    userRoute.route = coordinates;
    return userRoute;
}

- (void)deleteAnonymUserTrails {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    if (!token) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserRouteMO"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"trailId == %d", self.trail.index]];
        if([[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey]) {
            [request setPredicate:[NSPredicate predicateWithFormat:@"userId == 0"]];
        }
        
        NSError *error = nil;
        NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
        if (!results) {
            NSLog(@"Error fetching UserRouteMO objects: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        } else {
            for (NSManagedObject *obj in results) {
                [[[self class] managedObjectContext] deleteObject:obj];
            }
        }
    }
}

- (void)createOrUpdateUserRouteMOWithUserRoute:(UserRoute *)userRoute {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserRouteMO"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"trailId == %d", self.trail.index]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userId == %d", HIKE_APP.user.index]];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey]) {
        [request setPredicate:[NSPredicate predicateWithFormat:@"userId == 0"]];
    }
    
    NSError *error = nil;
    NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching UserRouteMO objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    } else {
        UserRouteMO *userRouteMO;
        if (results.count > 0) {
            userRouteMO = [results lastObject];
        } else {
            userRouteMO = [NSEntityDescription insertNewObjectForEntityForName:@"UserRouteMO" inManagedObjectContext:[[self class] managedObjectContext]];
        }
        userRouteMO.trailId = [NSNumber numberWithInteger:self.trail.index];
        if (token) {
            userRouteMO.userId = [NSNumber numberWithInteger:HIKE_APP.user.index];
        } else {
            userRouteMO.userId = 0;
        }
        
        userRouteMO.route = userRoute.route;
    }
    
    error = nil;
    if ([[[self class] managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void)sendRequestToSaveRoute:(UserRoute *)userRoute {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    [userRoute addRouteForTrail:self.trail callback:^(id result, long long contentLength, NSError *error) {
        if (!error) {
            if(![result boolValue])
            {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                alert.showAnimationType = SlideInFromTop;
                alert.circleIconHeight = 30.0f;
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
            } else {
                if (token) {
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserRouteMO"];
                    [request setPredicate:[NSPredicate predicateWithFormat:@"trailId == %d", self.trail.index]];
                    [request setPredicate:[NSPredicate predicateWithFormat:@"userId == %d", HIKE_APP.user.index]];
                                        
                    
                    NSError *error = nil;
                    NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
                    if (!results) {
                        NSLog(@"Error fetching UserRouteMO objects: %@\n%@", [error localizedDescription], [error userInfo]);
                        abort();
                    } else {
                        if (results.count > 0) {
                            UserRouteMO *userRoute = (UserRouteMO *)[results objectAtIndex:0];
                            userRoute.isSaved = YES;
                            userRoute.userId = [NSNumber numberWithInteger:HIKE_APP.user.index];
                            if ([[[self class] managedObjectContext] save:&error] == NO) {
                                NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                            }
                        }
                    }
                }
            }
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost) {
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:@"The Internet connection appears to be offline"  closeButtonTitle:@"OK" duration:0.0f];
            } else if(error.code == 401){
                //LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                //vc.returnAfterLogin = YES;
                //[self.navigationController pushViewController:vc animated:YES];
            } else {
                [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
            }
        }
        
        
    }];

}
- (void) checkmarkPressed{
    self.checkmark.selected = !self.checkmark.selected;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.checkmark.selected) {
        [userDefaults setBool:YES forKey:@"doNotShowTrackingMessage"];
    } else {
        [userDefaults setBool:NO forKey:@"doNotShowTrackingMessage"];
    }
    [userDefaults synchronize];
}

- (IBAction)currentLocationButtonPressed:(id)sender {
    //self.mapView.userTrackingMode = MGLUserTrackingModeFollow;
    
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

    
//    
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [self.locationManager requestAlwaysAuthorization];
//    [self.locationManager startUpdatingLocation];
//    
//    CustomMGLPointAnnotation *point = [[CustomMGLPointAnnotation alloc] init];
//    point.coordinate = self.locationManager.location.coordinate;
//    [self.mapView showAnnotations:[NSArray arrayWithObjects:self.polyline, point, nil] animated:YES];
}

- (IBAction)infoViewDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma PathTrackerDelegate methods
- (void)userLocationUpdated {
    PathTracker *tracker = [PathTracker sharedPathTracker];
    self.coordinates = [tracker.coordinates copy];
    [self updatePolyline];
}

#pragma CLLocationManagerDelegate methods
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse) {
        CustomMGLPointAnnotation *point = [[CustomMGLPointAnnotation alloc] init];
        point.coordinate = self.locationManager.location.coordinate;
        
        CustomMGLPointAnnotation *currentLoc = [[CustomMGLPointAnnotation alloc] init];
        currentLoc.coordinate = self.locationManager.location.coordinate;
        
        if (point.coordinate.latitude != 0 && point.coordinate.longitude != 0) {
            [self.mapView showAnnotations:[NSArray arrayWithObjects:self.polyline, point, nil] animated:YES];
        }
        
        self.mapView.showsUserLocation = YES;
        
        if (self.pathTracker.isTracking) {
            [self.pathTracker startTracking];
            [self.locationTrackingButton setImage:[UIImage imageNamed:@"stopTrackingBig"] forState:UIControlStateNormal];
        }
        
    }
}

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (NSArray *)styles {
    return @[@"",
             @"mapbox://styles/mapbox/satellite-streets-v9"];
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
