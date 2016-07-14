# CRRefreshControl

[![CI Status](http://img.shields.io/travis/Dmitry Pashinskiy/CRRefreshControl.svg?style=flat)](https://travis-ci.org/Dmitry Pashinskiy/CRRefreshControl)
[![Version](https://img.shields.io/cocoapods/v/CRRefreshControl.svg?style=flat)](http://cocoapods.org/pods/CRRefreshControl)
[![License](https://img.shields.io/cocoapods/l/CRRefreshControl.svg?style=flat)](http://cocoapods.org/pods/CRRefreshControl)
[![Platform](https://img.shields.io/cocoapods/p/CRRefreshControl.svg?style=flat)](http://cocoapods.org/pods/CRRefreshControl)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CRRefreshControl is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CRRefreshControl"
```

```Objective-C
    #import "CRRefreshControl.h"
```


## Usage

### CRRefreshControl

* Mechanism of `CRRefreshContol` based on work with `UIScrollView`, so you can use it for `UITableView` and `UICollectionView`
    
```Objective-C
// for default pull to refresh
[self.tableView cr_addPullToRefreshWithHandler:^{
    
}];

// for bottom pull to refresh
[self.tableView cr_addBottomPullToRefreshWithHandler:^{

}];

// for default (bottom) infinite scroll
[self.tableView cr_addInfiniteRefreshWithHandler:^{

}];
```

* To stop refreshing simply call method of scrollView `cr_stopRefresh` this will send stop to all CRRefreshControls or 
you can call it separately.

```Objective-C
// for all refresh controls
[self.tableView cr_stopRefresh];

// for default pull to refresh
[self.tableView.cr_pullToRefresh stopRefresh];

// for bottom pull to refresh
[self.tableView.cr_bottomPullToRefresh stopRefresh];

// for default infinite scroll
[self.tableView.cr_infiniteRefresh stopRefresh];
```

* You can choose one of the default animation

```Objective-C
// will use one of the default animation 
[self.tableView cr_addPullToRefreshWithType:CRRefreshType_Star handler:^{

}];

// will use default animation (similar to native UIRefreshControl, but not the same ;) )
[self.tableView cr_addPullToRefreshWithType:CRRefreshType_Default handler:^{

}];
```

* CRRefreshControl support `UIAppearance`
    You can change default animation by another default or your custom animation

```Objective-C
// Now instead by default instead of CRRefreshType_Default will be used CRRefreshType_Star
CRRefreshAnimation *animation = CRRefreshAnimationWithType(CRRefreshType_Star);

// Here animation will be coppied, you should set all properties before you call setter
[[CRPullToRefresh appearance] setRefreshAnimation:animation];
```

### Custom Animation

* You can simply create your own animation just inherit `CRRefreshAnimation` and override some method of animation lifecycle as shown below

```Objective-C
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
```


## Author

Dmitry Pashinskiy, pashinskiy.kh.cr@gmail.com

## License

CRRefreshControl is available under the MIT license. See the LICENSE file for more info.
