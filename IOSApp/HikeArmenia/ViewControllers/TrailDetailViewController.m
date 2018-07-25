//
//  TrailDetailViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/26/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailDetailViewController.h"
#import "Trail.h"
#import "TrailReviews.h"
#import "Accomodations.h"
#import "Accomodation.h"
#import "HikeAPI.h"
#import "Definitions.h"
#import "ImageContentView.h"
#import "TrailTipsViewController.h"
#import "LocalGuidesViewController.h"
#import "Guides.h"
#import "AccomodationContentView.h"
#import "LoginViewController.h"
#import "TrailsViewController.h"
#import "AddTrailTipViewController.h"
#import "AccomodationViewController.h"
#import <UIKit/UIActivityViewController.h>
#import "TrailReviewsViewController.h"
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"
#import "UIImage+Additions.h"
#import "UIImageEffects.h"
#import "CompassViewController.h"
#import "Weather.h"
#import "UIImageView+AFNetworking.h"
#import "MGLTrailMapViewController.h"
#import "UIView+Additions.h"
#import "TakePhotoViewController.h"
#import "TrailMO.h"
#import "GuidesMO.h"
#import "LocationCoordinate.h"
#import "TrailRoute.h"
#import "OfflineTrailsViewController.h"
#import "UIDevice+Hardware.h"

@interface TrailDetailViewController () {
	NSMutableArray *viewForTrailImagesArray;
	NSMutableDictionary *viewsForTrailImagesDict;
    NSMutableArray *viewForAccArray;
    NSMutableDictionary *viewsForAccDict;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accomodationImagesScrollViewHeightconstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomToolbar;
@property (weak, nonatomic) IBOutlet UIScrollView *trailImagesScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *accomodationImagesScrollView;
@property (weak, nonatomic) IBOutlet UILabel *trailNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *higherPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowerPointLabel;
@property (weak, nonatomic) IBOutlet UITextView *thingsToDo;
@property (weak, nonatomic) IBOutlet UITextView *information;
@property (weak, nonatomic) IBOutlet UIButton *addTrailTipButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thingsToDoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailTipsContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guidesContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guidesViewContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreGuideButton;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreTipsButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *distanceFromLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureIcon;

@property (weak, nonatomic) IBOutlet UILabel *thigsToDoLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *localGuidesLabel;
@property (weak, nonatomic) IBOutlet UILabel *localAccomodationLabel;
@property (weak, nonatomic) IBOutlet UILabel *trailTipsLabel;
@property (weak, nonatomic) IBOutlet UIView *localGuidesView;
@property (weak, nonatomic) IBOutlet UIButton *toolbarSavedTrailsButton;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *placeholderViewForThingsToDo;
@property (weak, nonatomic) IBOutlet UIView *placeholderViewForInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderRunningForThingsToDoLeadingConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderRunningForThingsToDoLeadingConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderRunningForThingsToDoLeadingConstraint3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderRunningForInfoLeadingConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderRunningForInfoLeadingConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderRunningForInfoLeadingConstraint3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderRunningForThingsToDoWidthConstraint1;

@property (weak, nonatomic) IBOutlet UIView *placeholderForThingsToDoView1;
@property (weak, nonatomic) IBOutlet UIView *placeholderForThingsToDoView2;
@property (weak, nonatomic) IBOutlet UIView *placeholderForThingsToDoView3;
@property (weak, nonatomic) IBOutlet UIView *placeholderForInfoView1;
@property (weak, nonatomic) IBOutlet UIView *placeholderForInfoView2;
@property (weak, nonatomic) IBOutlet UIView *placeholderForInfoView3;
@property (strong, nonatomic) LocalGuidesViewController *localGuidesViewController;
@property (strong, nonatomic) TrailTipsViewController *trailTipsViewController;
@property (strong, nonatomic) TrailReviewsViewController *trailReviewsViewController;
@property (strong, nonatomic) MGLTrailMapViewController *trailMapViewController;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (assign, nonatomic) CGFloat trailNameLabelViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailNameLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *trailImageOverlayView;
@property (weak, nonatomic) IBOutlet UIPageControl *trailImagesPageControll;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (nonatomic) CGFloat lastContentOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarHeightConstraint;
@property (nonatomic) CGFloat previousScrollViewYOffset;
@property (weak, nonatomic) IBOutlet UILabel *trailMainNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *mainSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localAccomodationsLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localAccomodationsLabelTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localAccomodationsLabelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seeMoreGuidesHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *separator3View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accomodationsScrollViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UISwitch *offlineUsageSwitch;
@property (strong, nonatomic) TrailMO *offlineTrail;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIView *tipContentView;
@property (weak, nonatomic) IBOutlet UIImageView *tipArrowImgView;
@property (weak, nonatomic) IBOutlet UILabel *tipTextLabel;
@end

@implementation TrailDetailViewController

static CGFloat const trailImageScale = 2.0/3.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	viewForTrailImagesArray = [[NSMutableArray alloc] init];
	viewsForTrailImagesDict  = [[NSMutableDictionary alloc] init];
    
    viewForAccArray = [[NSMutableArray alloc] init];
    viewsForAccDict  = [[NSMutableDictionary alloc] init];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
    [self layoutTempTrailGalleryView];
    
    self.offlineTrail = [[self fetchTrails] firstObject];
    if (self.offlineTrail) {
        self.offlineUsageSwitch.on = YES;
    } else {
        self.offlineUsageSwitch.on = NO;
    }
    [self loadTrailDetails];
    self.trailNameLabelViewTopSpace = trailImageScale * [UIScreen mainScreen].bounds.size.width - 70.0f;
    
