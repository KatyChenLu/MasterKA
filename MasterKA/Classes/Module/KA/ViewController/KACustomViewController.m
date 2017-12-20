//
//  KACustomViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/13.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KACustomViewController.h"
#import "BaseTableViewCell.h"
#import "MasterTextfield.h"
#import "MDatePickerView.h"
#import "MStringPickerView.h"
#import "NSDate+BRAdd.h"
#import "KAOrdersViewController.h"

@interface KACustomViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
/**团建时间*/
@property (nonatomic, strong) MasterTextfield *dataTF;
/**团建人数*/
@property (nonatomic, strong) MasterTextfield *numOfPeopleTF;
/**团建时长*/
@property (nonatomic, strong) MasterTextfield *durationTF;
/**人均预算*/
@property (nonatomic, strong) MasterTextfield *budgetTF;
/**是否上门*/
@property (nonatomic, strong) MasterTextfield *visitTF;
/**联系电话*/
@property (nonatomic, strong) MasterTextfield *teleTF;

@property (nonatomic, strong) NSString * customText;

@end

@implementation KACustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"需求定制";
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView clearDefaultStyle];
    [self.dataSource addObject:@""];
    self.mTableView.separatorInset=UIEdgeInsetsMake(0,12, 0, 12);           //top left bottom right 左右边距相同
    self.mTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.addVoteBtn setBackgroundImage:[UIImage imageWithColor:MasterDefaultColor] forState:UIControlStateNormal];
    [self.addVoteBtn setBackgroundImage:[UIImage imageWithColor:RGBFromHexadecimal(0xcdcdcd)] forState:UIControlStateDisabled];
    self.addVoteBtn.enabled = NO;

}
- (IBAction)pushVoteAction:(id)sender {
    BaseTableViewCell *cell = [_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] ];
    UITextView *textview = [cell viewWithTag:100];
    self.customText = textview.text;
  
    RACSignal *fetchSignal1 =   [[HttpManagerCenter sharedHttpManager] addCustomRequirement:self.courseID groupStartTime:self.dataTF.text peopleNum:self.numOfPeopleTF.text groupType:self.visitTF.text courseTime:self.durationTF.text coursePrice:self.budgetTF.text mobile:self.teleTF.text mark:self.customText resultClass:nil];

    @weakify(self)
    [fetchSignal1 subscribeNext:^(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
//           [self toastWithString:model.message error:NO];
             [self toastWithString:@"提交需求成功" error:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                KAOrdersViewController *kaPlaceVC = [[KAOrdersViewController alloc] init];
                kaPlaceVC.isFromCustom = YES;
                [self pushViewController:kaPlaceVC animated:YES];
            });
        }
        
    }completed:^{
       
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableViewCell *cell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier: [NSString stringWithFormat:@"MyMsgCell%ld",indexPath.row]];
    switch (indexPath.row) {
        case 0:{
            if (self.courseID.length) {
                 UILabel *label0 = [cell viewWithTag:10];
                label0.text = self.courseTitle;
                label0.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
                UILabel *label1 = [cell viewWithTag:20];
                NSString *timeStr = [UserClient sharedUserClient].requirement[@"taking_time"];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"定制需求提交后，专业顾问将在%@内联系您",timeStr]];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:RGBFromHexadecimal(0xf33617)
                 
                                      range:NSMakeRange(14, timeStr.length)];
                
                label1.attributedText = AttributedStr;
                
            }else {
                UILabel *label = [cell viewWithTag:10];
                   label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
                NSString *timeStr = [UserClient sharedUserClient].requirement[@"taking_time"];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"定制需求提交后，专业顾问将在%@内联系您",timeStr]];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:RGBFromHexadecimal(0xf33617)
                 
                                      range:NSMakeRange(14, timeStr.length)];
                
                label.attributedText = AttributedStr;
            }
        }
            break;
        case 1:
              [self setupDataTF:cell];
            break;
        case 2:
            [self setupNumOfPeople:cell];
            
            break;
        case 3:
            [self setupDuration:cell];
            break;
        case 4:
            [self setupbudgetTF:cell];
            break;
        case 5:
            [self setvisitTF:cell];
            break;
        case 6:
            [self setupteleTF:cell];
            break;
        case 7:{
            UITextView *textview = [cell viewWithTag:100];
            self.customText = textview.text;
        }
            break;
            
        default:
            break;
    }
    
    
    cell.showCustomLineView = YES;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7) {
        return 225;
    }else if (indexPath.row == 0){
        return 73;
    }
    return 56;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MasterTextfield *)getTextField:(UITableViewCell *)cell{
    MasterTextfield *textField = [[MasterTextfield alloc] initWithFrame:CGRectMake(ScreenWidth - 250, 0, 200, 30)];
    textField.centerY = cell.centerY;
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = RGBFromHexadecimal(0x666666);
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}

