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





## Author

Dmitry Pashinskiy, pashinskiy.kh.cr@gmail.com

## License

CRRefreshControl is available under the MIT license. See the LICENSE file for more info.
