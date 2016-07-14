//
//  CRAnimationShowViewController.h
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/12/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

@import UIKit;
#import "CRRefreshControlCore.h"

@interface CRAnimationShowViewController : UIViewController

@property (assign, nonatomic) CRRefreshType type;

@property (assign, nonatomic) UIRectEdge rectEdge;
@property (assign, nonatomic) BOOL internalAdjustScrollView;

@property (assign, nonatomic) BOOL isInfiniteScrollTopEnabled;
@property (assign, nonatomic) BOOL isInfiniteScrollBottomEnabled;

@property (assign, nonatomic) BOOL isPullToRefreshTopEnabled;
@property (assign, nonatomic) BOOL isPullToRefreshBottomEnabled;

@property (assign, nonatomic) NSTimeInterval durationOfFakeRequest;


@end
