//
//  TrailViewCell.h
//  HikeArmenia
//
//  Created by Tigran Kirakosyan on 4/19/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrailMO.h"

@class Trail;

@protocol TrailViewCellDelegate <NSObject>
- (void)saveTrailWithIndex:(NSInteger)index;
@end

@interface TrailViewCell : UITableViewCell
@property (assign, nonatomic) id<TrailViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL isOffline;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

- (void)updateWithTrail:(Trail *)trail;
- (void)updateWithTrailMO:(TrailMO *)trail;
- (void)updateSavedState:(BOOL)option;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewCenterConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *trailImageOverlayView;

@end
