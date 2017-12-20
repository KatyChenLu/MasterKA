//
//  ChooseCityController.m
//  HiMaster3
//
//  Created by chenlu on 17/12/5.
//  Copyright © 2016年 chenlu. All rights reserved.
//

#import "ChooseCityController.h"

#import "CityTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define ChooseCityCellHeight 200

@interface ChooseCityController ()<UITableViewDelegate ,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;

@end

@implementation ChooseCityController
{
    RLMResults * _arr;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"选择城市";
    
    if (IsPhoneX) {
        self.titleHeight.constant = 88;
    }
    
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[CityTableViewCell class] forCellReuseIdentifier:@"CityTableViewCell"];
    
    RLMResults *categoryResult = [CityModel allObjects];
    
    if (categoryResult.count == 0) {
        DBHelper *dbHelper = [DBHelper sharedDBHelper];
        [dbHelper deleteClass:[CityModel class]];
        NSArray *citysArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityJson" ofType:@"plist"]];
        for (int i = 0; i<citysArr.count; i++) {
            CityModel *model = [[CityModel alloc] init];
            NSDictionary *dic = citysArr[i];
            model.city_name = dic[@"city_name"];
            model.city_code = dic[@"city_code"];
            model.alias_name = dic[@"alias_name"];
            model.pingyin = dic[@"pingyin"];
            model.pic_url = dic[@"pic_url"];
            [dbHelper insertModel:model];
        }
         RLMResults *categoryResult = [CityModel allObjects];
         _arr = categoryResult;
        
        
    }else{
        _arr = categoryResult;
    
    }
    
}

#pragma mark ——— UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arr.count+1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CityTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == _arr.count) {
        
        [cell buildMore:@{@"imageName":@"更多-1"}];
        
    }else{
        
//        CityModel * model = _arr[indexPath.row];
        
        CityModel * model = [_arr objectAtIndex:indexPath.row];
        
        cell.model = model;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _arr.count) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    CityTableViewCell  * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell hiddenAddress];
    
    NSString * selectStr = cell.model.alias_name;
    
    if ([[UserClient sharedUserClient].city_name isEqualToString:selectStr]) {
        
    }else{
        
        self.changeCityBlock(cell.model);
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ChooseCityCellHeight;
    
}

#pragma mark ——— event response

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
