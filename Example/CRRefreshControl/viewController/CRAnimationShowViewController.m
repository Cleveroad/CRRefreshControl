//
//  CRAnimationShowViewController.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/12/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRAnimationShowViewController.h"
#import "CRRefreshControl.h"

// test values
static const NSUInteger kAmountOfCells  = 5;
static NSString * const kCellIdentifier = @"cellIdentifier";


@interface CRAnimationShowViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <NSDate *>* dates;

@end



@implementation CRAnimationShowViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetDates];
    
    // configure refresher block
    if (self.type == CRRefreshType_VideoAnimation) {
        [self configureVideoRefresher];
        
    } else {
        
        if (self.isPullToRefreshBottomEnabled || self.isPullToRefreshTopEnabled) {
            [self configurePullToRefresh];
        }
        
        if (self.isInfiniteScrollBottomEnabled || self.isInfiniteScrollTopEnabled) {
            [self configureInfiteScroll];
        }
        
    }
    
    //apply settings
    [self applySettings];
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    cell.textLabel.text = [dateFormatter stringFromDate:self.dates[indexPath.row]];
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark - Private Methods

- (void)resetDates {
    self.dates = [NSMutableArray arrayWithCapacity:kAmountOfCells];
    for (uint i = 0; i < kAmountOfCells; i++) {
        [self.dates addObject:[NSDate date]];
    }
}

- (void)reloadDates {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.durationOfFakeRequest * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView cr_stopRefresh];
        [self resetDates];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (void)loadDates {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.durationOfFakeRequest * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView cr_stopRefresh];
        NSMutableArray <NSIndexPath *>*indexPaths = @[].mutableCopy;
        
        if (self.dates.count > 40) return;
        
        for (uint i = 0; i < 10; i++) {
            [self.dates addObject:[NSDate date]];
            [indexPaths addObject:[NSIndexPath indexPathForRow:self.dates.count - 1 inSection:0]];
        }
        
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        
    });
}

- (void)configurePullToRefresh {
    if  (self.isPullToRefreshTopEnabled) {
        [self.tableView cr_addPullToRefreshWithType:self.type handler:^{
            NSLog(@"pulltorefresh handler was called = )");
            [self reloadDates];
        }];
    }
    
    if (self.isPullToRefreshBottomEnabled) {
        [self.tableView cr_addBottomPullToRefreshWithType:self.type handler:^{
            NSLog(@"bottom pulltorefresh handler was called = )");
            [self loadDates];
        }];
    }
    
}

- (void)configureInfiteScroll {
    if ( self.isInfiniteScrollBottomEnabled ) {
        [self.tableView cr_addInfiniteRefreshWithType:self.type handler:^{
            NSLog(@"bottom infinite scroll handler was called = )");
            [self loadDates];
        }];
    }
    
}

- (void)applySettings {

    self.automaticallyAdjustsScrollViewInsets = self.internalAdjustScrollView;
    self.edgesForExtendedLayout = self.rectEdge;
    
}

#pragma mark Private Case

- (void)configureVideoRefresher {
    
    // getting video url from current bundle
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *videoURL = [bundle URLForResource:@"FakeVideo" withExtension:@"mp4"];
    
    // create animation for video
    CRRefreshVideoAnimation *animation = [CRRefreshVideoAnimation animation];
    [animation setupVideo:videoURL];
    
//    CRRefreshHandler handler = ^ {
//        NSLog(@"Big Simba was called^^");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.durationOfFakeRequest * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView cr_stopRefresh];
//        });
//    };
    
    
//    // add refresher with handler and video animation = )
//    if  (self.isTopEnabled) {
//        [self.tableView cr_addPullToRefreshWithHandler:handler animation:animation];
//    }
//    
//    if (self.isBottomEnabled) {
//        [self.tableView cr_addInfiniteRefreshWithHandler:handler animation:animation];
//    }
}


@end

