//
//  CRRefreshAnimationFabric.h
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/12/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

@import Foundation;
#import "CRRefreshControlTypes.h"
#import "CRRefreshDefaultAnimation.h"
#import "CRRefreshVideoAnimation.h"
#import "CRRefreshStarAnimation.h"


@interface CRRefreshAnimationFactory : NSObject

+ (CRRefreshAnimation*)animationWithType:(CRRefreshType)type;

@end


/**
 @brief Use this function to get animation by type
 */
CRRefreshAnimation * CRRefreshAnimationWithType(CRRefreshType type);