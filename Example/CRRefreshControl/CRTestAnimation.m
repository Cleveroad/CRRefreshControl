//
//  CRTestAnimation.m
//  CRRefreshControl
//
//  Created by Dmitry Pashinskiy on 7/14/16.
//  Copyright © 2016 Dmitry Pashinskiy. All rights reserved.
//

#import "CRTestAnimation.h"

@interface CRTestAnimation ()

@property (weak, nonatomic) UIView *scene;
@property (weak, nonatomic) CAShapeLayer *loadLayer;

@end


@implementation CRTestAnimation


#pragma mark - CRRefreshAnimation

+ (instancetype)animation {
    return [[self alloc] init];
}

- (UIView *)sceneForAnimation {
    
    CGFloat size = 35.0f;
    
    UIView *scene = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    scene.backgroundColor = [UIColor clearColor];
    
    CAShapeLayer *loadLayer = [[CAShapeLayer alloc] init];
    loadLayer.bounds = scene.bounds;
    loadLayer.path = [UIBezierPath bezierPathWithOvalInRect:scene.bounds].CGPath;
    loadLayer.fillColor = [UIColor whiteColor].CGColor;
    loadLayer.lineWidth = 2.0f;
    loadLayer.strokeColor = [UIColor magentaColor].CGColor;
    
    [scene.layer addSublayer:loadLayer];
    loadLayer.position = scene.center;
    
    // we will store weak reference on the view
    self.scene = scene;
    self.loadLayer = loadLayer;
    
    return scene;
}

- (void)setStretchPercent:(CGFloat)percent {
    NSLog(@"%f", percent);
    self.loadLayer.strokeEnd = percent;
}

- (void)setUpAnimations {
    self.loadLayer.lineDashPattern = @[@8,@4];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.byValue  = @( 2 * M_PI);
    animation.duration = 1.0;
    animation.repeatCount = INFINITY;
    
    [self.loadLayer addAnimation:animation forKey:nil];
}

- (void)removeAnimations {
    self.loadLayer.strokeEnd = 0;
    self.loadLayer.lineDashPattern = nil;
    [self.loadLayer removeAllAnimations];
}

@end
