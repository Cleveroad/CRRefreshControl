//
//  CRSettingsViewController.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 2/17/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRSettingsViewController.h"
#import "CRAnimationShowViewController.h"

static const NSTimeInterval kMaxDurationFakeRequest = 60.0;
static const NSTimeInterval kMinDurationFakeRequest = 2.0;


@interface CRSettingsViewController ()

// UI elements
@property (weak, nonatomic) IBOutlet UIButton *positionButton;
@property (weak, nonatomic) IBOutlet UIButton *infiniteScrollPositionButton;
@property (weak, nonatomic) IBOutlet UIButton *rectEdgeButton;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;

// internal elements
@property (copy, nonatomic) NSArray <NSString *>*positionNames;
@property (copy, nonatomic) NSArray <NSString *>*rectEdgeNames;

// elements for send
@property (assign, nonatomic) UIRectEdge rectEdge;
@property (assign, nonatomic) BOOL isInfiniteScrollTopEnabled;
@property (assign, nonatomic) BOOL isInfiniteScrollBottomEnabled;

@property (assign, nonatomic) BOOL isPullToRefreshTopEnabled;
@property (assign, nonatomic) BOOL isPullToRefreshBottomEnabled;

@property (assign, nonatomic) NSTimeInterval durationFakeRequest;

@end

@implementation CRSettingsViewController



#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rectEdge = UIRectEdgeAll;
    self.isPullToRefreshTopEnabled    = YES;
    self.isPullToRefreshBottomEnabled = NO;
    
    self.isInfiniteScrollTopEnabled     = NO;
    self.isInfiniteScrollBottomEnabled  = YES;
    
    self.durationFakeRequest = kMinDurationFakeRequest;
    self.positionNames = @[@"Top", @"Bottom", @"Top | Bottom", @"None"];
    
    self.rectEdgeNames = @[@"UIRectEdgeNone",
                           @"UIRectEdgeTop",
                           @"UIRectEdgeLeft",
                           @"UIRectEdgeBottom",
                           @"UIRectEdgeRight",
                           @"UIRectEdgeAll"];
    
    [self updatePosition];
    [self updateInfiniteScrollPosition];
    [self updateRectEdgeAtTitleIndex:self.rectEdgeNames.count - 1];
    [self updateDuration];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CRAnimationShowViewController class]]) {
        
        [self configureAnimationShowViewController:segue.destinationViewController];
     
    } else if ([segue.destinationViewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabBarController = (UITabBarController*)segue.destinationViewController;
        tabBarController.edgesForExtendedLayout = self.rectEdge;
        tabBarController.automaticallyAdjustsScrollViewInsets = self.switcher.on;
        
        for (__kindof UIViewController *viewController in tabBarController.viewControllers) {
            if ([viewController isKindOfClass:[CRAnimationShowViewController class]]){
                
                [self configureAnimationShowViewController:viewController];
            }
        }
    }
}

- (void)configureAnimationShowViewController:(CRAnimationShowViewController *)viewController {
    viewController.type            = self.type;
    viewController.rectEdge        = self.rectEdge;
    
    viewController.isPullToRefreshTopEnabled    = self.isPullToRefreshTopEnabled;
    viewController.isPullToRefreshBottomEnabled = self.isPullToRefreshBottomEnabled;
    
    viewController.isInfiniteScrollTopEnabled       = self.isInfiniteScrollTopEnabled;
    viewController.isInfiniteScrollBottomEnabled    = self.isInfiniteScrollBottomEnabled;
    
    viewController.internalAdjustScrollView = self.switcher.on;
    viewController.durationOfFakeRequest    = self.durationFakeRequest;
}



#pragma mark - Actions

- (IBAction)positionButtonTapped:(UIButton *)sender {
    if (self.isPullToRefreshTopEnabled && self.isPullToRefreshBottomEnabled) {
        self.isPullToRefreshTopEnabled    = YES;
        self.isPullToRefreshBottomEnabled = NO;
        
    } else if (self.isPullToRefreshTopEnabled) {
        self.isPullToRefreshTopEnabled    = NO;
        self.isPullToRefreshBottomEnabled = YES;
        
    } else {
        self.isPullToRefreshTopEnabled    = YES;
        self.isPullToRefreshBottomEnabled = YES;
    }
    
    
    [self updatePosition];
    
}

- (IBAction)bottomPositionTapped:(UIButton *)sender {
    if (self.isInfiniteScrollTopEnabled && self.isInfiniteScrollBottomEnabled) {
        self.isInfiniteScrollTopEnabled    = YES;
        self.isInfiniteScrollBottomEnabled = NO;
        
    } else if (self.isInfiniteScrollTopEnabled) {
        self.isInfiniteScrollTopEnabled    = NO;
        self.isInfiniteScrollBottomEnabled = YES;
        
    } else {
        self.isInfiniteScrollTopEnabled    = YES;
        self.isInfiniteScrollBottomEnabled = YES;
    }
    
    
    [self updateInfiniteScrollPosition];
}

- (IBAction)rectEdgeButtonTapped:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *title in self.rectEdgeNames) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           NSUInteger index = [alertController.actions indexOfObject:action];
                                                           [self updateRectEdgeAtTitleIndex:index];
        }];
        
        [alertController addAction:action];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)plusTapped:(UIButton *)sender {
    if (self.durationFakeRequest++ > kMaxDurationFakeRequest){
        self.durationFakeRequest = kMaxDurationFakeRequest;
    }
    [self updateDuration];
}

- (IBAction)minusTapped:(UIButton *)sender {
    if (--self.durationFakeRequest < kMinDurationFakeRequest) {
        self.durationFakeRequest = kMinDurationFakeRequest;
    }
    [self updateDuration];
}



#pragma mark - Private Methods

- (void)updatePosition {
    NSUInteger index;
    
    if (self.isPullToRefreshTopEnabled) {
        if (self.isPullToRefreshBottomEnabled) {
            index = 2;
            
        } else {
            index = 0;
            
        }
        
    } else {
        index = 1;
    }
    
    NSString *title = self.positionNames[index];
    
    [self.positionButton setTitle:title forState:UIControlStateNormal];
}

- (void)updateInfiniteScrollPosition {
    NSUInteger index;
    
    if (self.isInfiniteScrollTopEnabled) {
        if (self.isInfiniteScrollBottomEnabled) {
            index = 2;
            
        } else {
            index = 0;
            
        }
        
    } else {
        index = 1;
    }
    
    NSString *title = self.positionNames[index];
    
    [self.infiniteScrollPositionButton setTitle:title forState:UIControlStateNormal];
}

- (void)updateRectEdgeAtTitleIndex:(NSUInteger)index {
    
    [self.rectEdgeButton setTitle:self.rectEdgeNames[index]
                         forState:UIControlStateNormal];
    UIRectEdge rectEdge;
    if (index == 0) {
        rectEdge = UIRectEdgeNone;
        
    } else if (index == self.rectEdgeNames.count - 1) {
        rectEdge = UIRectEdgeAll;
        
    } else {
        rectEdge = (UIRectEdge)(1 << index);
    }
    
    self.rectEdge = rectEdge;
}

- (void)updateDuration {
    self.durationLabel.text = [NSString stringWithFormat:@"%.f",self.durationFakeRequest];
}



@end
