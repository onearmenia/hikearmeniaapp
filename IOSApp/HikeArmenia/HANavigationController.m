//
//  HANavigationController.m
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/7/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "HANavigationController.h"

@interface HANavigationController ()

@end

@implementation HANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 __weak HANavigationController *weakSelf = self;
	
	if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
	{
		self.interactivePopGestureRecognizer.delegate = weakSelf;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return ![otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]/* && ![otherGestureRecognizer isKindOfClass:UISwipeGestureRecognizer.class]*/;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//	if (self.viewControllers.count > 1) {
//		return YES;
//	}
//	return NO;
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
}

@end
