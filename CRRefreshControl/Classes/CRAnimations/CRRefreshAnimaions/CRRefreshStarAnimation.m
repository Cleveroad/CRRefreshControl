//
//  CRRefreshCircleAnimation.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/23/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRRefreshStarAnimation.h"

@interface CRRefreshStarAnimation ()

@property (weak, nonatomic) UIView *viewForAnimation;

@property (strong, nonatomic) CAShapeLayer *starLayer;

@end



@implementation CRRefreshStarAnimation

+ (instancetype)animation {
    return [CRRefreshStarAnimation new];
}

- (CAShapeLayer *)starLayer {
    if (!_starLayer) {
        _starLayer = [self drawStarWithVertexCount:5 multiplier:30.0f];
        _starLayer.strokeEnd = 0;
        _starLayer.lineWidth = 3.0f;
        _starLayer.fillColor = [UIColor blueColor].CGColor;
        _starLayer.strokeColor = [UIColor redColor].CGColor;
        _starLayer.fillRule = kCAFillRuleEvenOdd;
        
    }
    return _starLayer;
}

#pragma mark - Preparing Animation lifecycle
#pragma mark Required

- (UIView*)sceneForAnimation {
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 80.0f)];
    
    [animationView.layer addSublayer:self.starLayer];
    self.starLayer.position = CGPointMake(CGRectGetWidth(animationView.frame) / 2, CGRectGetHeight(animationView.frame) / 2);
    self.starLayer.lineWidth = 1.0f;
    
    self.viewForAnimation = animationView;
    
    return animationView;
}

#pragma mark Optional

- (CGFloat)offsetForReload {
    return 80.0f;
}

- (CGFloat)additionAnimationOffset {
    return 20.0f;
}


- (void)animationViewWillHideWithDuration:(NSTimeInterval)duration {
    
}



#pragma mark - Animation lifecycle

#pragma mark Optional

- (void)setAnimationToDefaultState {
    
    self.starLayer.affineTransform = CGAffineTransformMakeScale(0.001f , 0.001f);
    self.starLayer.strokeEnd = 0;
    self.starLayer.fillColor = [UIColor clearColor].CGColor;
}

- (void)setStretchPercent:(CGFloat)percent {
    CGAffineTransform tScale  = CGAffineTransformMakeScale(percent , percent);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.starLayer.affineTransform = tScale;
    self.starLayer.strokeEnd = percent;
    [CATransaction commit];
}

#pragma mark Required


- (void)setUpAnimations {
    self.starLayer.fillColor = [UIColor blueColor].CGColor;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.byValue  = @(- 2 * M_PI);
    animation.duration = 1.0;
    animation.repeatCount = INFINITY;
    
    [self.starLayer addAnimation:animation forKey:NSStringFromClass([self class])];
}

- (void)removeAnimations {
    [self.starLayer removeAllAnimations];
}



#pragma mark - Private Methods
- (CAShapeLayer*)drawStarWithVertexCount:(NSUInteger)count multiplier:(NSInteger) relevantSize{
    NSUInteger generalCount = count * 2;
    
    CGFloat radiansForMovement = (2 * M_PI) / generalCount;
    // for allignment
    CGFloat additionalRotate = M_PI_2;
    
    
    CGFloat smallRadius = 0.4 * relevantSize;
    CGFloat bigRadius   = 1.0 * relevantSize;
    
    UIBezierPath *bezierPath = [UIBezierPath new];
    
    // first point
    [bezierPath moveToPoint:CGPointMake( cos( - additionalRotate) * bigRadius , sin( - additionalRotate) * bigRadius)];
    
    // add point to draw lines
    for (uint i = 1; i < generalCount; i++) {
        
        CGFloat correctRadiands = radiansForMovement * i - additionalRotate;
        CGFloat correctRadius;
        
        if (i % 2 == 0) {
            correctRadius = bigRadius;
        } else {
            correctRadius = smallRadius;
        }
        
        [bezierPath addLineToPoint:CGPointMake( cos(correctRadiands) * correctRadius , sin(correctRadiands) * correctRadius)];
    }
    
    [bezierPath closePath];
    
    CAShapeLayer *star = [CAShapeLayer new];
    star.path = bezierPath.CGPath;
    
    return star;
}

@end
