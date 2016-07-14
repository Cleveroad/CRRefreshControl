//
//  CRRefreshControl.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 1/27/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRRefreshControlCore.h"
#import "CRRefreshView.h"
#import "CRRefreshAnimationFactory.h"
#import "CRRefreshControlCore_Protected.h"
#import "CRAppearance.h"



@implementation CRRefreshControlCore


#pragma mark - setters && getters

- (void)setRefreshAnimation:(CRRefreshAnimation *)refreshAnimation {
    NSParameterAssert(refreshAnimation);
    
    _refreshAnimation = refreshAnimation.copy;
    
    _loadingView = [_refreshAnimation sceneForAnimation];
    [_refreshView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_refreshView addSubview:_loadingView];
    
    _loadingViewSize = _loadingView.frame.size;
    
    _additionAnimationOffset = [_refreshAnimation additionAnimationOffset];
    _offsetForReload         = [_refreshAnimation offsetForReload];
    
    self.animationState = CRAnimationState_Ready;
    
    [self updateFrames];
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [self stopRefresh];
    
    [UIView animateWithDuration:kCRInsetsAnimationDuration
                     animations:^{
                         self.refreshView.alpha = enabled ? 1.0f : 0.0f;
    }];
}

- (void)setAnimationState:(CRAnimationState)animationState {
    switch (animationState) {
        case CRAnimationState_NotReady:
            break;
            
        case CRAnimationState_Ready:
            [self.refreshAnimation setAnimationToDefaultState];
            break;
            
        case CRAnimationState_Animated:{
            [self.refreshAnimation setStretchPercent:1.0f];
            [self.refreshAnimation setUpAnimations];
        }
            break;
            
        case CRAnimationState_StopAnimated:
            break;
            
            
        default:
            break;
    }
    
    _animationState = animationState;
}

- (CGFloat)originalRefreshViewHeight {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return MAX(screenSize.height, screenSize.width);
}

- (BOOL)isContentSizeBigger {
    return self.scrollView.contentSize.height > self.scrollView.bounds.size.height;
}

- (CGFloat)insetHeightForBound {
    return _loadingView.bounds.size.height + _additionAnimationOffset;
}



#pragma mark - Public Methods

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    return [self initWithScrollView:scrollView bottomPosition:NO];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView bottomPosition:(BOOL)isBottom {
    self = [super init];
    if (self) {
        
        // defaults
        _additionAnimationOffset = kCRDefaultAddingOffsetAppear;
        _offsetForReload         = kCRDefaultOffsetForReload;
        _isBottomPosition        = isBottom;
        
        _enabled = YES;
        self.animationState = CRAnimationState_NotReady;
        
        _scrollView = scrollView;
        _refreshView = [CRRefreshView new];
        [_scrollView insertSubview:_refreshView atIndex:0];
        
        [self updateFrames];
        [self addObservers];
        
        CRAppearance *appearance = [CRAppearance appearanceForClass:[self class]];
        [appearance startForwarding:self];
        
        if (!_refreshAnimation) {
            self.refreshAnimation = CRRefreshAnimationWithType(CRRefreshType_Default);
        }
    }
    return self;
}

- (void)dealloc {
    [self removeObservers];
}

- (void)setBackgroundColor:(UIColor*)backgroundColor {
    _refreshView.backgroundColor = backgroundColor;
}

- (void)startRefresh {
    // check animation instance existing
    if (!self.refreshAnimation){
        NSLog(@"There is no animation in CRRefreshControl");
        return;
    }
    
    // check is already refreshing
    if (_isRefreshing) {
        return;
    }
    _isRefreshing = YES;
    
    if (_handler) {
        _handler();
    }

    self.animationState = CRAnimationState_Animated;
    //TODO: if startRefresh will be moved to public, add logic to makeInsets
}

- (void)stopRefresh {

}

- (void)updateFrames {

}



#pragma mark - UIAppearance
+ (instancetype)appearance {
    return [CRAppearance appearanceForClass:[self class]];
}



#pragma mark - Selectors

- (void)orientationDidChange:(NSNotification*)notification {
    [self updateFrames];
}



#pragma mark - Private Methods


@end



#pragma mark - KVO handling

@implementation CRRefreshControlCore (WorkWithKVO)

- (void)addObservers {
    if (!_observersAdded && _scrollView) {
        _observersAdded = YES;
        
        [_scrollView addObserver:self
                      forKeyPath:kCRObserverKeyScrollContentOffset
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior
                         context:NULL];
        
        [_scrollView addObserver:self
                      forKeyPath:kCRObserverKeyScrollContentSize
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:NULL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
}

- (void)removeObservers {
    if (_observersAdded && _scrollView) {
        _observersAdded = NO;
        
        [_scrollView removeObserver:self forKeyPath:kCRObserverKeyScrollContentOffset];
        [_scrollView removeObserver:self forKeyPath:kCRObserverKeyScrollContentSize];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kCRObserverKeyScrollContentSize]) {
        [self contentSizeKeyPath];
        
    } else if ([keyPath isEqualToString:kCRObserverKeyScrollContentOffset]) {
        [self contentOffsetKeyPath];
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



#pragma mark Helper methods to handle KVO keyPaths

- (void)contentSizeKeyPath {
    
}

- (void)contentOffsetKeyPath {
    
}


/**
 @brief will return value of scroll view, when scroll will move out of bounds,
    offset will be calculate from 0 and grather.
 */
- (CGFloat)offsetForHandleAnimation {
    @throw [NSException exceptionWithName:@"Architecture has been a violation" reason:@"Abstract method was called" userInfo:nil];
}

@end