    self.trailImageOverlayView.userInteractionEnabled = NO;
    self.trailImageOverlayView.backgroundColor = [UIColor clearColor];
    //self.trailImageOverlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    [UIView addGradientBottomToView:self.trailImageOverlayView];
    [UIView addGradientTopToView:self.trailImageOverlayView];
    self.trailImageOverlayView.alpha = 0;
    //self.trailNameLabel.adjustsFontSizeToFitWidth = YES;
    //self.trailNameLabel.minimumScaleFactor = 0.5;
    self.trailMainNameLabel.adjustsFontSizeToFitWidth = YES;
    self.trailMainNameLabel.minimumScaleFactor = 0.5;
    self.trailNameLabel.hidden = YES;
    //self.topBarView.hidden = YES;
    self.topBarView.alpha = 0;
    
    if (self.isOffline) {
        self.saveButton.hidden = YES;
        self.mainSaveButton.hidden = YES;
    } else {
        self.saveButton.hidden = NO;
        self.mainSaveButton.hidden = NO;
    }
    
    
    
    self.tipContentView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.tipContentView.layer.cornerRadius = 3.0f;
    self.tipArrowImgView.image = [[UIImage imageNamed:@"tipArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tipArrowImgView.tintColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.tipTextLabel.text = @"Please open the map once, so that you can then use this map offline.";
    self.tipTextLabel.numberOfLines = 0;
    self.tipView.userInteractionEnabled = NO;
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    //self.screenName = @"Trail detail";
    self.screenName = [NSString stringWithFormat:@"Trail %@ detail", self.trail.name];
    self.topBarView.alpha = 0;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.toolbarHeightConstraint.constant = 54.0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.trailImageOverlayView.alpha = 1;
        } completion: ^(BOOL finished) {}];
    }];
    if (self.savedTrailsButtonState) {
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"stackForToolbar"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"All Trails" forState:UIControlStateNormal];
    } else {
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"savedtrails"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"Favorite Trails" forState:UIControlStateNormal];
    }
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
	

	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:42.0/255.0 green:76.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:16.0f], NSKernAttributeName: @3.0};
	self.thigsToDoLabel.attributedText = [[NSAttributedString alloc] initWithString:@"THINGS TO SEE" attributes:attributes];
	self.informationLabel.attributedText = [[NSAttributedString alloc] initWithString:@"INFORMATION" attributes:attributes];
	self.localGuidesLabel.attributedText = [[NSAttributedString alloc] initWithString:@"LOCAL GUIDES" attributes:attributes];
	self.localAccomodationLabel.attributedText = [[NSAttributedString alloc] initWithString:@"LOCAL ACCOMMODATION" attributes:attributes];
	self.trailTipsLabel.attributedText = [[NSAttributedString alloc] initWithString:@"TRAIL TIPS" attributes:attributes];

//    [self loadTrailDetails];
//    [self layoutTempTrailGalleryView];

    self.trailImagesScrollView.userInteractionEnabled = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *trailsToShowTip = [defaults objectForKey:ktrailsToShowTip];
    if ([trailsToShowTip containsObject:[NSString stringWithFormat:@"%ld", (long)self.trail.index]]) {
        self.tipView.alpha = 1.0;
    } else {
        self.tipView.alpha = 0;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	self.navigationController.navigationBar.hidden = NO;
    self.toolbarHeightConstraint.constant = 0.0;
    self.topBarView.alpha = 0;
    [self.view layoutIfNeeded];
    
    [self saveTrailForOffline];
}

