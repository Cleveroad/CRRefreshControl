//
//  UIScrollView+CRRefreshControl.h
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/15/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRPullToRefresh.h"
#import "CRInfiniteScroll.h"
@import UIKit;



@interface UIScrollView (CRRefreshControl)

/**
 @brief property of the current refreshControl,
 read CRRefreshControl documentation to see more posibilities.
 */
@property (strong, nonatomic, readonly) CRPullToRefresh *cr_pullToRefresh;

@property (strong, nonatomic, readonly) CRPullToRefresh *cr_bottomPullToRefresh;

@property (strong, nonatomic, readonly) CRInfiniteScroll *cr_infiniteRefresh;



#pragma mark - Adding PullToRefresh
// by default will add refresher to TOP
- (void)cr_addPullToRefreshWithHandler:(CRRefreshHandler)handler;
- (void)cr_addPullToRefreshWithType:(CRRefreshType)type handler:(CRRefreshHandler)handler;
- (void)cr_addPullToRefreshWithAnimation:(CRRefreshAnimation*)animation handler:(CRRefreshHandler)handler;

- (void)cr_addBottomPullToRefreshWithHandler:(CRRefreshHandler)handler;
- (void)cr_addBottomPullToRefreshWithType:(CRRefreshType)type handler:(CRRefreshHandler)handler;
- (void)cr_addBottomPullToRefreshWithAnimation:(CRRefreshAnimation*)animation handler:(CRRefreshHandler)handler;



#pragma mark - Adding InfiniteRefresh
- (void)cr_addInfiniteRefreshWithHandler:(CRRefreshHandler)handler;
- (void)cr_addInfiniteRefreshWithType:(CRRefreshType)type handler:(CRRefreshHandler)handler;
- (void)cr_addInfiniteRefreshWithAnimation:(CRRefreshAnimation*)animation handler:(CRRefreshHandler)handler;



#pragma mark - Manage Behaviour
- (void)cr_stopRefresh;

@end
