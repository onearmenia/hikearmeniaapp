//
//  OfflineTrailsViewController.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/9/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "OfflineTrailsViewController.h"
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

@interface OfflineTrailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *savedTrailsButton;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *toolbarSavedTrailsButton;
@property (assign, nonatomic) CGPoint trailsContentOffset;
@property (assign, nonatomic) UINavigationControllerOperation navigationControllerOperation;
@property (strong, nonatomic) NSIndexPath *activeIndexPath;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation OfflineTrailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    //self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBg"]];
    self.table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholderBackground"]];
    
    [self initializeFetchedResultsController];
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
    self.screenName = @"Offline Trails";
    [super viewWillAppear:animated];
    self.toolbarHeightConstraint.constant = 54.0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion: ^(BOOL finished) {}];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    
    [self configureNavBar];

    [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"savedtrails"] forState:UIControlStateNormal];
    [self.toolbarSavedTrailsButton setTitle:@"Favorite Trails" forState:UIControlStateNormal];
    self.navigationController.delegate = self;
    
    id< NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][0];
    if (!([sectionInfo numberOfObjects] > 0)) {
        self.infoView.hidden = NO;
    } else {
        self.infoView.hidden = YES;
    }
    
    if (self.savedTrailsButtonState) {
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"stackForToolbar"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"All Trails" forState:UIControlStateNormal];
    } else {
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"savedtrails"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"Favorite Trails" forState:UIControlStateNormal];
    }

}

- (void)configureNavBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Map_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
    self.navigationItem.title = @"Offline Trails";
    UILabel *titleLabel = [UILabel new];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:122.0/255.0 green:160.0/255.0 blue:0.0 alpha:1.0], NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:15.0f], NSKernAttributeName: @2.8};
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.navigationItem.title attributes:attributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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


- (void)updateTrailsAnimated:(BOOL)animated {
    if (animated) {
        
        [self.toolbarSavedTrailsButton setImage:[UIImage imageNamed:@"savedtrails"] forState:UIControlStateNormal];
        [self.toolbarSavedTrailsButton setTitle:@"Favorite Trails" forState:UIControlStateNormal];
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Home_icon"]];
        
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
    vc.isOffline = YES;
    vc.offlineTrailsViewController = self;
    [UIView transitionWithView:self.navigationController.view
                      duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                        vc.trails = [[self fetchedResultsController] fetchedObjects];
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id< NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 270;
    }
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrailMO *trail = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    TrailViewCell *cell = (TrailViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TrailViewCell"];
    cell.isOffline = YES;
    //cell.imageViewCenterConstraint.constant = -14.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    [cell updateWithTrailMO:trail];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.activeIndexPath = indexPath;
    TrailMO *trailMO = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    Trail *trail = [trailMO trailMOtoTrail];
    TrailDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TrailDetailViewController"];
    vc.trail = trail;
    vc.tempImageUrl = trail.cover;
    vc.isOffline = YES;
    TrailViewCell *currentCell = [self.table cellForRowAtIndexPath:indexPath];
    
    vc.tempImage = currentCell.thumbImageView.image;
    [self.navigationController pushViewController:vc animated:YES];
    
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
    if (operation == UINavigationControllerOperationPush && [fromVC isKindOfClass:[OfflineTrailsViewController class]] && [toVC isKindOfClass:[TrailDetailViewController class]]) {
        useDefault = NO;
    }
    else if (operation == UINavigationControllerOperationPop && [toVC isKindOfClass:[OfflineTrailsViewController class]] && [fromVC isKindOfClass:[TrailDetailViewController class]] && self.transitionNotUseDefault){
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
        if ([fromVC isKindOfClass:[OfflineTrailsViewController class]] && [fromVC respondsToSelector:@selector(transitionContextView)] && [fromVC respondsToSelector:@selector(transitionContextViewFrame)]) {
            toVC.view.frame = [[(OfflineTrailsViewController *)fromVC transitionContextView] convertRect:[(OfflineTrailsViewController *)fromVC transitionContextViewFrame] toView:contextView];
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
        if ([toVC isKindOfClass:[OfflineTrailsViewController class]] && [toVC respondsToSelector:@selector(transitionContextView)] && [toVC respondsToSelector:@selector(transitionContextViewFrame)]) {
            finalFrame = [[(OfflineTrailsViewController *)toVC transitionContextView] convertRect:[(OfflineTrailsViewController *)toVC transitionContextViewFrame] toView:contextView];
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


+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TrailMO"];
    [request setSortDescriptors:[[NSArray alloc] init]];
    
    NSManagedObjectContext *moc = [[self class] managedObjectContext]; //Retrieve the main queue NSManagedObjectContext
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self table] beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self table] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self table] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self table] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self table] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.table reloadData];
            break;
        case NSFetchedResultsChangeMove:
            [[self table] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self table] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self table] endUpdates];
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