- (void)saveTrailForOffline {
    if (self.offlineUsageSwitch.isOn) {
        TrailMO *newTrail;
        if (self.offlineTrail) {
            newTrail = self.offlineTrail;
        } else {
            newTrail = [NSEntityDescription insertNewObjectForEntityForName:@"TrailMO" inManagedObjectContext:[[self class] managedObjectContext]];
        }
        
        [newTrail setIndex:[NSNumber numberWithInteger:[self.trail index]]];
        [newTrail setName:[self.trail name]];
        [newTrail setDifficultly:[self.trail difficultly]];
        [newTrail setThinksToDo:[self.trail thinksToDo]];
        [newTrail setInfo:[self.trail info]];
        
        if (!newTrail.startLocation) {
            [newTrail setStartLocation:[NSEntityDescription insertNewObjectForEntityForName:@"LocationCoordinateMO" inManagedObjectContext:[[self class] managedObjectContext]]];

        }
        newTrail.startLocation.latitude = self.trail.startLocation.latitude;
        newTrail.startLocation.longitude = self.trail.startLocation.longitude;
        
        [newTrail setLowerPoint:[NSNumber numberWithInteger:[self.trail lowerPoint]]];
        [newTrail setHigherPoint:[NSNumber numberWithInteger:[self.trail higherPoint]]];
        [newTrail setTemperature:[self.trail temperature]];
        [newTrail setDistance:[self.trail distance]];
        [newTrail setDuraion:[self.trail duraion]];
        
        [newTrail setCover:[self.trail cover]];
        [newTrail setCovers:[self.trail covers]];
        [newTrail setIsSaved:[self.trail isSaved]];
        [newTrail setAverageRating:[self.trail averageRating]];
        [newTrail setGuideCount:[NSNumber numberWithInteger:[self.trail guideCount]]];
        [newTrail setReviewCount:[NSNumber numberWithInteger:[self.trail reviewCount]]];
        
        if (!newTrail.guides) {
            [newTrail setGuides:[NSEntityDescription insertNewObjectForEntityForName:@"GuidesMO" inManagedObjectContext:[[self class] managedObjectContext]]];
        }
        [newTrail.guides setGuidesArray:self.trail.guides.guidesArray];
        
        if (!newTrail.weather) {
            [newTrail setWeather:[NSEntityDescription insertNewObjectForEntityForName:@"WeatherMO" inManagedObjectContext:[[self class] managedObjectContext]]];
        }
        [newTrail.weather setTemperature:self.trail.weather.temperature];
        [newTrail.weather setWeatherIcon:self.trail.weather.weatherIcon];
        
        if (!newTrail.accomodations) {
            [newTrail setAccomodations:[NSEntityDescription insertNewObjectForEntityForName:@"AccomodationsMO" inManagedObjectContext:[[self class] managedObjectContext]]];
        }
        [newTrail.accomodations setAccomodationsArray:self.trail.accomodations.accomodationsArray];
        
        if (!newTrail.reviews) {
            [newTrail setReviews:[NSEntityDescription insertNewObjectForEntityForName:@"TrailReviewsMO" inManagedObjectContext:[[self class] managedObjectContext]]];
        }
        [newTrail.reviews setReviewsArray:self.trail.reviews.reviewsArray];
        
        if (!newTrail.route) {
            [newTrail setRoute:[NSEntityDescription insertNewObjectForEntityForName:@"TrailRouteMO" inManagedObjectContext:[[self class] managedObjectContext]]];
        }
        
        [newTrail.route setRouteArray:self.trail.route.routeArray];
        
        [newTrail setMapImage:[self.trail mapImage]];
        self.offlineTrail = newTrail;
    } else {
        if (self.offlineTrail) {
            [[[self class] managedObjectContext] deleteObject:self.offlineTrail];
        }
    }
    
    NSError *error = nil;
    if ([[[self class] managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    if (self.isOffline) {
        if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[OfflineTrailsViewController class]]) {
            OfflineTrailsViewController *root = (OfflineTrailsViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            root.transitionNotUseDefault = YES;

        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        TrailsViewController *root = (TrailsViewController *)[self.navigationController.viewControllers firstObject];
        root.transitionNotUseDefault = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
	
}

- (void)loadingForNotLoadedTexts {
    self.placeholderRunningForThingsToDoLeadingConstraint1.constant = self.placeholderForThingsToDoView1.frame.size.width;
    self.placeholderRunningForThingsToDoLeadingConstraint2.constant = self.placeholderForThingsToDoView2.frame.size.width;
    self.placeholderRunningForThingsToDoLeadingConstraint3.constant = self.placeholderForThingsToDoView3.frame.size.width;
    self.placeholderRunningForInfoLeadingConstraint1.constant = self.placeholderForInfoView1.frame.size.width;
    self.placeholderRunningForInfoLeadingConstraint2.constant = self.placeholderForInfoView2.frame.size.width;
    self.placeholderRunningForInfoLeadingConstraint3.constant = self.placeholderForInfoView3.frame.size.width;
    [UIView animateWithDuration:0.7 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {
        self.placeholderRunningForThingsToDoWidthConstraint1.constant = 0;
        [UIView animateWithDuration:0.7 animations:^{
            [self.view layoutIfNeeded];
        } completion: ^(BOOL finished) {
        self.placeholderRunningForThingsToDoLeadingConstraint1.constant = -self.placeholderForThingsToDoView1.frame.size.width;
        self.placeholderRunningForThingsToDoLeadingConstraint2.constant = -self.placeholderForThingsToDoView2.frame.size.width;
        self.placeholderRunningForThingsToDoLeadingConstraint3.constant = -self.placeholderForThingsToDoView3.frame.size.width;
        self.placeholderRunningForInfoLeadingConstraint1.constant = -self.placeholderForInfoView1.frame.size.width;
        self.placeholderRunningForInfoLeadingConstraint2.constant = -self.placeholderForInfoView2.frame.size.width;
        self.placeholderRunningForInfoLeadingConstraint3.constant = -self.placeholderForInfoView3.frame.size.width;
        [self.view layoutIfNeeded];
        if (!(self.thingsToDo.text.length > 0 || self.information.text.length > 0)) {
            [self loadingForNotLoadedTexts];
        }
        }];
    }];
}

- (void)loadTrailDetails {
    [self loadingForNotLoadedTexts];
    //self.mainScrollView.scrollEnabled = NO;
    //self.view.userInteractionEnabled = NO;
    if (self.isOffline) {
        if(self.trail.covers.count > 0) {
            [self layoutTrailGalleryView];
        }
        [self configureDetailView];
    } else {
        if (self.offlineTrail) {
            self.trail = [self.offlineTrail trailMOtoTrail];
            if(self.trail.covers.count > 0) {
                [self layoutTrailGalleryView];
            }
            [self configureDetailView];
        }
        
        if (self.offlineTrail) {
            self.offlineUsageSwitch.userInteractionEnabled = NO;
        }
        self.mapImageView.userInteractionEnabled = NO;
        [self.trail loadTrailWithCallback:^(id result,long long contentLength, NSError *error) {
            self.offlineUsageSwitch.userInteractionEnabled = YES;
            self.mapImageView.userInteractionEnabled = YES;
            if (!error) {
                //self.mainScrollView.scrollEnabled = YES;
                //self.view.userInteractionEnabled = YES;
                self.trail = result;
                if (self.offlineTrail) {
                    [self.offlineTrail updateWithTrail:self.trail];
                    
                    NSError *error = nil;
                    if ([[[self class] managedObjectContext] save:&error] == NO) {
                        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                    }
                }
                if(self.trail.covers.count > 0 && !self.isOffline && !self.offlineTrail) {
                    [self layoutTrailGalleryView];
                }
                [self configureDetailView];
            }
            else {
                NSLog(@"ERROR: %@",[error description]);
                if (!self.offlineTrail) {
                    self.offlineUsageSwitch.userInteractionEnabled = NO;
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    alert.showAnimationType = SlideInFromTop;
                    alert.circleIconHeight = 30.0f;
                    if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost) {
                        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:@"The Internet connection appears to be offline"  closeButtonTitle:@"OK" duration:0.0f];
                    } else {
                        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
                    }

                }
                
            }
            //[CustomIndicatorLoadingView hideIndicator];
        }];
    }
}

- (void)configureDetailView {
    self.offlineUsageSwitch.userInteractionEnabled = YES;
    
    self.trailImagesPageControll.numberOfPages = self.trail.covers.count;
    
    self.star1.image = (self.trail.averageRating >= 1) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    self.star2.image = (self.trail.averageRating >= 2) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    self.star3.image = (self.trail.averageRating >= 3) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    self.star4.image = (self.trail.averageRating >= 4) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    self.star5.image = (self.trail.averageRating >= 5) ? [UIImage imageNamed:@"StarFull"] : [UIImage imageNamed:@"StarWhite"];
    self.saveButton.selected = self.trail.isSaved;
    self.mainSaveButton.selected = self.saveButton.selected;
    
//    if(self.trail.covers.count > 0) {
//        [self layoutTrailGalleryView];
//    }
    if(self.trail.accomodations.accomodationsArray.count > 0) {
        [self layoutAccomodationGalleryView];
    } else {
        self.accomodationImagesScrollViewHeightconstraint.constant = 0;
        self.localAccomodationsLabelHeightConstraint.constant = 0;
        self.localAccomodationsLabelTopConstraint.constant = 0;
        self.localAccomodationsLabelBottomConstraint.constant = 0;
        self.accomodationsScrollViewBottomConstraint.constant = 0;
        self.separator3View.hidden = YES;
    }
    [self.view layoutIfNeeded];
    
    self.trailNameLabel.text = self.trail.name;
    self.trailMainNameLabel.text = self.trail.name;
    self.difficultyLabel.text = self.trail.difficultly;
    self.distanceLabel.text = self.trail.distance;
    self.distanceFromLocationLabel.text = @"125 km away";
    if (self.trail.weather.temperature.length > 0) {
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@ °C", self.trail.weather.temperature];
        self.temperatureIcon.hidden = NO;
        if (self.trail.weather.weatherIcon.length > 0) {
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.trail.weather.weatherIcon]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            
            [self.temperatureIcon setImageWithURLRequest:imageRequest
                                  placeholderImage:nil
                                           success:nil
                                           failure:nil];
        }
    } else {
        self.temperatureIcon.hidden = YES;
    }
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *higherPointFormattedString = [formatter stringFromNumber:[NSNumber numberWithInteger:self.trail.higherPoint]];
    self.higherPointLabel.text = [NSString stringWithFormat:@"%@ m", higherPointFormattedString];
    NSString *lowerPointFormattedString = [formatter stringFromNumber:[NSNumber numberWithInteger:self.trail.lowerPoint]];
    self.lowerPointLabel.text = [NSString stringWithFormat:@"%@ m", lowerPointFormattedString];
    
    
    
//    self.distanceLabel.adjustsFontSizeToFitWidth = YES;
//    self.distanceLabel.preferredMaxLayoutWidth = self.distanceLabel.frame.size.width;
//    self.distanceLabel.minimumScaleFactor = 0.4f;
//    
//    self.higherPointLabel.adjustsFontSizeToFitWidth = YES;
//    self.higherPointLabel.preferredMaxLayoutWidth = self.higherPointLabel.frame.size.width;
//    self.higherPointLabel.minimumScaleFactor = 0.4f;
//    
//    self.lowerPointLabel.adjustsFontSizeToFitWidth = YES;
//    self.lowerPointLabel.preferredMaxLayoutWidth = self.lowerPointLabel.frame.size.width;
//    self.lowerPointLabel.minimumScaleFactor = 0.4f;
    
    
    
    self.placeholderViewForThingsToDo.hidden = YES;
    self.placeholderViewForInfo.hidden = YES;
    self.thingsToDo.text = self.trail.thinksToDo;
    self.information.text = self.trail.info;
    
    self.thingsToDoHeightConstraint.constant = [self.thingsToDo sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-80.0, CGFLOAT_MAX)].height;
    
    self.infoHeightConstraint.constant = [self.information sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width-80.0, CGFLOAT_MAX)].height;
    
    self.localGuidesViewController.guides = self.trail.guides.guidesArray;
    [self.localGuidesViewController updateGuides];
    if(self.trail.guides.guidesArray.count > 0) {
        self.guidesViewContainerHeightConstraint.constant = 235.0;
        self.seeMoreGuideButton.hidden = NO;
        self.localGuidesLabel.hidden = NO;
        if(self.trail.guides.guidesArray.count == 1) {
            self.guidesViewContainerHeightConstraint.constant = 100.0;
            self.guidesContainerHeightConstraint.constant = 85.0;
            self.seeMoreGuidesHeightConstraint.constant = 0;
        }
    }
    else {
        self.localGuidesLabel.hidden = YES;
        self.seeMoreGuideButton.hidden = YES;
        self.guidesViewContainerHeightConstraint.constant = 0.0;
    }
    
    self.trailTipsViewController.trail = self.trail;
    [self.trailTipsViewController reloadTips];
    if(self.trail.reviewCount > 0) {
        self.trailTipsContainerHeightConstraint.constant = 220.0;
        
        if(self.trail.reviewCount == 1) {
            self.trailTipsContainerHeightConstraint.constant = 110.0;
        }
    }
    else {
        self.seeMoreTipsButton.hidden = YES;
        self.trailTipsContainerHeightConstraint.constant = 0.0;
    }
    if (self.trail.mapImage.length > 0) {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.trail.mapImage]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        
        [self.mapImageView setImageWithURLRequest:imageRequest
                                    placeholderImage:[UIImage imageNamed:@"placeholderForTrail"]
                                             success:nil
                                             failure:nil];
        
        
    }
    if (self.trail.reviewCount < 1) {
        [self.addTrailTipButton setTitle:@"Be the first to give a tip" forState:UIControlStateNormal];
    }
    if (self.trail.guideCount <= 2) {
        self.seeMoreGuideButton.hidden = YES;
    } else {
        self.seeMoreGuideButton.hidden = NO;
    }
    //self.trailMapViewController.trail = self.trail;
    //[self.trailMapViewController drawRoute];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {}];
    
    [self calculateFontSizeForInfoBar];

}

