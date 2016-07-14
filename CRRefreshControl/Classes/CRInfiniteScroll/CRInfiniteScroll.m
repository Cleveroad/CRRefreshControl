//
//  CRRefreshControl.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 1/27/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRInfiniteScroll.h"
#import "CRRefreshView.h"
#import "CRRefreshAnimationFactory.h"
#import "CRRefreshControlCore_Protected.h"



@interface CRInfiniteScroll ()

@property (assign, nonatomic) BOOL isOffsetAdded;

/// indicate of changing scrollView layout
@property (assign, nonatomic) CGRect previousScrollViewFrame;
@property (assign, nonatomic) CGSize previousScrollViewContentSize;

@end



@implementation CRInfiniteScroll

#pragma mark - setters && getters 
- (void)setRefreshAnimation:( CRRefreshAnimation *)refreshAnimation {
    [super setRefreshAnimation:refreshAnimation];
    [self increseScrollContentSize];
}



#pragma mark - Public Methods

+ (instancetype)refresherWithScrollView:(UIScrollView *)scrollView {
    return [[CRInfiniteScroll alloc] initWithScrollView:scrollView];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithScrollView:scrollView];
    if (self) {
        _isOffsetAdded = NO;
    }
    return self;
}


- (void)stopRefresh {
    if (!self.isRefreshing) {
        return;
    }
    self.isRefreshing = NO;
    
    [self.refreshAnimation removeAnimations];
    self.animationState = CRAnimationState_Ready;
    [self adjustContentOffsetToCloseRefresher];
}

- (void)updateFrames {
    if (![self.refreshView superview]){
        return;
    }
    
    self.refreshView.frame = CGRectMake(0.0f,
                                    self.scrollView.contentSize.height - self.insetHeightForBound,
                                    self.scrollView.frame.size.width,
                                    self.originalRefreshViewHeight);
    // align loading view
    [self updateLoadingPosition];
}

- (void)updateLoadingPosition {
    CGFloat xPosition = self.refreshView.frame.size.width / 2;
    CGFloat yPosition = self.insetHeightForBound / 2;
    
    // fix issue with changing orientation
    {
        CGRect bounds = self.loadingView.bounds;
        bounds.size = self.loadingViewSize;
        self.loadingView.bounds = bounds;
    }
    
    self.loadingView.layer.position = CGPointMake(xPosition, yPosition);
}





#pragma mark - Private Methods

- (void)increseScrollContentSize {
    
    self.isOffsetAdded = YES;
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height += self.insetHeightForBound;
    
    self.scrollView.contentSize = contentSize;
    
}

- (void)decreaseScrollContentSize {
    if (!self.isOffsetAdded) {
        return;
    }
    
    CGSize contentSize = self.scrollView.contentSize;
    contentSize.height -= self.insetHeightForBound;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.scrollView.contentSize = contentSize;
                     }];
    
    self.isOffsetAdded = NO;
}

- (void)adjustContentOffsetToCloseRefresher {
    
    CGFloat offsetY = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    offsetY -= self.insetHeightForBound;
    offsetY = MAX(offsetY, 0.0f);
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, offsetY) animated:YES];
    
}

@end



#pragma mark - KVO handling

@implementation CRInfiniteScroll (WorkWithKVO)

#pragma mark Helper methods to handle KVO keyPaths

- (void)contentSizeKeyPath {
    BOOL refresherNeedsUpdate         = self.refreshView.bounds.size.width != self.scrollView.bounds.size.width;
    BOOL scrollViewFrameIsChanged     = ! CGRectEqualToRect(self.previousScrollViewFrame, self.scrollView.frame);
    
    CGSize sizeForCompare = self.previousScrollViewContentSize;
    if (self.isOffsetAdded) {
        sizeForCompare.height += self.insetHeightForBound;
    }
    
    BOOL scrollViewContentSizeChanged = ! CGSizeEqualToSize(sizeForCompare, self.scrollView.contentSize);
    
    if (refresherNeedsUpdate ||
        scrollViewFrameIsChanged ||
        scrollViewContentSizeChanged) {
        
        if (scrollViewContentSizeChanged) {
            self.previousScrollViewContentSize = self.scrollView.contentSize;
            if (self.isOffsetAdded){
                [self increseScrollContentSize];
            }
        }
        
        [self updateFrames];
        self.previousScrollViewFrame = self.scrollView.frame;
    }
}

- (void)contentOffsetKeyPath {
    if (!self.enabled){
        // refresh controll is disabled
        return;
    }
    
    switch (self.animationState) {
        case CRAnimationState_NotReady:
            return;
            break;
            
        case CRAnimationState_Ready:{
            
            CGFloat currentOffset = [self offsetForHandleAnimation];
            CGFloat thresholdOffset;
            
            if (self.scrollView.contentSize.height > self.scrollView.bounds.size.height) {
                thresholdOffset = -self.insetHeightForBound;
            } else {
                thresholdOffset = 20.0f;
            }
            
            if ( currentOffset > thresholdOffset && self.scrollView.isDragging) {
                [self startRefresh];
            }
            
            
        }
            
        case CRAnimationState_Animated:
            break;
            
        default:
            break;
    }
}

/**
 @brief will return value of scroll view, when scroll will move out of bounds,
 offset will be calculate from 0 and grather.
 */
- (CGFloat)offsetForHandleAnimation {
    CGFloat offset;
    
    // if content height grather than table height,
    // we will handle offset to indicate bottom bounds of content height
    if (self.scrollView.contentSize.height - self.insetHeightForBound > self.scrollView.bounds.size.height) {
        CGFloat botOffset = self.scrollView.bounds.size.height + self.scrollView.contentOffset.y;
        offset = self.scrollView.contentSize.height - botOffset;
        offset = - (offset + self.scrollView.contentInset.bottom);
    } else {
        offset = self.scrollView.contentOffset.y + self.scrollView.contentInset.top;
    }
    
    return offset;
}

@end