- (void)reloadVoteBtnStatus {
    if(_dataTF.text.length &&_numOfPeopleTF.text.length && _durationTF.text.length && _budgetTF.text.length &&_visitTF.text.length && _teleTF.text.length) {
        self.addVoteBtn.enabled = YES;
    }else{
        self.addVoteBtn.enabled = NO;
    }
}

- (void)setupDataTF:(UITableViewCell *)cell {
    if (!_dataTF) {
        _dataTF = [self getTextField:cell];
        _dataTF.returnKeyType = UIReturnKeyDone;
        _dataTF.tag = 0;
        _dataTF.placeholder = [NSDate currentDateStringWithFormat:@"yyyy-MM-dd"];
        @weakify(self);
        _dataTF.tapActionBlock = ^{
            @strongify(self);
            [MDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:self.dataTF.text minDateStr:[NSDate currentDateString] maxDateStr:@"2050-01-01 00:00:00" isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                self.dataTF.text = selectValue;
                [self reloadVoteBtnStatus];
            }];
        };
    }
}

- (void)setupNumOfPeople:(UITableViewCell *)cell {
    if (!_numOfPeopleTF) {
        _numOfPeopleTF = [self getTextField:cell];
        _numOfPeopleTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        NSArray *peopleChooseArr = [UserClient sharedUserClient].requirement[@"people_num"];
        _numOfPeopleTF.tapActionBlock = ^{
            [MStringPickerView showStringPickerWithTitle:@"团建人数" dataSource:peopleChooseArr defaultSelValue:peopleChooseArr[0] isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.numOfPeopleTF.text = selectValue;
                 [weakSelf reloadVoteBtnStatus];
            }];
        };
    }
}

- (void)setupDuration:(UITableViewCell *)cell {
    if (!_durationTF) {
        _durationTF = [self getTextField:cell];
        _durationTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        NSArray *timeChooseArr = [UserClient sharedUserClient].requirement[@"course_time"];
        _durationTF.tapActionBlock = ^{
            [MStringPickerView showStringPickerWithTitle:@"团建时长" dataSource:timeChooseArr defaultSelValue:timeChooseArr[0] isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.durationTF.text = selectValue;
                 [weakSelf reloadVoteBtnStatus];
            }];
        };
    }
}

- (void)setupbudgetTF:(UITableViewCell *)cell{
    if (!_budgetTF) {
        _budgetTF = [self getTextField:cell];
        _budgetTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        NSArray *budgetChooseArr = [UserClient sharedUserClient].requirement[@"course_price"];
        _budgetTF.tapActionBlock = ^{
            [MStringPickerView showStringPickerWithTitle:@"人均预算" dataSource:budgetChooseArr defaultSelValue:budgetChooseArr[0] isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.budgetTF.text = selectValue;
                 [weakSelf reloadVoteBtnStatus];
            }];
        };
    }
}
- (void)setvisitTF:(UITableViewCell *)cell{
    if (!_visitTF) {
        _visitTF = [self getTextField:cell];
        _visitTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
       NSArray *visitChooseArr = [UserClient sharedUserClient].requirement[@"group_type"];
        _visitTF.tapActionBlock = ^{
            [MStringPickerView showStringPickerWithTitle:@"是否上门" dataSource:visitChooseArr defaultSelValue:visitChooseArr[0] isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.visitTF.text = selectValue;
                 [weakSelf reloadVoteBtnStatus];
            }];
        };
    }
}
- (void)setupteleTF:(UITableViewCell *)cell{
    if (!_teleTF) {
        _teleTF = [self getTextField:cell];
        
        _teleTF.placeholder = @"请输入";
        _teleTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _teleTF.returnKeyType = UIReturnKeyDone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:_teleTF];
      
    }
}
- (void)textFieldTextDidChange
{
    [self reloadVoteBtnStatus];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 4) {
        [textField resignFirstResponder];
    }
    return YES;
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