- (void)calculateFontSizeForInfoBar {
    [self.distanceLabel layoutIfNeeded];
    [self.higherPointLabel layoutIfNeeded];
    [self.lowerPointLabel layoutIfNeeded];
    float horizontalSpace = self.distanceLabel.frame.size.width+self.higherPointLabel.frame.size.width+self.lowerPointLabel.frame.size.width;
    float intrinsicSize = self.distanceLabel.intrinsicContentSize.width + self.higherPointLabel.intrinsicContentSize.width + self.lowerPointLabel.intrinsicContentSize.width;
    
    while (intrinsicSize > horizontalSpace) {
        self.distanceLabel.font = [UIFont fontWithName:self.distanceLabel.font.fontName size:self.distanceLabel.font.pointSize-1];
        self.higherPointLabel.font = [UIFont fontWithName:self.higherPointLabel.font.fontName size:self.higherPointLabel.font.pointSize-1];
        self.lowerPointLabel.font = [UIFont fontWithName:self.lowerPointLabel.font.fontName size:self.lowerPointLabel.font.pointSize-1];
        [self.distanceLabel layoutIfNeeded];
        [self.higherPointLabel layoutIfNeeded];
        [self.lowerPointLabel layoutIfNeeded];
        horizontalSpace = self.distanceLabel.frame.size.width+self.higherPointLabel.frame.size.width+self.lowerPointLabel.frame.size.width;
        intrinsicSize = self.distanceLabel.intrinsicContentSize.width + self.higherPointLabel.intrinsicContentSize.width + self.lowerPointLabel.intrinsicContentSize.width;
    }
}

