//
//  CRRefreshDefaultAniamation.h
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/12/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRRefreshAnimation.h"

@interface CRRefreshDefaultAnimation : CRRefreshAnimation

@property (strong, nonatomic) UIColor *sceneColor;

@property (assign, nonatomic) NSUInteger instanceCount;

@property (assign, nonatomic) NSTimeInterval dashAnimationDuration;

@end
