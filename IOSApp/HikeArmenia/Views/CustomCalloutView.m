//
//  CustomCalloutView.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 7/6/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "CustomCalloutView.h"

static CGFloat const tipHeight = 10.0;

@interface CustomCalloutView ()

@property (strong, nonatomic) UIButton *mainBody;
@property (strong, nonatomic) UILabel *markerTitleLabel;
@property (strong, nonatomic) UILabel *markerDescLabel;

@end

@implementation CustomCalloutView {
    id <MGLAnnotation> _representedObject;
    __unused UIView *_leftAccessoryView;/* unused */
    __unused UIView *_rightAccessoryView;/* unused */
    __weak id <MGLCalloutViewDelegate> _delegate;
}

@synthesize representedObject = _representedObject;
@synthesize leftAccessoryView = _leftAccessoryView;/* unused */
@synthesize rightAccessoryView = _rightAccessoryView;/* unused */
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

#pragma mark - MGLCalloutView API

- (void)presentCalloutFromRect:(CGRect)rect inView:(UIView *)view constrainedToView:(UIView *)constrainedView animated:(BOOL)animated
{
    if ([self.annotation.obj isKindOfClass:[Trail class]]) {
        Trail *trail = (Trail *)self.annotation.obj;
        
        [self configureCalloutForTrail:trail];
        
        [view addSubview:self];
        
        if ([self isCalloutTappable])
        {
            // Handle taps and eventually try to send them to the delegate (usually the map view)
            [self.mainBody addTarget:self action:@selector(calloutTapped) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            // Disable tapping and highlighting
            self.mainBody.userInteractionEnabled = NO;
        }
        
        // Prepare our frame, adding extra space at the bottom for the tip
        CGFloat frameWidth = self.mainBody.bounds.size.width;
        CGFloat frameHeight = self.mainBody.bounds.size.height;
        CGFloat frameOriginX = rect.origin.x-self.mainBody.frame.size.width/2.0;
        CGFloat frameOriginY = rect.origin.y +rect.size.height;
        self.frame = CGRectMake(frameOriginX, frameOriginY,
                                frameWidth, frameHeight);
    } else if ([self.annotation.obj isKindOfClass:[Accomodation class]]) {
        Accomodation *accomodation = (Accomodation *)self.annotation.obj;
        
        [self configureCalloutForAccomodation:accomodation];
        
        [view addSubview:self];
        
        self.mainBody.userInteractionEnabled = NO;
        
        // Prepare our frame, adding extra space at the bottom for the tip
        CGFloat frameWidth = self.mainBody.bounds.size.width;
        CGFloat frameHeight = self.mainBody.bounds.size.height;
        CGFloat frameOriginX = rect.origin.x-self.mainBody.frame.size.width/2.0+10.0;
        CGFloat frameOriginY = rect.origin.y +rect.size.height;
        self.frame = CGRectMake(frameOriginX, frameOriginY,
                                frameWidth, frameHeight);
    }
    

    
    
    
    
    if (animated)
    {
        self.alpha = 0.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1.0;
        }];
    }
}

