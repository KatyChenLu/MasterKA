//
//  MsgTableViewController.m
//  HiMaster3
//
//  Created by hyu on 16/7/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MsgTableViewController.h"
#import "HttpManagerCenter+User.h"
#import "BaseModel.h"
#import "Masonry.h"


@interface MsgTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nikeName;
@property (weak, nonatomic) IBOutlet UISwitch *genderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLab;

@property (weak, nonatomic) IBOutlet UILabel *cityLab;





@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UILabel *qqLab;

@property (weak, nonatomic) IBOutlet UILabel *weixinLab;

@property (weak, nonatomic) IBOutlet UILabel *sinlangLab;
@end

@implementation MsgTableViewController
{
    UIDatePicker * _datePick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gerenziliao-jiaotou"] style:UIBarButtonItemStylePlain target:self action:@selector(popVC:)];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
  
    
    [self setBtn];
   
    
    [self loadData];
    
}

-(void)setBtn{
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    saveBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
    
    saveBtn.backgroundColor = masterDefaultColor;
    
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [saveBtn addTarget: self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = saveBtn;
    
}

- (void)loadData {
    
    
    
    NSDictionary * dic =  self.data;
    
    self.nikeName.text = dic[@"nikename"];
    
    self.phoneNum.text = dic[@"mobile"];
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"didSelectRowAtIndexPath");

    
    UIView * dateView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 300)];//216
    
    
    UIDatePicker * datePick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
    
    _datePick = datePick;
    datePick.backgroundColor = [UIColor lightGrayColor];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    

    
    UIButton * trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
    [dateView addSubview:cancelBtn];
    [dateView addSubview:trueBtn];
    
    
    [dateView addSubview:datePick];
    
    [[UIApplication sharedApplication].keyWindow addSubview:dateView];

}




- (IBAction)rightItemClick:(id)sender {
    
    
    
}

//导航leftItemClick
-(void)popVC:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//保存按钮
-(void)saveBtnClick:(UIButton *)sender {
    
    
    
}



@end
