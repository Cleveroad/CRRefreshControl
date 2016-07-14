//
//  CRRefreshConstants.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/24/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRRefreshConstants.h"


// KVO keys
NSString * const kCRObserverKeyScrollContentInset  = @"contentInset";
NSString * const kCRObserverKeyScrollContentOffset = @"contentOffset";
NSString * const kCRObserverKeyScrollContentSize   = @"contentSize";


//defaults
const CGFloat kCRDefaultAddingOffsetAppear = 30.0f;
const CGFloat kCRDefaultOffsetForReload    = 80.0f;

const NSTimeInterval kCRInsetsAnimationDuration = 0.5;
