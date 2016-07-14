//
//  CRRefreshDefaultAniamation.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/12/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRRefreshDefaultAnimation.h"

// defaults
static const CGSize  kAnimationViewDefaultSize = {32.0f, 32.0f};
static const CGFloat kAnimationDefaultReloadOffset = 70.0f;

// default indicator
static const NSUInteger kDefaultInstanceCount = 12;
static const CGSize kDefaultDashSize    = {2,8};
static const NSTimeInterval kDefaultDashAnimationDuration = 0.8;



// CAAnimation keyPath
static NSString * const kAnimationRotationZPath = @"transform.rotation.z";


@interface CRRefreshDefaultAnimation ()
@property (weak, nonatomic) UIView *viewForAnimation;

@property (strong, nonatomic) CAReplicatorLayer *replicator;
@property (weak, nonatomic) CALayer *dash;

@end



@implementation CRRefreshDefaultAnimation



#pragma mark - setters && getters 

- (void)setInstanceCount:(NSUInteger)instanceCount {
    _instanceCount = instanceCount;
    
    self.replicator.instanceCount = instanceCount;
    self.replicator.instanceDelay = ( self.dashAnimationDuration / instanceCount );
}

- (void)setDashAnimationDuration:(NSTimeInterval)dashAnimationDuration {
    _dashAnimationDuration = dashAnimationDuration;
    
    self.replicator.instanceDelay = ( dashAnimationDuration / self.instanceCount );
}



#pragma mark - Public Methods

+ (instancetype)animation {
    return [[CRRefreshDefaultAnimation alloc] initPrivate];
}



#pragma mark - Preparing Animation lifecycle

- (UIView *)sceneForAnimation{
    CGRect frame = CGRectZero;
    frame.size = kAnimationViewDefaultSize;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    [view.layer addSublayer:_replicator];
    
    // taking weak reference to a view
    self.viewForAnimation = view;
    
    return view;
}

- (void)setAnimationToDefaultState {
    _viewForAnimation.alpha = 0.0f;
}

- (CGFloat)offsetForReload {
    return kAnimationDefaultReloadOffset;
}

- (void)animationViewWillHideWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration
                     animations:^{
                         self.dash.opacity = 1.0;
                     }];
}



#pragma mark - Animation lifecycle

- (void)setStretchPercent:(CGFloat)percent{
    _viewForAnimation.alpha = percent;
    _replicator.instanceCount = (NSInteger)(self.instanceCount * percent);
}

- (void)setUpAnimations {
    
    self.dash.opacity = 0.1;
    
    // creating main animation
    CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    dashAnimation.fromValue = @(1);
    dashAnimation.toValue   = @(0.1);
    
    dashAnimation.fillMode  = kCAFillModeForwards;
    dashAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    dashAnimation.removedOnCompletion = false;

    dashAnimation.repeatCount = INFINITY;
    dashAnimation.duration = self.dashAnimationDuration;
    
    [self.dash addAnimation:dashAnimation forKey:@"opacityAnimation"];
    
    CABasicAnimation *replicatorAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    replicatorAnimation.fromValue   = @(0);
    replicatorAnimation.toValue     = @(2 * M_PI_2);
    
    replicatorAnimation.fillMode  = kCAFillModeForwards;
    dashAnimation.removedOnCompletion = false;
    
    replicatorAnimation.repeatCount = INFINITY;
    replicatorAnimation.duration    = kDefaultDashAnimationDuration * 4;
    
    [self.replicator addAnimation:replicatorAnimation forKey:@"rotateAnimation"];
    
}

- (void)removeAnimations {
    [_viewForAnimation.layer removeAllAnimations];
    
    [_replicator removeAllAnimations];
    [_dash removeAllAnimations];
}



#pragma mark - Private Methods

- (instancetype) initPrivate {
    
    if ( self = [super init] ) {
        
        // init defaults
        _instanceCount = kDefaultInstanceCount;
        _dashAnimationDuration = kDefaultDashAnimationDuration;
        
        // prepare variables
        CGRect replicatorFrame = CGRectZero;
        replicatorFrame.size = kAnimationViewDefaultSize;
        
        CGRect dashFrame = CGRectZero;
        dashFrame.size = kDefaultDashSize;
        
        const CGFloat angleRotate = 2 * M_PI / (_instanceCount );
        
        
        // creating layers
        _replicator = [CAReplicatorLayer layer];
        _replicator.frame = replicatorFrame;
        
        
        _replicator.instanceCount = self.instanceCount;
        _replicator.instanceDelay = (_dashAnimationDuration / _instanceCount);
        _replicator.instanceTransform = CATransform3DMakeRotation(angleRotate, 0, 0, 1);
        
        CGPoint dashPosition = _replicator.position;
        dashPosition.y -= 6 + (dashFrame.size.height / 2);
        
        CALayer *dashLayer = [CALayer layer];
        dashLayer.frame = dashFrame;
        dashLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
        dashLayer.position = dashPosition;
        dashLayer.cornerRadius = 1;
        
        [_replicator addSublayer:dashLayer];
        _dash = dashLayer;
        
    }
    
    return self;
}


@end







