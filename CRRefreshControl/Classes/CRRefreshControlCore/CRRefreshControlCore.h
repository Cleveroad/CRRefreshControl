//
//  CRRefreshControl.h
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 1/27/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "CRRefreshAnimation.h"
#import "CRRefreshConstants.h"
#import "CRRefreshControlTypes.h"
#import "CRRefreshAnimationFactory.h"

typedef void (^CRRefreshHandler)();



@interface CRRefreshControlCore : NSObject <UIAppearance>

/// Will be called when refresh begin start animating
@property (copy, nonatomic) CRRefreshHandler handler;


/**
 @discussion You can use CRRefreshAnimationWithType() to create animation
 by setting a CRRefreshType, and you will get one of the default animations.
 Or you can inherits from CRRefreshAnimation and create your own animation = )
 @b copy
 */
@property (copy, nonatomic) __kindof CRRefreshAnimation *refreshAnimation;

/// flag to indicate status of refreshing
@property (assign, nonatomic, readonly) BOOL isRefreshing;

/// wil enabled / disable refresher
@property (assign, nonatomic) BOOL enabled;



/// stop refreshing
- (void)stopRefresh;



/**
 @brief Main constructor for creating refresh controll, after constructor
 refresh controll will be automatically added to scrollView.
 @param scrollView - receive any heirs of UIScrollView.
 @param isBottom - define position of refresh control. If NO - position will be top
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView bottomPosition:(BOOL)isBottom;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;


/// set up of background color
- (void)setBackgroundColor:(UIColor*)backgroundColor;


- (instancetype)init __attribute__((unavailable("use -initWithScrollView:  instead")));
+ (instancetype)new __attribute__((unavailable("use -initWithScrollView:  instead")));

@end

