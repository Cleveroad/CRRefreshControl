//
//  ViewController.m
//  CRRefrshControl
//
//  Created by Dmitry Pashinskiy on 1/26/16.
//  Copyright © 2016 Cleveroad Inc. All rights reserved.
//

#import "CRViewController.h"
#import "CRSettingsViewController.h"
#import "CRRefreshControl.h"
#import "CRTestAnimation.h"


static NSString * const kCRSettingsSegue = @"CRSettingsSegueID";
static NSString * const kCellIdentifier = @"cellIdentifier";


@interface CRViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <NSString *>*numbers;

@end



@implementation CRViewController



#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numbers = @[@"DefaultAnimation", @"StarAnimation"];
    
//    CRRefreshAnimation *animation = CRRefreshAnimationWithType(CRRefreshType_Star);
    CRTestAnimation *animation = [CRTestAnimation animation];
    [[CRPullToRefresh appearance] setRefreshAnimation:animation];
    
    
    [self.tableView cr_addPullToRefreshWithHandler:^{
        // imitation of loading
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView cr_stopRefresh];
        });
    }];
    
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSUInteger index = [self.tableView indexPathForSelectedRow].row;
    
    if ([segue.identifier isEqualToString:kCRSettingsSegue]) {
        CRSettingsViewController *settingsViewController;
        settingsViewController = (CRSettingsViewController*)segue.destinationViewController;
        
        settingsViewController.type = (CRRefreshType)index;
        
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    cell.textLabel.text = self.numbers[indexPath.row];
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kCRSettingsSegue sender:nil];
}

@end