- (void)configureCalloutForTrail:(Trail *)trail {
    
    UIView *customInfoWindow = [[UIView alloc] init];
    customInfoWindow.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:117.0f/255.0 blue:5.0f/255.0 alpha:1.0f];
    self.markerTitleLabel = [[UILabel alloc] init];
    self.markerTitleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:14.0];
    self.markerTitleLabel.textColor = [UIColor whiteColor];
    self.markerTitleLabel.text = trail.name;
    self.markerTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    self.markerDescLabel = [[UILabel alloc] init];
    self.markerDescLabel.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:12.0];
    self.markerDescLabel.textColor = [UIColor whiteColor];
    self.markerDescLabel.text = [NSString stringWithFormat:@"%@  /  %@  /  %@", trail.difficultly, trail.distance, trail.duraion];
    self.markerDescLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [customInfoWindow addSubview:self.markerTitleLabel];
    [customInfoWindow addSubview:self.markerDescLabel];
    [customInfoWindow addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:self.markerTitleLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:5.0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.markerTitleLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:10.0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.markerTitleLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.markerDescLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:-2.0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.markerTitleLabel
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1
                                                                     constant:-10.0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.markerDescLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:10.0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.markerDescLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-5.0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.markerDescLabel
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1
                                                                     constant:-10.0]
                                       ]];
    [customInfoWindow setFrame:CGRectMake(0,
                                          0,
                                          MAX(self.markerTitleLabel.intrinsicContentSize.width + 20.0, self.markerDescLabel.intrinsicContentSize.width + 20.0) ,
                                          self.markerTitleLabel.intrinsicContentSize.height+self.markerDescLabel.intrinsicContentSize.height+10.0)];
    customInfoWindow.layer.cornerRadius = customInfoWindow.frame.size.height/2;
    
    self.mainBody = [[UIButton alloc] initWithFrame:customInfoWindow.frame];
    [customInfoWindow addSubview:self.mainBody];
    [self addSubview:customInfoWindow];
}

- (void)configureCalloutForAccomodation:(Accomodation *)accomodation {
    
    UIView *customInfoWindow = [[UIView alloc] init];
    customInfoWindow.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:117.0f/255.0 blue:5.0f/255.0 alpha:1.0f];
    self.markerTitleLabel = [[UILabel alloc] init];
    self.markerTitleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:14.0];
    self.markerTitleLabel.textColor = [UIColor whiteColor];
    self.markerTitleLabel.text = accomodation.name;
    self.markerTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [customInfoWindow addSubview:self.markerTitleLabel];
    [customInfoWindow addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:self.markerTitleLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:5.0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.markerTitleLabel
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:10.0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.markerTitleLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-5.0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.markerTitleLabel
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:customInfoWindow
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1
                                                                     constant:-10.0],
                                       
                                            ]];
    [customInfoWindow setFrame:CGRectMake(0,
                                          0,
                                          self.markerTitleLabel.intrinsicContentSize.width + 20.0,
                                          self.markerTitleLabel.intrinsicContentSize.height+10.0)];
    customInfoWindow.layer.cornerRadius = customInfoWindow.frame.size.height/2;
    
    self.mainBody = [[UIButton alloc] initWithFrame:customInfoWindow.frame];
    [customInfoWindow addSubview:self.mainBody];
    [self addSubview:customInfoWindow];
}


- (void)dismissCalloutAnimated:(BOOL)animated
{
    if (self.superview)
    {
        if (animated)
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
        else
        {
            [self removeFromSuperview];
        }
    }
}

#pragma mark - Callout interaction handlers

- (BOOL)isCalloutTappable
{
    return YES;
}

- (void)calloutTapped
{
    if ([self isCalloutTappable] && [self.delegate respondsToSelector:@selector(calloutViewTapped:)])
    {
        [self.delegate performSelector:@selector(calloutViewTapped:) withObject:self];
    }
}

#pragma mark - Custom view styling

- (UIColor *)backgroundColorForCallout
{
    return [UIColor darkGrayColor];
}

- (void)drawRect:(CGRect)rect
{
    // Draw the pointed tip at the bottom
    UIColor *fillColor = [self backgroundColorForCallout];
    
    CGFloat tipLeft = rect.origin.x;
    CGPoint tipBottom = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    CGFloat heightWithoutTip = rect.size.height - tipHeight;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef tipPath = CGPathCreateMutable();
    CGPathMoveToPoint(tipPath, NULL, tipLeft, heightWithoutTip);
    CGPathAddLineToPoint(tipPath, NULL, tipBottom.x, tipBottom.y);
    CGPathAddLineToPoint(tipPath, NULL, tipLeft, heightWithoutTip);
    CGPathCloseSubpath(tipPath);
    
    [fillColor setFill];
    CGContextAddPath(currentContext, tipPath);
    CGContextFillPath(currentContext);
    CGPathRelease(tipPath);
}

@end
