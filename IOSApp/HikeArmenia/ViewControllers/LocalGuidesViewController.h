//
//  LocalGuidesViewController.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/8/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideViewCell.h"
#import <MessageUI/MessageUI.h>
#import "GAITrackedViewController.h"

@interface LocalGuidesViewController : GAITrackedViewController <GuideViewCellDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) NSMutableArray *guides;
@property(assign, nonatomic) BOOL filtered;
@property(assign, nonatomic) BOOL embedMode;
@property(assign, nonatomic) NSInteger trailId;
@property(strong, nonatomic) NSString *trailName;

- (void)updateGuides;

@end
