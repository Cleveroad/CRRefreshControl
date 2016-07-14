//
//  CRRefreshControlTypes.h
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/19/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

typedef void (^CRRefreshHandler)();


/**
 @brief types for factory to instantiate and return coorect animation.
 */
typedef NS_ENUM( NSUInteger, CRRefreshType)
{
    CRRefreshType_Default,
    CRRefreshType_Star,
    CRRefreshType_VideoAnimation
    
    
};

typedef NS_ENUM( NSUInteger, CRAnimationState)
{
    CRAnimationState_NotReady,
    CRAnimationState_Ready,
    CRAnimationState_Animated,
    CRAnimationState_StopAnimated
};



// ===== ===== ===== ===== ========== ===== ===== ===== ===== //
// ----- ----- ----- | UNDER CONSTRUCTION | ----- ----- ----- //
// ===== ===== ===== ===== ========== ===== ===== ===== ===== //

/// under construction
typedef NS_ENUM(NSUInteger, CRRefreshEvent) {
    CRRefreshEvent_Prepared,
    CRRefreshEvent_StartStretching,
    CRRefreshEvent_EndStretching,
    CRRefreshEvent_StartAnimating,
    CRRefreshEvent_EndAnimating,
} __unavailable;