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

@interface KACustomViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
/**团建时间*/
@property (nonatomic, strong) MasterTextfield *dataTF;
/**团建人数*/
@property (nonatomic, strong) MasterTextfield *numOfPeopleTF;
/**团建时长*/
@property (nonatomic, strong) MasterTextfield *durationTF;
/**人均预算*/
@property (nonatomic, strong) MasterTextfield *budgetTF;
/**联系电话*/
@property (nonatomic, strong) MasterTextfield *teleTF;
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
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//
//
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
//    NSDictionary *dic = @{NSFontAttributeName:SpecialFont, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
//                          };
//
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"提交定制需求" attributes:dic];
//    self.voteBtn.titleLabel.attributedText = attributeStr;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableViewCell *cell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier: [NSString stringWithFormat:@"MyMsgCell%ld",indexPath.row]];
    switch (indexPath.row) {
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
            [self setupteleTF:cell];
            break;
            
        default:
            break;
    }
    
    
    cell.showCustomLineView = YES;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
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
    MasterTextfield *textField = [[MasterTextfield alloc] initWithFrame:CGRectMake(ScreenWidth - 230, 0, 200, 30)];
    textField.centerY = cell.centerY;
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = RGBFromHexadecimal(0x666666);
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
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
            }];
        };
    }
}

- (void)setupNumOfPeople:(UITableViewCell *)cell {
    if (!_numOfPeopleTF) {
        _numOfPeopleTF = [self getTextField:cell];
        _numOfPeopleTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _numOfPeopleTF.tapActionBlock = ^{
            [MStringPickerView showStringPickerWithTitle:@"团建人数" dataSource:@[@"0~20人", @"20~50人", @"50~100人", @"100人以上"] defaultSelValue:@"0~20人" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.numOfPeopleTF.text = selectValue;
            }];
        };
    }
}

- (void)setupDuration:(UITableViewCell *)cell {
    if (!_durationTF) {
        _durationTF = [self getTextField:cell];
        _durationTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _durationTF.tapActionBlock = ^{
            [MStringPickerView showStringPickerWithTitle:@"团建时长" dataSource:@[@"1小时以内", @"1~3小时", @"1天", @"1天以上"] defaultSelValue:@"1~3小时" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.durationTF.text = selectValue;
            }];
        };
    }
}

- (void)setupbudgetTF:(UITableViewCell *)cell{
    if (!_budgetTF) {
        _budgetTF = [self getTextField:cell];
        _budgetTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _budgetTF.tapActionBlock = ^{
            [MStringPickerView showStringPickerWithTitle:@"人均预算" dataSource:@[@"1~100", @"100~300", @"300~500", @"500以上"] defaultSelValue:@"100~300" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.budgetTF.text = selectValue;
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
    }
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
