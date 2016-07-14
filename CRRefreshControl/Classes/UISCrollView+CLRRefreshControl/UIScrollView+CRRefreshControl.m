//
//  UIScrollView+CRRefreshControl.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/15/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "UIScrollView+CRRefreshControl.h"
#import <objc/runtime.h>

// keys for associated objects
static NSString * const kCRAssocatedKeyPullToRefresh       = @"CRAssocatedKeyPullToRefresh";
static NSString * const kCRAssocatedKeyBottomPullToRefresh = @"CRAssocatedKeyBottomPullToRefresh";
static NSString * const kCRAssocatedKeyInfiniteRefresh     = @"CRAssocatedKeyInfiniteRefresh";



@implementation UIScrollView (CRRefreshControl)



#pragma mark - setters && getters
#pragma mark setters
- (void)setcr_pullToRefresh:(CRPullToRefresh *)cr_pullToRefresh {
    objc_setAssociatedObject(self,
                             &kCRAssocatedKeyPullToRefresh,
                             cr_pullToRefresh,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setcr_bottomPullToRefresh:(CRPullToRefresh *)cr_bottomPullToRefresh {
    objc_setAssociatedObject(self,
                             &kCRAssocatedKeyBottomPullToRefresh,
                             cr_bottomPullToRefresh,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setcr_infiniteRefresh:(CRInfiniteScroll *)cr_infiniteRefresh {
    objc_setAssociatedObject(self,
                             &kCRAssocatedKeyInfiniteRefresh,
                             cr_infiniteRefresh,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark getters

- (CRPullToRefresh *)cr_pullToRefresh {
    return objc_getAssociatedObject(self, &kCRAssocatedKeyPullToRefresh);
}

- (CRPullToRefresh *)cr_bottomPullToRefresh {
    return objc_getAssociatedObject(self, &kCRAssocatedKeyBottomPullToRefresh);
}

- (CRInfiniteScroll *)cr_infiniteRefresh {
    return objc_getAssociatedObject(self, &kCRAssocatedKeyInfiniteRefresh);
}



#pragma mark - Adding PullToRefresh
#pragma mark Top pull to refresh
- (void)cr_addPullToRefreshWithHandler:(CRRefreshHandler)handler {
    CRPullToRefresh *refresher = [[CRPullToRefresh alloc] initWithScrollView:self];
    refresher.handler = handler;
    [self setcr_pullToRefresh:refresher];
}

- (void)cr_addPullToRefreshWithHandler:(CRRefreshHandler)handler type:(CRRefreshType)type {
    [self cr_addPullToRefreshWithHandler:handler animation:CRRefreshAnimationWithType(type)];
}

- (void)cr_addPullToRefreshWithHandler:(CRRefreshHandler)handler animation:(CRRefreshAnimation*)animation {
    [self cr_addPullToRefreshWithHandler:handler];
    [self.cr_pullToRefresh setRefreshAnimation:animation];
}

#pragma mark Bottom pull to refresh
- (void)cr_addBottomPullToRefreshWithHandler:(CRRefreshHandler)handler {
    CRPullToRefresh *refresher = [[CRPullToRefresh alloc] initWithScrollView:self bottomPosition:YES];
    refresher.handler = handler;
    [self setcr_bottomPullToRefresh:refresher];
}

- (void)cr_addBottomPullToRefreshWithHandler:(CRRefreshHandler)handler type:(CRRefreshType)type {
    [self cr_addBottomPullToRefreshWithHandler:handler animation:CRRefreshAnimationWithType(type)];
}

- (void)cr_addBottomPullToRefreshWithHandler:(CRRefreshHandler)handler animation:(CRRefreshAnimation*)animation {
    [self cr_addBottomPullToRefreshWithHandler:handler];
    [self.cr_bottomPullToRefresh setRefreshAnimation:animation];
}



#pragma mark - Adding InfiniteRefresh

- (void)cr_addInfiniteRefreshWithHandler:(CRRefreshHandler)handler {
    CRInfiniteScroll *refresher = [[CRInfiniteScroll alloc] initWithScrollView:self];
    refresher.handler = handler;
    [self setcr_infiniteRefresh:refresher];
}

- (void)cr_addInfiniteRefreshWithHandler:(CRRefreshHandler)handler type:(CRRefreshType)type {
    [self cr_addInfiniteRefreshWithHandler:handler animation:CRRefreshAnimationWithType(type)];
}

- (void)cr_addInfiniteRefreshWithHandler:(CRRefreshHandler)handler animation:(CRRefreshAnimation*)animation {
    [self cr_addInfiniteRefreshWithHandler:handler];
    [self.cr_infiniteRefresh setRefreshAnimation:animation];
}



#pragma mark - Manage Behaviour
- (void)cr_stopRefresh {
    [self.cr_pullToRefresh stopRefresh];
    [self.cr_bottomPullToRefresh stopRefresh];
    [self.cr_infiniteRefresh stopRefresh];
}




@end