- (float)calculateSizeForTextView:(UITextView *)textView leadingConstraint:(float)leading {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize bound  = CGSizeMake([UIScreen mainScreen].bounds.size.width-2*leading, CGFLOAT_MAX);
    CGRect newRect = [textView.text boundingRectWithSize:bound
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName:textView.font,NSParagraphStyleAttributeName: paragraph}
                                              context:nil];
    return ceilf(newRect.size.height);
    
}

- (void)layoutTrailGalleryView {
	[viewsForTrailImagesDict setObject:self.trailImagesScrollView forKey:@"parent"];
    NSString *urlToAppend = [[NSString alloc] init];
	for (NSString *url in self.trail.covers) {
        if (![url isEqualToString:self.trail.cover]) {
            ImageContentView *contentView = [[NSBundle mainBundle] loadNibNamed:@"ImageContentView" owner:self options:nil][0];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLog(@"trail cover = %@",url);
            [contentView layoutImage:url];
            
            [self.trailImagesScrollView addSubview:contentView];
            [viewForTrailImagesArray addObject:contentView];
            urlToAppend = url;
        }
//        else if(!self.tempImage) {
//            ImageContentView *contentView = [[NSBundle mainBundle] loadNibNamed:@"ImageContentView" owner:self options:nil][0];
//            contentView.translatesAutoresizingMaskIntoConstraints = NO;
//            
//            NSLog(@"trail cover = %@",url);
//            [contentView layoutImage:url];
//            
//            [self.trailImagesScrollView addSubview:contentView];
//            [viewForTrailImagesArray setObject:contentView atIndexedSubscript:0];
//        }
//		
	}
    if (self.trail.covers.count > 1) {
        //Append first image for infinite scrolling
        ImageContentView *contentViewFirst = [[NSBundle mainBundle] loadNibNamed:@"ImageContentView" owner:self options:nil][0];
        contentViewFirst.translatesAutoresizingMaskIntoConstraints = NO;
        if (self.tempImageUrl && self.tempImageUrl.length > 0) {
            if (self.isOffline) {
                contentViewFirst.imageView.image = self.tempImage;
            } else {
                [contentViewFirst layoutImage:self.tempImageUrl];
            }
        } else {
            [contentViewFirst layoutImage:self.trail.cover];
        }
        
        [self.trailImagesScrollView addSubview:contentViewFirst];
        [viewForTrailImagesArray addObject:contentViewFirst];
        
            //Append last image for infinite scrolling
            ImageContentView *contentViewLast = [[NSBundle mainBundle] loadNibNamed:@"ImageContentView" owner:self options:nil][0];
            contentViewLast.translatesAutoresizingMaskIntoConstraints = NO;
            NSString *urlstrLast;
            if (urlToAppend.length > 0) {
                urlstrLast = urlToAppend;
            } else if (self.tempImageUrl && self.tempImageUrl.length > 0){
                urlstrLast = self.tempImageUrl;
            } else {
                urlstrLast = [self.trail.covers lastObject];
            }
            [contentViewLast layoutImage:urlstrLast];
            [self.trailImagesScrollView addSubview:contentViewLast];
            [viewForTrailImagesArray insertObject:contentViewLast atIndex:0];
            

    }
    
    
    
    [self layoutViewsForScrollView:self.trailImagesScrollView];
    if (self.trail.covers.count > 1) {
         self.trailImagesScrollView.contentOffset = CGPointMake(self.trailImagesScrollView.frame.size.width, 0);
    }
   
//	[self layoutViewsVertically];
}

