//
//  CRPullToRefresh.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 5/10/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//



#import "CRPullToRefresh.h"
#import "CRRefreshView.h"
#import "CRRefreshAnimationFactory.h"
#import "CRRefreshControlCore_Protected.h"

@interface CRPullToRefresh ()

@property (assign, nonatomic) BOOL scrollInsetsAdded;

/// indicate of changing scrollView layout
@property (assign, nonatomic) CGRect previousScrollViewFrame;
@property (assign, nonatomic) CGSize previousScrollViewContentSize;

@property (assign, nonatomic, readonly) CGFloat correctBottomPosition;


@end



@interface CRPullToRefresh (WorkWithKVO)

- (CGFloat)offsetForHandleBottomAnimation;
- (void)handleAnimatedCaseWithOffset:(CGFloat)offset;

@end



@implementation CRPullToRefresh


#pragma mark - setters && getters

// using just for bottom pull to refresh
- (CGFloat)correctBottomPosition {
    return MAX(self.scrollView.frame.size.height - self.scrollView.contentInset.top, self.scrollView.contentSize.height);
}



#pragma mark - Public Methods

- (void)stopRefresh {
    if (!self.isRefreshing) {
        return;
    }
    self.isRefreshing = NO;
    
    [self.refreshAnimation removeAnimations];
    
    self.scrollView.scrollEnabled = NO;
    
    [UIView animateWithDuration:kCRInsetsAnimationDuration
                     animations:^{
                         [self.refreshAnimation animationViewWillHideWithDuration:kCRInsetsAnimationDuration];
                         [self resetInsets];
                     } completion:^(BOOL finished) {
                         self.scrollInsetsAdded = NO;
                         self.scrollView.scrollEnabled = YES;
                         self.animationState = CRAnimationState_Ready;
                     }];
}

- (void)updateFrames {
    if (![self.refreshView superview]){
        return;
    }
    
    CGFloat yPosition;
    if ( self.isBottomPosition ) {
        
        if (self.isContentSizeBigger) {
            yPosition = self.correctBottomPosition;
        } else {
            yPosition = self.correctBottomPosition - self.insetHeightForBound;
        }
        
    } else {
        yPosition = -self.originalRefreshViewHeight;
    }
    
    [UIView animateWithDuration:kCRInsetsAnimationDuration
                     animations:^{
                         self.refreshView.frame = CGRectMake(0.0f,
                                                         yPosition,
                                                         self.scrollView.frame.size.width,
                                                         self.originalRefreshViewHeight);
                         // align loading view
                         if (!self.isBottomPosition) {
                             [self handleAnimatedCaseWithOffset:[self offsetForHandleAnimation]];
                         } else {
                             [self handleAnimatedCaseWithOffset:[self offsetForHandleBottomAnimation]];
                         }
                     }];
}



#pragma mark - Private Methods

- (void)makeInset {
    if (_scrollInsetsAdded) {
        return;
    }
    self.scrollInsetsAdded = YES;
    
    UIEdgeInsets insets = self.scrollView.contentInset;
    
    // add inset for current refresher position
    if ( !self.isBottomPosition ) {
        insets.top += self.insetHeightForBound;
    } else {
        insets.bottom += self.insetHeightForBound;
    }
    
    [UIView animateWithDuration:kCRInsetsAnimationDuration
                     animations:^{
                         [self.scrollView setContentInset:insets];
                     }];
}
- (void)resetInsets {
    if (!_scrollInsetsAdded) {
        return;
    }
    
    UIEdgeInsets insets = self.scrollView.contentInset;
    
    // add inset for current refresher position
    if ( !self.isBottomPosition ) {
        insets.top -= self.insetHeightForBound;
    } else {
        insets.bottom -= self.insetHeightForBound;
    }
    
    [self.scrollView setContentInset:insets];
}



@end



#pragma mark - KVO handling

@implementation CRPullToRefresh (WorkWithKVO)


#pragma mark Helper methods to handle KVO keyPaths

