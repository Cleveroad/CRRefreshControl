//
//  CRRefreshAnimationFabric.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/12/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRRefreshAnimationFactory.h"
#import "CRRefreshAnimation.h"

static NSString * kCRRefreAnimationTypesStrArr[] = {
    [CRRefreshType_Default]        = @"CRRefreshDefaultAnimation",
    [CRRefreshType_Star]           = @"CRRefreshStarAnimation",
    [CRRefreshType_VideoAnimation] = @"CRRefreshVideoAnimation"
};



@implementation CRRefreshAnimationFactory

+ (CRRefreshAnimation*)animationWithType:(CRRefreshType)type {
    // getting of identifier
    NSString *identifier = kCRRefreAnimationTypesStrArr[type];
    if (!identifier || !identifier.length){
        NSLog(@"There is no such identifier type");
        return nil;
    }
    
    // getting of Class
    Class myClass = NSClassFromString(identifier) ;
    if (!myClass){
        NSLog(@"There is no such class with such identifier");
        return nil;
    }
    
    CRRefreshAnimation *animation = [myClass animation];
    return animation;
}

@end



CRRefreshAnimation * CRRefreshAnimationWithType(CRRefreshType type) {
    return [CRRefreshAnimationFactory animationWithType:type];
}