- (void)layoutTempTrailGalleryView {
    [viewsForTrailImagesDict removeAllObjects];
    [viewForTrailImagesArray removeAllObjects];
    [self.trailImagesScrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [viewsForTrailImagesDict setObject:self.trailImagesScrollView forKey:@"parent"];
    ImageContentView *contentView = [[NSBundle mainBundle] loadNibNamed:@"ImageContentView" owner:self options:nil][0];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.tempImage) {
//        [contentView.imageView setImage:self.tempImage];
        [contentView.imageView setImageWithURL:[NSURL URLWithString:self.tempImageUrl] placeholderImage:self.tempImage];
        [self.trailImagesScrollView addSubview:contentView];
        [viewForTrailImagesArray addObject:contentView];
        [self layoutViewsForScrollView:self.trailImagesScrollView];
        [self updateViewConstraints];
    }
    else {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.trail.cover]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:60];
        [contentView.imageView setImageWithURLRequest:imageRequest
                              placeholderImage:[UIImage imageNamed:@"placeholderForTrail"]
                                       success:nil
                                       failure:nil];
        self.tempImage = contentView.imageView.image;
        [self.trailImagesScrollView addSubview:contentView];
        [viewForTrailImagesArray addObject:contentView];
        [self layoutViewsForScrollView:self.trailImagesScrollView];
        [self updateViewConstraints];

    }
}

- (void)layoutAccomodationGalleryView {
	[viewsForAccDict removeAllObjects];
	[viewForAccArray removeAllObjects];
    [self.accomodationImagesScrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
	[viewsForAccDict setObject:self.accomodationImagesScrollView forKey:@"parent"];
    
	for (int index = 0; index < self.trail.accomodations.accomodationsArray.count; index++) {
		Accomodation *acc = [self.trail.accomodations.accomodationsArray objectAtIndex:index];
		AccomodationContentView *contentView = [[NSBundle mainBundle] loadNibNamed:@"AccomodationContentView" owner:self options:nil][0];
		contentView.translatesAutoresizingMaskIntoConstraints = NO;

		[contentView updateWithAccomodation:acc];
		
		[self.accomodationImagesScrollView addSubview:contentView];
		[viewForAccArray addObject:contentView];
		
		contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        gesture.delegate = self;
		contentView.tag = index;
		[contentView addGestureRecognizer:gesture];
	}
    
    if (self.trail.accomodations.accomodationsArray.count > 1) {
        //Append first image for infinite scrolling
        AccomodationContentView *contentViewFirst = [[NSBundle mainBundle] loadNibNamed:@"AccomodationContentView" owner:self options:nil][0];
        contentViewFirst.translatesAutoresizingMaskIntoConstraints = NO;
        
        contentViewFirst.userInteractionEnabled = YES;
        contentViewFirst.tag = 0;
        UITapGestureRecognizer *gestureFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        gestureFirst.delegate = self;

        [contentViewFirst addGestureRecognizer:gestureFirst];

        
        Accomodation *accFirst  = (Accomodation *)[self.trail.accomodations.accomodationsArray firstObject];
        //[contentViewFirst layoutImage:accFirst.cover];
        [contentViewFirst updateWithAccomodation:accFirst];
        
        [self.accomodationImagesScrollView addSubview:contentViewFirst];
        [viewForAccArray addObject:contentViewFirst];
        
        //Append last image for infinite scrolling
        AccomodationContentView *contentViewLast = [[NSBundle mainBundle] loadNibNamed:@"AccomodationContentView" owner:self options:nil][0];
        contentViewLast.translatesAutoresizingMaskIntoConstraints = NO;
        
        contentViewLast.userInteractionEnabled = YES;
        contentViewLast.tag = self.trail.accomodations.accomodationsArray.count-1;
        UITapGestureRecognizer *gestureLast = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        gestureLast.delegate = self;
        [contentViewLast addGestureRecognizer:gestureLast];
        
        Accomodation *accLast  = (Accomodation *)[self.trail.accomodations.accomodationsArray lastObject];
        //[contentViewLast layoutImage:accLast.cover];
        [contentViewLast updateWithAccomodation:accLast];
        
        [self.accomodationImagesScrollView addSubview:contentViewLast];
        [viewForAccArray insertObject:contentViewLast atIndex:0];
        
        
    }
    
	[self layoutViewsForScrollView:self.accomodationImagesScrollView];
    
    if (self.trail.accomodations.accomodationsArray.count > 1) {
        self.accomodationImagesScrollView.contentOffset = CGPointMake(0, 0);
    }


}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
	Accomodation *acc = [self.trail.accomodations.accomodationsArray objectAtIndex:pinchGestureRecognizer.view.tag];
	AccomodationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccomodationViewController"];
	vc.accomodation = acc;
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)layoutViewsForScrollView:(UIScrollView *)scrollView {
    [scrollView removeConstraints:[scrollView constraints]];
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:scrollView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:scrollView
                                                      attribute: NSLayoutAttributeWidth
                                                     multiplier:2.0/3.0
                                                       constant:0.0f]];
	NSMutableString *horizontalString = [NSMutableString string];
	[horizontalString appendString:@"H:|"];
    if ([scrollView isEqual:self.trailImagesScrollView]) {
        for (int i = 0; i < viewForTrailImagesArray.count; i++) {
            [viewsForTrailImagesDict setObject:viewForTrailImagesArray[i] forKey:[NSString stringWithFormat:@"v%d",i]];
            NSString *verticalString = [NSString stringWithFormat:@"V:|[%@(==parent)]|", [NSString stringWithFormat:@"v%d",i]];
            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalString options:0 metrics:nil views:viewsForTrailImagesDict]];
            [horizontalString appendString:[NSString stringWithFormat:@"[%@(==parent)]", [NSString stringWithFormat:@"v%d",i]]];
        }
        // Close the string with the parent
        [horizontalString appendString:@"|"];
        // apply the constraint
        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalString options:0 metrics:nil views:viewsForTrailImagesDict]];

    } else if ([scrollView isEqual:self.accomodationImagesScrollView]) {
        for (int i = 0; i < viewForAccArray.count; i++) {
            [viewsForAccDict setObject:viewForAccArray[i] forKey:[NSString stringWithFormat:@"v%d",i]];
            NSString *verticalString = [NSString stringWithFormat:@"V:|[%@(==parent)]|", [NSString stringWithFormat:@"v%d",i]];
            [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalString options:0 metrics:nil views:viewsForAccDict]];
            if (self.trail.accomodations.accomodationsArray.count > 1) {
                [horizontalString appendString:[NSString stringWithFormat:@"[%@(%f)]", [NSString stringWithFormat:@"v%d",i], [UIScreen mainScreen].bounds.size.width-50.0]];
            } else {
                [horizontalString appendString:[NSString stringWithFormat:@"[%@(==parent)]", [NSString stringWithFormat:@"v%d",i]]];
            }
        }
        // Close the string with the parent
        [horizontalString appendString:@"|"];
        // apply the constraint
        [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalString options:0 metrics:nil views:viewsForAccDict]];
    }
}