- (void)contentSizeKeyPath {
    BOOL refresherNeedsUpdate = self.refreshView.bounds.size.width != self.scrollView.bounds.size.width;
    BOOL scrollViewFrameIsChanged = ! CGRectEqualToRect(_previousScrollViewFrame, self.scrollView.frame);
    BOOL scrollViewContentSizeChanged = ! CGSizeEqualToSize(_previousScrollViewContentSize, self.scrollView.contentSize);
    
    if (refresherNeedsUpdate ||
        scrollViewFrameIsChanged ||
        scrollViewContentSizeChanged) {
        
        [self updateFrames];
        self.previousScrollViewFrame = self.scrollView.frame;
        self.previousScrollViewContentSize = self.scrollView.contentSize;
    }
}

- (void)contentOffsetKeyPath {
    if (!self.enabled){
        // refresh controll is disabled
        return;
    }
    
    CGFloat offset;
    if ( !self.isBottomPosition ) {
        offset = [self offsetForHandleAnimation];
    } else {
        offset = [self offsetForHandleBottomAnimation];
    }
    
    BOOL hasTouches = self.scrollView.isTracking;
    
    // offset in the another direction, there is no sence to go further
    if (offset < 0) {
        return;
    }
    
    switch (self.animationState) {
        case CRAnimationState_NotReady:
            return;
            break;
            
        case CRAnimationState_Ready: {
            [self handleReadyCaseWithOffset:offset];
            
            if (offset > self.offsetForReload) {
                // indicate point for reloading
                if (!hasTouches){
                    [self startRefresh];
                }
            }
        }
            
        case CRAnimationState_Animated: {
            [self handleAnimatedCaseWithOffset:offset];
            
            if (offset < self.insetHeightForBound && !self.scrollInsetsAdded) {
                if (!hasTouches && self.isRefreshing){
                    // if there is no touches we will make insets
                    [self makeInset];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

/// manage stretch behaviour
- (void)handleReadyCaseWithOffset:(CGFloat)offset {
    
    // make divider for getting correct stretch factor
    NSUInteger offsetDivider = self.insetHeightForBound;
    offsetDivider = MIN(self.offsetForReload, offsetDivider);
    
    // calculating stretch factor,
    CGFloat stretchFactor = (offset / offsetDivider);
    if (stretchFactor >= 0){
        
        // stretch factor could be from 0.0 to 1.0,
        // and that value will be send to animation
        stretchFactor = MIN(1.0f, stretchFactor);
        [self.refreshAnimation setStretchPercent:stretchFactor];
    }
}

/// manage loadingView position while offset changing
- (void)handleAnimatedCaseWithOffset:(CGFloat)offset {
    CGFloat xPosition  = self.refreshView.frame.size.width / 2;
    CGFloat yPosition;
    
    // create yPosition according to refresher position
    // and move to to opposite side in twice slower
    CGFloat offsetMovement = offset / 2;
    if ( !self.isBottomPosition ) {
        yPosition = self.refreshView.frame.size.height - offsetMovement;
        if (_scrollInsetsAdded) {
            yPosition -= self.insetHeightForBound / 2;
        }
    } else {
        if ( !self.isContentSizeBigger ) {
            yPosition = offsetMovement + self.insetHeightForBound / 2;
        } else {
            yPosition = offsetMovement;
        }
    }
    
    
    // fix issue with changing orientation
    {
        CGRect bounds = self.loadingView.bounds;
        bounds.size = self.loadingViewSize;
        self.loadingView.bounds = bounds;
    }
    
    self.loadingView.layer.position = CGPointMake(xPosition, yPosition);
}

/**
 @brief will return value of scroll view, when scroll will move out of bounds,
 offset will be calculate from 0 and grather.
 */
- (CGFloat)offsetForHandleAnimation {
    return - (self.scrollView.contentOffset.y + self.scrollView.contentInset.top);
}

- (CGFloat)offsetForHandleBottomAnimation {
    
    if ( !self.isContentSizeBigger ) {
        return (self.scrollView.contentOffset.y + self.scrollView.contentInset.top);;
    } else {
        CGFloat tresholdHeight = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
        return  self.scrollView.contentOffset.y - tresholdHeight;
    }
}

@end

