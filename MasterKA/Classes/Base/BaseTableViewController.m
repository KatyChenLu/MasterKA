//
//  BaseTableViewController.m
//  MasterKA
//
//  Created by jinghao on 16/2/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseTableViewController.h"
#import "TableViewModel.h"
//#import "UserShareViewController.h"

@interface BaseTableViewController ()
@property (nonatomic, weak, readwrite) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readonly) TableViewModel *viewModel;

@end

@implementation BaseTableViewController

- (void)setView:(UIView *)view {
    [super setView:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if ([self isKindOfClass:[UserShareViewController class]] ) {
//        
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
//        [self.navigationItem setLeftBarButtonItem:backItem];
//    }
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
}


- (void)reloadData {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
