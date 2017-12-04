//
//  SelectDetailController.m
//  MasterKA
//
//  Created by hyu on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "SelectDetailController.h"
#import "SelectDetailModel.h"
@interface SelectDetailController ()
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) SelectDetailModel*viewModel;

@end

@implementation SelectDetailController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewModel bindTableView:self.mTableView];
    
    if([self.params[@"identifier"] isEqual:@"store"]){
        
        self.viewModel.course_store = self.params[@"info"][@"course_store"];
        
        self.viewModel.identifier=self.params[@"identifier"];
        
        self.title=@"选择地址";
        
    }else{
        
        if(self.params[@"info"][@"groupby_info"][@"group_price"]!=nil&&[self.params[@"grouptag"]isEqualToString:@"11"]){
            
            for(int i=0;i<[self.params[@"info"][@"course_cfg"]count];i++){
                
                // NSMutableDictionary* dic = self.params[@"info"][@"course_cfg"][i];
                [self.params[@"info"][@"course_cfg"][i] setObject:self.params[@"info"][@"groupby_info"][@"group_price"]forKey:@"groupprice"];
                if(self.params[@"grouptag"]!=nil){
                    [self.params[@"info"][@"course_cfg"][i] setObject:self.params[@"grouptag"] forKey:@"tag"];
                }
            }
            self.viewModel.course_store = self.params[@"info"][@"course_cfg"];
        }
        else{
            for(int i=0;i<[self.params[@"info"][@"course_cfg"]count];i++){
                id object = [self.viewModel.course_store[i]objectForKey:@"tag"];
                if (![object isKindOfClass:[NSNull class]]) {
                    
                    
                    //NSMutableDictionary* dic = self.params[@"info"][@"course_cfg"][i];
                    [self.params[@"info"][@"course_cfg"][i] removeObjectForKey:@"tag"];
                }
                
            }
            self.viewModel.course_store =self.params[@"info"][@"course_cfg"];
            //            else{
            //            self.viewModel.course_store =self.params[@"info"][@"course_cfg"];
            //            }
        }
        self.viewModel.identifier=self.params[@"identifier"];
        self.title=@"选择套餐";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (SelectDetailModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[SelectDetailModel alloc] initWithViewController: self];
    }
    return _viewModel;
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
