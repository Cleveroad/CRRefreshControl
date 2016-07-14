//
//  CRRefreshAnimation.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 1/28/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRRefreshAnimation.h"
#import "CRRefreshControlCore.h"
#import <objc/runtime.h>

#define CRExcepAnimationClassStr [NSString stringWithFormat:@"%@ is Abstract class", NSStringFromClass([self class])]
#define CRExcepAnimationReson    [NSString stringWithFormat:@"you use %s, perhaps you forgot to override this function",__FUNCTION__]


@interface CRRefreshAnimation ()

@property (strong, nonatomic) UIView *viewForAnimation;

@end



@implementation CRRefreshAnimation

+ (instancetype)animation {
    // will call animation of heir class
    return [self animation];
}

- (id)copy{
    id animationCopy = [[[self class] alloc] init];
    return [self copyObject:animationCopy withClass:[self class]];
}

- (id)copyObject:(id)object withClass:(Class)AnimClass{
    unsigned int numberOfIvars = 0;
    Ivar *superIvars = class_copyIvarList(AnimClass, &numberOfIvars);
    for (int i = 0; i < numberOfIvars; i++){
        const char *cName = ivar_getName(superIvars[i]);
        
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        id value = [self valueForKey:name];
        
        [object setValue:value forKey:name];
    }
    
    if ([AnimClass superclass] == [NSObject class]){
        return object;
    } else {
        return [self copyObject:object withClass:[AnimClass superclass]];
    }
}




#pragma mark - Preparing Animation lifecycle
- (UIView *)sceneForAnimation {
    @throw [NSException exceptionWithName:CRExcepAnimationClassStr reason:CRExcepAnimationReson userInfo:nil];
}

- (CGFloat)offsetForReload{
    return kCRDefaultOffsetForReload;
}

- (CGFloat)additionAnimationOffset {
    return kCRDefaultAddingOffsetAppear;
}

- (void)animationViewWillHideWithDuration:(NSTimeInterval)duration {
    
}

#pragma mark - Animation lifecycle
- (void)setAnimationToDefaultState {
    
}

- (void)setStretchPercent:(CGFloat)percent{

}

- (void)setUpAnimations {
    @throw [NSException exceptionWithName:CRExcepAnimationClassStr reason:CRExcepAnimationReson userInfo:nil];
}

- (void)removeAnimations {
    @throw [NSException exceptionWithName:CRExcepAnimationClassStr reason:CRExcepAnimationReson userInfo:nil];
}

@end
