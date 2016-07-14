//
//  CRRefreshAnimation.h
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 1/28/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "CRRefreshConstants.h"


/**
 @discussion Base Abstract class of animations for CRRefreshControl, 
    inherit it to create your own animation ;-)
 */
@interface CRRefreshAnimation : NSObject

/// Main constructor.
+ (instancetype)animation;



#pragma mark - Preparing Animation lifecycle
#pragma mark Required

/**
 @brief Will return view which will be used for animation scene.
 @discussion  @b Required
 */
- (UIView*)sceneForAnimation;

#pragma mark Optional

/// Will return offset which will indicate for trigger reload and animation.
- (CGFloat)offsetForReload;

/// Additional offset between top and bottom of animation
- (CGFloat)additionAnimationOffset;

/// calling befire set insets to original
- (void)animationViewWillHideWithDuration:(NSTimeInterval)duration;



#pragma mark - Animation lifecycle

#pragma mark Optional

/// setAnimation to Default position
- (void)setAnimationToDefaultState;

/**
 @brief Sent stretch percent, from 0...1, for preparing animation,
 you can set up some changes using percent as your delta, look example fro details
 */
- (void)setStretchPercent:(CGFloat)percent;

#pragma mark Required

/**
 @brief Will called when control is beginRefreshing
 @discussion  @b Required
 */
- (void)setUpAnimations;

/**
 @brief Will called when control is endRefreshing
 @discussion  @b Required
 */
- (void)removeAnimations;

@end