//- (void)layoutViewsVertically {
//	NSMutableString *verticalString = [NSMutableString string];
//	[verticalString appendString:@"V:|"];
//	for (int i = 0; i < viewsArray.count; i++) {
//		[viewsDict setObject:viewsArray[i] forKey:[NSString stringWithFormat:@"v%d",i]];
//		NSString *horizontalString = [NSString stringWithFormat:@"H:|[%@(==parent)]|", [NSString stringWithFormat:@"v%d",i]];
//		[self.trailImagesScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalString options:0 metrics:nil views:viewsDict]];
//		[verticalString appendString:[NSString stringWithFormat:@"[%@(==parent)]", [NSString stringWithFormat:@"v%d",i]]];
//	}
//	// Close the string with the parent
//	[verticalString appendString:@"|"];
//	[self.trailImagesScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalString options:0 metrics:nil views:viewsDict]];
//}

- (IBAction)addTrailTipButtonPressed:(id)sender {
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
	
	AddTrailTipViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTrailTipViewController"];
	vc.trail = self.trail;
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
	if (!token) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"trailSavedStatusChangedNotification"
         object:self
         userInfo:[NSDictionary dictionaryWithObject:self.trail forKey:@"trail"]];
//		LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//		[self.navigationController pushViewController:vc animated:YES];
		return;
	}
	self.saveButton.selected = !self.saveButton.selected;
    self.mainSaveButton.selected = self.saveButton.selected;
    
    __weak typeof(self) weakSelf = self;
    
    
    if (!self.trail.isSaved) {
        [self.trail addTrailToSavedListWithCallback:^(id result,long long contentLength, NSError *error) {
            if (!error) {
                if(![result boolValue])
                {
                    
                    weakSelf.saveButton.selected = !weakSelf.saveButton.selected;
                    weakSelf.mainSaveButton.selected = weakSelf.saveButton.selected;
                    NSLog(@"ERROR: %@",[error description]);
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    alert.showAnimationType = SlideInFromTop;
                    alert.circleIconHeight = 30.0f;
                    [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
                }
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"trailSavedStatusChangedNotification"
                 object:weakSelf
                 userInfo:[NSDictionary dictionaryWithObject:weakSelf.trail forKey:@"trail"]];
            }
            else {
                weakSelf.saveButton.selected = !weakSelf.saveButton.selected;
                weakSelf.mainSaveButton.selected = weakSelf.saveButton.selected;
                NSLog(@"ERROR: %@",[error description]);
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
    } else {
        [self.trail removeTrailFromSavedListWithCallback:^(id result,long long contentLength, NSError *error) {
            if (!error) {
                if(![result boolValue])
                {
                    self.saveButton.selected = !self.saveButton.selected;
                    self.mainSaveButton.selected = self.saveButton.selected;
                    NSLog(@"ERROR: %@",[error description]);
                    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                    alert.showAnimationType = SlideInFromTop;
                    alert.circleIconHeight = 30.0f;
                    [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
                }
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"trailSavedStatusChangedNotification"
                 object:self
                 userInfo:[NSDictionary dictionaryWithObject:self.trail forKey:@"trail"]];
            }
            else {
                self.saveButton.selected = !self.saveButton.selected;
                self.mainSaveButton.selected = self.saveButton.selected;
                NSLog(@"ERROR: %@",[error description]);
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
	
}

- (IBAction)toggleOfflineButtonPressed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *trailsToShowTip = [defaults objectForKey:ktrailsToShowTip];
    if (!trailsToShowTip) {
        trailsToShowTip = [[NSArray alloc] init];
    }
    NSMutableArray *trailsToShowTipMutable = [[NSMutableArray alloc] init];
    if (self.offlineUsageSwitch.isOn) {
        CGPoint mapPoint = CGPointMake(self.mapView.frame.origin.x, ([UIDevice windowHeight]-self.mapView.frame.size.height)/2);
        [self.mainScrollView setContentOffset:mapPoint animated:YES];
        [UIView animateWithDuration:0.6f animations:^{
            self.tipView.alpha = 1.0;
        }];
        
        trailsToShowTipMutable = [trailsToShowTip mutableCopy];
        [trailsToShowTipMutable addObject:[NSString stringWithFormat:@"%ld", (long)self.trail.index]];
        trailsToShowTip = [trailsToShowTipMutable copy];
        
    } else {
        [UIView animateWithDuration:0.6f animations:^{
            self.tipView.alpha = 0;
        }];
        
        if (trailsToShowTip && [trailsToShowTip containsObject:[NSString stringWithFormat:@"%ld", (long)self.trail.index]]) {
            trailsToShowTipMutable = [trailsToShowTip mutableCopy];
            [trailsToShowTipMutable removeObject:[NSString stringWithFormat:@"%ld", (long)self.trail.index]];
            trailsToShowTip = [trailsToShowTipMutable copy];
        }
    }
    
    [defaults setObject:trailsToShowTip forKey:ktrailsToShowTip];
    [defaults synchronize];
    
}

- (IBAction)shareButtonPressed:(id)sender {
	NSString *shareString = self.trail.name;
///	UIImage *shareImage = [UIImage imageNamed:@"Smbataberd.jpg"];
	NSURL *shareUrl = [NSURL URLWithString:@"http://www.hikeArmenia.com"];
 
	NSArray *items = [NSArray arrayWithObjects:shareString,/* shareImage,*/ shareUrl, nil];
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
//		NSString *serviceMsg = nil;
//        serviceMsg = @"Shared successfully";
//		if ( [activityType isEqualToString:UIActivityTypeMail] ) {
//			serviceMsg = @"Mail sent!";
//		}
//		if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )  serviceMsg = @"Shared successfully on Twitter";
//		if ( [activityType isEqualToString:UIActivityTypePostToFacebook] ) serviceMsg = @"Shared successfully on Facebook";
//		
//		if ( completed )
//		{
//            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//            alert.showAnimationType = SlideInFromTop;
//            alert.circleIconHeight = 30.0f;
//            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"" subTitle:serviceMsg  closeButtonTitle:@"OK" duration:0.0f];
//		}
	}];
}

- (IBAction)takeAPhotoButtonPressed:(id)sender {
    TakePhotoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TakePhotoViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)findGuidesButtonPressed:(id)sender {
	UINavigationController *nc = self.navigationController;
	LocalGuidesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LocalGuidesViewController"];
    vc.guides = [[NSMutableArray alloc] initWithArray:self.trail.guides.guidesArray];
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
	
	TrailsViewController *vc = [[self.navigationController viewControllers] firstObject];
	vc.filterSavedTrails = !self.savedTrailsButtonState;
    [vc updateTrailsAnimated:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    if (!(self.lastContentOffset < self.mainScrollView.contentOffset.y) && self.mainScrollView.contentOffset.y> self.trailImagesScrollView.frame.size.height) {
        [UIView animateWithDuration:0.2 animations:^{
            self.trailNameLabel.hidden = NO;
            self.topBarView.hidden = NO;
            self.topBarView.alpha = 1.0;
        self.topBarView.backgroundColor = [UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:0.8f];
            }];

    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            self.trailNameLabel.hidden = YES;
            self.topBarView.alpha = 0;
        }];
    }
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        
        self.lastContentOffset = scrollView.contentOffset.y;
        
        
        
            CGRect frame = self.topBarView.frame;
            CGFloat size = frame.size.height;
            CGFloat framePercentageHidden = ((frame.origin.y) / (frame.size.height));
            CGFloat scrollOffset = scrollView.contentOffset.y;
            CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
            CGFloat scrollHeight = scrollView.frame.size.height;
            CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
            
            if (scrollOffset <= -scrollView.contentInset.top) {
                frame.origin.y = 0;
            } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
                frame.origin.y = -size;
            } else {
                frame.origin.y = MIN(0, MAX(-size, frame.origin.y - scrollDiff));
            }
            
            //[self.topBarView setFrame:frame];
            [self updateBarButtonItems:(1 - framePercentageHidden)];
            self.previousScrollViewYOffset = scrollOffset;
        
        self.trailNameLabelHeightConstraint.constant = 40.0;
        
    }
    else if(scrollView == self.accomodationImagesScrollView) {
        if (scrollView.contentOffset.x == scrollView.contentSize.width-scrollView.frame.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.frame.size.width-100.0, scrollView.contentOffset.y);
        }
        else if (scrollView.contentOffset.x == 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*(scrollView.frame.size.width-50.0), scrollView.contentOffset.y);
        }

	}
    else if(scrollView == self.trailImagesScrollView) {
        if (scrollView.contentOffset.x == scrollView.contentSize.width-scrollView.frame.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, scrollView.contentOffset.y);
        }
        else if (scrollView.contentOffset.x == 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*scrollView.frame.size.width, scrollView.contentOffset.y);
        }
        self.trailImagesPageControll.currentPage =(int)self.trailImagesScrollView.contentOffset.x/self.trailImagesScrollView.frame.size.width-1;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if([segue.identifier isEqualToString:@"TrailTipsEmbed"] || [segue.identifier isEqualToString:@"TrailReviews"]) {
		if([segue.identifier isEqualToString:@"TrailTipsEmbed"]) {
			self.trailTipsViewController = [segue destinationViewController];
			self.trailTipsViewController.trail = self.trail;
		}
		else {
			self.trailReviewsViewController = [segue destinationViewController];
			self.trailReviewsViewController.trail = self.trail;
		}
	}
	if([segue.identifier isEqualToString:@"GuidesEmbed"] || [segue.identifier isEqualToString:@"Guides"]) {
		self.localGuidesViewController = [segue destinationViewController];
		self.localGuidesViewController.filtered = YES;
        self.localGuidesViewController.trailId = self.trail.index;
        self.localGuidesViewController.trailName = self.trail.name;
		if([segue.identifier isEqualToString:@"GuidesEmbed"]) {
			self.localGuidesViewController.embedMode = YES;
		}
		else {
			self.localGuidesViewController.embedMode = NO;
		}
		self.localGuidesViewController.guides = self.trail.guides.guidesArray;
	}
    if(/*[segue.identifier isEqualToString:@"TrailMapEmbed"] || */[segue.identifier isEqualToString:@"TrailMap"]) {
        self.trailMapViewController = [segue destinationViewController];
        self.trailMapViewController.trail = self.trail;
//        if([segue.identifier isEqualToString:@"TrailMapEmbed"]) {
//            self.trailMapViewController.embed = YES;
//        }
//        else {
//            self.trailMapViewController.embed = NO;
//        }
    }
}

- (IBAction)mapImageTapped:(id)sender {
    MGLTrailMapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MGLTrailMapViewController"];
    //TrailMapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrailMapViewController"];
    vc.trail = self.trail;
    vc.isOffline = self.isOffline;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)fetchTrails {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrailMO"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"index == %d", self.trail.index]];
    NSError *error = nil;
    NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
    self.offlineTrail = [results firstObject];
    if (!results) {
        NSLog(@"Error fetching TrailMO objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    return results;
}

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
@end
