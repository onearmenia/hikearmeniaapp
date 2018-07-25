//
//  TrailsViewController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/8/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "TrailsViewController.h"
#import "LocalGuidesViewController.h"
#import "HANavigationController.h"
#import "Definitions.h"
#import "AppDelegate.h"
#import "Trails.h"
#import "Trail.h"
#import "TrailDetailViewController.h"
#import "LoginViewController.h"
#import "UIImage+ImageWithColor.h"
#import "CustomIndicatorLoadingView.h"
#import "SCLAlertView.h"
#import "CompassViewController.h"
#import "MGLMapViewController.h"
#import "UIView+Additions.h"
#import "TakePhotoViewController.h"
#import "TrailMO.h"
#import "UIImageView+AFNetworking.h"

@interface TrailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *savedTrailsButton;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) NSArray *savedTrails;
@property (strong, nonatomic) NSMutableArray *trails;
@property (strong, nonatomic) NSArray *visibleTrails;
@property (strong, nonatomic) NSArray *tmpTrailList;
@property (weak, nonatomic) IBOutlet UIButton *toolbarSavedTrailsButton;
@property (assign, nonatomic) CGPoint trailsContentOffset;
@property (assign, nonatomic) UINavigationControllerOperation navigationControllerOperation;
@property (strong, nonatomic) NSIndexPath *activeIndexPath;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property(strong, nonatomic) Trail *trailPendingToSave;

@property(strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TrailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTrailSavedStatusChangedNotification:)
                                                 name:@"trailSavedStatusChangedNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveTrailWithIndex:)
                                                 name:@"userLoggedIn"
                                               object:nil];
    
    
	self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

	_trails = [[NSMutableArray alloc] init];
    _visibleTrails = [[NSMutableArray alloc] init];
    if (!self.filterSavedTrails) {
        [self reloadTrails];
    }
    
    //self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBg"]];
    self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBackground"]];
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.table addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(reloadTrails) forControlEvents:UIControlEventValueChanged];
}

- (void) receiveTrailSavedStatusChangedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"trailSavedStatusChangedNotification"]) {
        Trail *trail = [notification.userInfo objectForKey:@"trail"];
        [self saveTrailWithIndex:trail.index];
        //[self reloadTrails];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureNavBar];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.filterSavedTrails) {
        self.screenName = @"Favorite Trails";
    } else {
        self.screenName = @"Trails";
    }
	[super viewWillAppear:animated];
    self.toolbarHeightConstraint.constant = 54.0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {}];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    
    [self configureNavBar];
    if (self.filterSavedTrails) {
        self.visibleTrails = self.savedTrails;
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"stackForToolbar"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"All Trails" forState:UIControlStateNormal];
        if (self.savedTrails.count == 0) {
            self.infoView.hidden = NO;
        }
    } else {
        self.visibleTrails = self.trails;
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"savedtrails"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"Favorite Trails" forState:UIControlStateNormal];
    }
    self.navigationController.delegate = self;
}

