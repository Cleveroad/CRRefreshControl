//
//  CRRefreshControlCore_Protected.h
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 5/10/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRRefreshControlCore.h"

@interface CRRefreshControlCore ()

@property (weak, nonatomic) UIScrollView     *scrollView;

@property (strong, nonatomic) CRRefreshView *refreshView;
@property (strong, nonatomic) UIView *loadingView;
@property (assign, nonatomic) CGSize loadingViewSize;

@property (assign, nonatomic) CRAnimationState animationState;

/**
 @brief addition to offset animation.
 animation offset to top bounds and bottom bounds
 */
@property (assign, nonatomic) CGFloat additionAnimationOffset;;

/// offset to indicate when refresh should begin.
@property (assign, nonatomic) CGFloat offsetForReload;

@property (assign, nonatomic) BOOL observersAdded;
@property (assign, nonatomic) BOOL isRefreshing;

@property (assign, nonatomic) BOOL isBottomPosition;

@property (assign, nonatomic, readonly) CGFloat insetHeightForBound;
@property (assign, nonatomic, readonly) BOOL isContentSizeBigger;

@property (assign, nonatomic, readonly) CGFloat originalRefreshViewHeight;


- (void)startRefresh;
- (void)stopRefresh;

- (void)updateFrames;


@end


@interface CRRefreshControlCore (WorkWithKVO)
- (void)addObservers;
- (void)removeObservers;

- (void)contentSizeKeyPath;
- (void)contentOffsetKeyPath;

- (CGFloat)offsetForHandleAnimation;
@end