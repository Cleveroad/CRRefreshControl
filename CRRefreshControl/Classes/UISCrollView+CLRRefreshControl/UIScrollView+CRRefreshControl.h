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
- (void)cr_addPullToRefreshWithHandler:(CRRefreshHandler)handler type:(CRRefreshType)type;
- (void)cr_addPullToRefreshWithHandler:(CRRefreshHandler)handler animation:(CRRefreshAnimation*)animation;

- (void)cr_addBottomPullToRefreshWithHandler:(CRRefreshHandler)handler;
- (void)cr_addBottomPullToRefreshWithHandler:(CRRefreshHandler)handler type:(CRRefreshType)type;
- (void)cr_addBottomPullToRefreshWithHandler:(CRRefreshHandler)handler animation:(CRRefreshAnimation*)animation;



#pragma mark - Adding InfiniteRefresh
- (void)cr_addInfiniteRefreshWithHandler:(CRRefreshHandler)handler;
- (void)cr_addInfiniteRefreshWithHandler:(CRRefreshHandler)handler type:(CRRefreshType)type;
- (void)cr_addInfiniteRefreshWithHandler:(CRRefreshHandler)handler animation:(CRRefreshAnimation*)animation;



#pragma mark - Manage Behaviour
- (void)cr_stopRefresh;

@end