- (void)configureNavBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    if (self.filterSavedTrails) {
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.toolbarHeightConstraint.constant = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTrails {
	self.infoView.hidden = YES;
	if(self.filterSavedTrails) {
		self.navigationItem.title = @"Favorite Trails";
		UILabel *titleLabel = [UILabel new];
		NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
		titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
		[titleLabel sizeToFit];
		self.navigationItem.titleView = titleLabel;
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"stackForToolbar"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"All Trails" forState:UIControlStateNormal];
	}
	else {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_icon"]];
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"savedtrails"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"Favorite Trails" forState:UIControlStateNormal];
	}

    if (![self.refreshControl isRefreshing]) {
        [CustomIndicatorLoadingView showIndicator];
    }
	
	
	[Trails loadTrailsWithCallback:^(id result,long long contentLength, NSError *error) {
		if (!error) {
			Trails *trailList = result;
			if(trailList.trailsArray.count != 0) {
				[self.trails setArray:trailList.trailsArray];
                
				NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSaved == YES"];
				self.savedTrails = [self.trails filteredArrayUsingPredicate:predicate];
                if(self.filterSavedTrails) {
                    self.visibleTrails = self.savedTrails;
                    if(self.savedTrails.count == 0) {
                        self.infoView.hidden = NO;
                    }
                    else {
                        self.infoView.hidden = YES;
                    }
                } else {
                    self.infoView.hidden = YES;
                    self.visibleTrails = self.trails;
                }
                [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
			}
		}
		else {
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
        if (![self.refreshControl isRefreshing]) {
            [CustomIndicatorLoadingView hideIndicator];
        } else {
           [self.refreshControl endRefreshing];
        }
        
	}];
}

- (void)updateOfflineTrail:(Trail *)trail withCover:(UIImage *)cover{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrailMO"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"index == %d", trail.index]];
    NSError *error = nil;
    NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
    if (results.count > 0) {
        TrailMO *trailMO = [results firstObject];
        trailMO.name = trail.name;
        trailMO.reviewCount = [NSNumber numberWithInteger:trail.reviewCount];
        trailMO.averageRating = trail.averageRating;
        trailMO.difficultly = trail.difficultly;
        trailMO.distance = trail.distance;
        trailMO.duraion = trail.duraion;
        trailMO.cover = trail.cover;
        
        NSError *error = nil;
        if ([[[self class] managedObjectContext] save:&error] == NO) {
            NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
        }

    }
    if (!results) {
        NSLog(@"Error fetching TrailMO objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }

}

- (void)updateTrailsAnimated:(BOOL)animated {
    if (animated) {
        if (self.filterSavedTrails) {
            self.visibleTrails = self.savedTrails;
            [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"stackForToolbar"] forState:UIControlStateNormal];
            [self.toolbarSavedTrailsButton setTitle:@"All Trails" forState:UIControlStateNormal];
            if (self.savedTrails.count == 0) {
                self.infoView.hidden = NO;
            }
            self.navigationItem.title = @"Favorite Trails";
            
        } else {
            self.visibleTrails = self.trails;
            [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"savedtrails"] forState:UIControlStateNormal];
            [self.toolbarSavedTrailsButton setTitle:@"Favorite Trails" forState:UIControlStateNormal];
            self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_icon"]];
        }

        [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void)menuButtonPressed:(id)sender {
	[HIKE_APP.homeController menuAction];
}

- (void)mapButtonPressed:(id)sender {
	//MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    MGLMapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MGLMapViewController"];
	[UIView transitionWithView:self.navigationController.view
					  duration:0.7
					   options:UIViewAnimationOptionTransitionFlipFromRight
					animations:^{
						vc.trails = self.filterSavedTrails ? self.savedTrails : self.trails;
						vc.showSavedTrails = self.filterSavedTrails;
						[self.navigationController pushViewController:vc animated:NO];
					}
					completion:^(BOOL finished){
					}];
}

- (IBAction)takePhotoButtonPressed:(id)sender {
    TakePhotoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TakePhotoViewController"];
    [self presentViewController:vc animated:NO completion:nil];
    //[vc view];
    //[self.navigationController presentViewController:vc animated:YES completion:nil];
    //[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)findGuidesButtonPressed:(id)sender {
	LocalGuidesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LocalGuidesViewController"];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)savedTrailsButtonPressed:(id)sender {
    self.filterSavedTrails = !self.filterSavedTrails;
    
    if (self.filterSavedTrails) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
        if (!token) {
            self.filterSavedTrails = !self.filterSavedTrails;
            LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSaved == YES"];
        self.savedTrails = [self.trails filteredArrayUsingPredicate:predicate];
        self.visibleTrails = self.savedTrails;
        
        if(self.visibleTrails.count == 0) {
            self.infoView.hidden = NO;
        }
        if (![self.savedTrails isEqualToArray: self.trails]) {
            [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        self.navigationItem.title = @"Favorite Trails";
        UILabel *titleLabel = [UILabel new];
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
        [titleLabel sizeToFit];
        [self.navigationController.navigationBar.topItem setTitleView:titleLabel];
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"stackForToolbar"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"All Trails" forState:UIControlStateNormal];
    }
	

    else {
        self.infoView.hidden = YES;
        self.visibleTrails = self.trails;
        if (![self.savedTrails isEqualToArray: self.trails]) {
            [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_icon"]];
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"savedtrails"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"Favorite Trails" forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.visibleTrails.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 270;
    }
	return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Trail *trail = [self.visibleTrails objectAtIndex:indexPath.row];
	TrailViewCell *cell = (TrailViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TrailViewCell"];
    //cell.imageViewCenterConstraint.constant = -14.0;
    
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:trail.cover]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [cell.thumbImageView setImageWithURLRequest:imageRequest
                               placeholderImage:[UIImage imageNamed:@"placeholderForTrail"]
                                        success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                            [CustomIndicatorLoadingView hideIndicator];
                                            cell.thumbImageView.image = image;
                                            [self updateOfflineTrail:trail withCover:image];
                                        }
                                        failure:nil];

    
 //   [cell.thumbImageView setImageWithURL:[NSURL URLWithString:trail.cover] placeholderImage:[UIImage imageNamed:@"placeholderForTrail"]];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
	[cell setSelectedBackgroundView:bgColorView];
	    
	cell.delegate = self;
	[cell updateWithTrail:trail];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.activeIndexPath = indexPath;
    Trail *trail = [self.visibleTrails objectAtIndex:indexPath.row];
	TrailDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrailDetailViewController"];
	vc.trail = trail;
    vc.tempImageUrl = trail.cover;
    TrailViewCell *currentCell = [self.table cellForRowAtIndexPath:indexPath];
    
    vc.tempImage = currentCell.thumbImageView.image;
    vc.savedTrailsButtonState = self.filterSavedTrails;
	[self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - TrailViewCellDelegate

- (void)saveTrailWithIndex:(NSInteger)index {
    NSUInteger ind = [self.trails indexOfObjectPassingTest:
                      ^BOOL(Trail *object, NSUInteger idx, BOOL *stop)
                      {
                          return (object.index == index);
                      }
                      ];
    
    
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:ksessionAuthKey];
    if(ind != NSNotFound) {
        self.trailPendingToSave = [self.trails objectAtIndex:ind];
        //self.trailPendingToSave.isSaved = !self.trailPendingToSave.isSaved;
    }

	if (!token) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.horizontalButtons = YES;
        alert.showAnimationType = SlideInFromTop;
        alert.circleIconHeight = 30.0f;
        [alert addButton:@"OK" actionBlock:^() {
            LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:vc animated:YES];

        }];
        [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"" subTitle:@"Oops! In order to save this trail to your favourites, you must be logged in."  closeButtonTitle:@"Cancel" duration:0.0f];
        
        return;
	}
	
    Trail *trail = [[Trail alloc] init];
	if(ind != NSNotFound) {
		trail = [self.trails objectAtIndex:ind];
    } else if(self.trailPendingToSave) {
        //self.trailPendingToSave.isSaved = YES;
        trail = self.trailPendingToSave;
        //trail.isSaved = YES;
    } else {
        return;
    }
    if (!trail.isSaved) {
        [trail addTrailToSavedListWithCallback:^(id result,long long contentLength, NSError *error) {
            [self trailAtIndex:ind AddedOrRemovedFromSavedListCallback:result withContentLength:contentLength withError:error];
        }];
    } else {
        [trail removeTrailFromSavedListWithCallback:^(id result,long long contentLength, NSError *error) {
           [self trailAtIndex:ind AddedOrRemovedFromSavedListCallback:result withContentLength:contentLength withError:error];
        }];

    }
    
    if(self.filterSavedTrails) {
        self.tmpTrailList = nil;
        self.tmpTrailList = [[NSArray alloc] initWithArray:self.trails copyItems:YES];
    }
    [self updateSavedTrail:ind];
}

- (void)trailAtIndex:(NSUInteger)ind AddedOrRemovedFromSavedListCallback:(id)result withContentLength:(long)contentLength withError:(NSError *)error {
    if (!error) {
        if([result boolValue])
        {
        }
        else {
            NSLog(@"ERROR: %@",[error description]);
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.showAnimationType = SlideInFromTop;
            alert.circleIconHeight = 30.0f;
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
            if(!self.filterSavedTrails) {
                [self updateSavedTrail:ind];
            }
            else {
                [self.trails setArray:self.tmpTrailList];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSaved == YES"];
                self.savedTrails = [self.trails filteredArrayUsingPredicate:predicate];
                
                if(self.savedTrails.count == 0) {
                    self.infoView.hidden = NO;
                }
                else {
                    self.infoView.hidden = YES;
                }
                
                //[self.table reloadData];
                [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    else {
        NSLog(@"ERROR: %@",[error description]);
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.showAnimationType = SlideInFromTop;
        alert.circleIconHeight = 30.0f;
        if (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNotConnectedToInternet) {
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:@"The internet connection appears to be offline"  closeButtonTitle:@"OK" duration:0.0f];
        } else {
            [alert showCustom:[UIImage imageNamed:@"popupIcon"] color:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0/255.0 alpha:1] title:@"Error" subTitle:[error localizedDescription]  closeButtonTitle:@"OK" duration:0.0f];
        }

        if(!self.filterSavedTrails) {
            [self updateSavedTrail:ind];
        }
        else {
            [self.trails setArray:self.tmpTrailList];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSaved == YES"];
            self.savedTrails = [self.trails filteredArrayUsingPredicate:predicate];
            
            if(self.savedTrails.count == 0) {
                self.infoView.hidden = NO;
            }
            else {
                self.infoView.hidden = YES;
            }
            
            //[self.table reloadData];
            [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)updateSavedTrail:(NSUInteger)index {
	self.infoView.hidden = YES;
    Trail *tr = [[Trail alloc] init];
    if (index != NSNotFound) {
        tr = [self.trails objectAtIndex:index];
        tr.isSaved = !tr.isSaved;
    } else {
        tr = self.trailPendingToSave;
        tr.isSaved = YES;
    }
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
	TrailViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
	[cell updateSavedState:tr.isSaved];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSaved == YES"];
	self.savedTrails = [self.trails filteredArrayUsingPredicate:predicate];
    
	if(self.filterSavedTrails) {
		self.visibleTrails = self.savedTrails;
        [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
		if(self.savedTrails.count == 0) {
			self.infoView.hidden = NO;
		}
	}
}

- (void)changeTrailSavedState {
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.table) {
        NSArray *visibleCells = [self.table visibleCells];
        CGFloat limit = 25.0f;
        CGFloat diffAmount = 0.2f;
        for (TrailViewCell *cell in visibleCells) {
            if (scrollView.contentOffset.y > self.trailsContentOffset.y) {
                cell.imageViewCenterConstraint.constant = cell.imageViewCenterConstraint.constant < limit ? cell.imageViewCenterConstraint.constant + diffAmount : limit;
            }
            else {
                cell.imageViewCenterConstraint.constant = cell.imageViewCenterConstraint.constant > -limit ? cell.imageViewCenterConstraint.constant - diffAmount : -limit;
            }
                   }
        self.trailsContentOffset = scrollView.contentOffset;
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    self.navigationControllerOperation = operation;
    BOOL useDefault = YES;
    if (operation == UINavigationControllerOperationPush && [fromVC isKindOfClass:[TrailsViewController class]] && [toVC isKindOfClass:[TrailDetailViewController class]]) {
        useDefault = NO;
    } else if (operation == UINavigationControllerOperationPop && [toVC isKindOfClass:[TrailsViewController class]] && [fromVC isKindOfClass:[TrailDetailViewController class]] && self.transitionNotUseDefault){
        useDefault = NO;
        self.transitionNotUseDefault = NO;
    }

    return useDefault ? nil : self;
}


#pragma mark - UIViewControllerAnimatedTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contextView = [transitionContext containerView];
    fromVC.view.alpha = 1.0f;
    toVC.view.alpha = 1.0f;
    if (self.navigationControllerOperation == UINavigationControllerOperationPush) {
        [contextView insertSubview:toVC.view aboveSubview:fromVC.view];
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        if ([fromVC isKindOfClass:[TrailsViewController class]] && [fromVC respondsToSelector:@selector(transitionContextView)] && [fromVC respondsToSelector:@selector(transitionContextViewFrame)]) {
            toVC.view.frame = [[(TrailsViewController *)fromVC transitionContextView] convertRect:[(TrailsViewController *)fromVC transitionContextViewFrame] toView:contextView];
        }
        toVC.view.clipsToBounds = YES;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toVC.view.frame = finalFrame;
        } completion:^(BOOL finished) {
            toVC.view.clipsToBounds = NO;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else {
        [contextView insertSubview:toVC.view belowSubview:fromVC.view];
        CGRect finalFrame = [transitionContext initialFrameForViewController:fromVC];
        if ([toVC isKindOfClass:[TrailsViewController class]] && [toVC respondsToSelector:@selector(transitionContextView)] && [toVC respondsToSelector:@selector(transitionContextViewFrame)]) {
            finalFrame = [[(TrailsViewController *)toVC transitionContextView] convertRect:[(TrailsViewController *)toVC transitionContextViewFrame] toView:contextView];
        }
        fromVC.view.clipsToBounds = YES;
        fromVC.view.frame = [transitionContext initialFrameForViewController:fromVC];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] * 0.9f animations:^{
            fromVC.view.frame = finalFrame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] * 0.5f animations:^{
                fromVC.view.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }];
    }

}

- (void)animationEnded:(BOOL) transitionCompleted {
}




- (UIView *)transitionContextView {
    return self.table;
}

- (CGRect)transitionContextViewFrame {
    if (!self.activeIndexPath) {
        self.activeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return [self.table rectForRowAtIndexPath:self.activeIndexPath];
}




#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
