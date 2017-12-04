//
//  MsgTableView.m
//  MasterKA
//
//  Created by 余伟 on 16/7/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MsgTableView.h"
#import "HobyCell.h"
#import "BindCell.h"

#import "UserMsgModel.h"

#import "CitysModel.h"

#import "MJExtension.h"

#import "MsgCell.h"

#import "GenderCell.h"

#import "BindPhoneController.h"




#define KEYWINDOW  [UIApplication sharedApplication].keyWindow

@interface MsgTableView ()<UITableViewDelegate , UITableViewDataSource,UIPickerViewDataSource , UIPickerViewDelegate>


@end

@implementation MsgTableView
{
    
    NSArray * _images;
    
    NSArray * _strings;
    
    NSArray * _msg;
    
    UIButton * _cancelBtn;
    
    UIButton * _determineBtn;
    
    UIView * _dateView;
    
    UIDatePicker * _datePick;
    
    NSMutableArray * _cityModelArray;
    
    CitysModel * _oldArea;
    
    UIPickerView * _pickView;
    
    NSArray * _citys;
    
    NSIndexPath * _index;
    
    NSString * _birthDay;
    
    NSString * _city;
    
}



-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        
        
        self.delegate =self;
        self.dataSource = self;
        
        
    _images =  @[@"shouji" , @"QQ-0" , @"weixin" , @"weibo"];
    
    _strings = @[@"手机", @"QQ" , @"微信",@"微博"];
    
    _msg = @[@"昵称" , @"性别",@"生日",@"城市"];
    
    _citys =  [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle]pathForResource:@"city.plist" ofType:nil]];
 
    }
    

    
    

    return  self;
    
}



-(void)setUI:(NSIndexPath *)index {
    
    UIView * dateView = [[UIView alloc]init];
    
    dateView.backgroundColor = [UIColor whiteColor];
    
    _dateView = dateView;
    
    
    if (index.row == 2) {
        
        UIDatePicker * datePick = [[UIDatePicker alloc]init];
        
        datePick.datePickerMode = UIDatePickerModeDate;
        
        datePick.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
        
        _datePick = datePick;
        
        
        [dateView addSubview:_datePick];
        
    }else if (index.row == 3) {
        
        
        UIPickerView * pickView = [[UIPickerView alloc]init];
        
        pickView.dataSource = self;
        
        pickView.delegate = self;
        
        _pickView = pickView;
        
        [dateView addSubview:pickView];
    }
    
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _cancelBtn = cancelBtn;
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _determineBtn = determineBtn;
    
    [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [determineBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [determineBtn addTarget:self action:@selector(determineClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [dateView addSubview:cancelBtn];
    
    [dateView addSubview:determineBtn];
    
    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
    
}


-(void)layoutUIWithIndex:(NSIndexPath *)index {
    
    
    
    
    [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(KEYWINDOW.mas_bottom);
        
        make.left.right.mas_equalTo(KEYWINDOW);
        
        make.height.mas_equalTo(@300);
        
    }];
    
    
    if (index.row == 2) {
        
        [_datePick mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(_dateView.mas_bottom);
            
            make.left.right.mas_equalTo(_dateView);
            
            make.height.mas_equalTo(@270);
            
        }];
        
        [_determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_dateView.mas_top);
            
            make.right.mas_equalTo(_dateView.mas_right);
            
            make.width.mas_equalTo(@100);
            
            make.bottom.mas_equalTo(_datePick.mas_top);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_dateView.mas_top);
            
            make.left.mas_equalTo(_datePick.mas_left);
            
            make.width.mas_equalTo(@100);
            
            make.bottom.mas_equalTo(_datePick.mas_top);
        }];
        
    }else if (index.row == 3){
        
        [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(_dateView.mas_bottom);
            
            make.left.right.mas_equalTo(_dateView);
            
            make.height.mas_equalTo(@270);
            
        }];
        
        [_determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_dateView.mas_top);
            
            make.right.mas_equalTo(_pickView.mas_right);
            
            make.width.mas_equalTo(@100);
            
            make.bottom.mas_equalTo(_pickView.mas_top);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(_dateView.mas_top);
            
            make.left.mas_equalTo(_pickView.mas_left);
            
            make.width.mas_equalTo(@100);
            
            make.bottom.mas_equalTo(_pickView.mas_top);
            
        }];
        
        
        
        
    }
    
}




#pragma tableView data source



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            
            return 4 ;
            break;
            
        case 1:
            
            return 1;
            break;
            
        case 2:
            
            return 4 ;
            break;
            
        default:
            
            return 0;
            break;
    }
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = nil;
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            
            MsgCell * msgCell = [tableView dequeueReusableCellWithIdentifier:@"MsgCell"];
      
            cell = msgCell;
            
            msgCell.nike = @"昵称";
            
             UserMsgModel * model = self.data;
            
            msgCell.nameStr = model.nikename;
            
            [self.saveData setValue:model.nikename forKey:@"nickname"];
            
            
            if (self.thirdName !=nil) {
                
                msgCell.nameStr = self.thirdName;
                
                [self.saveData setValue:self.thirdName forKey:@"nickname"];
            }
            
        }else if (indexPath.row == 1) {
            
            
            GenderCell * genderCell = [tableView dequeueReusableCellWithIdentifier:@"GenderCell"];
            
            cell = genderCell;
            
            genderCell.genderStr = @"性别";
            
            
            //默认性别 女
            [self.saveData setValue:@"2" forKey:@"sex"];
            
            __weak typeof (self)weakSelf = self;
            
            [genderCell setSaveGender:^(NSString *genderStr) {
                
                
                [weakSelf.saveData setValue: genderStr forKey:@"sex"];
                
            }];
            
        }
        
        if (indexPath.row > 1) {
            
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            
            if (!cell) {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            }
            
            
            
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@" , _msg[indexPath.row]];
            
            
            
            if (indexPath.row == 2 && _birthDay == nil) {
                
                cell.detailTextLabel.text = @"选择日期";
                
                
            }else if (indexPath.row == 3 && _city == nil){
                
                cell.detailTextLabel.text = @"选择城市";
            }

            
        }
        

        
    }else if (indexPath.section == 1)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"HobyCell"];
        
        HobyCell * hoby = (HobyCell*)cell;
        
        hoby.arr = self.hobys;
        
        __weak typeof (self)weakSelf = self;
        
        [hoby setSaveData:^(NSMutableString * hobyStr) {
            
            [weakSelf.saveData setValue:hobyStr forKey:@"category_id"];
            
            
        }];
        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"BindCell"];
        
        BindCell * bind = (BindCell*)cell;
        
        UserMsgModel * model = self.data;
        
         bind.statueStr = @"未绑定";
        
        if (model.mobile && indexPath.row ==0) {
            
            bind.statueStr = model.mobile;
            
        }else if (self.thirdMethod == UMSocialPlatformType_QQ  && indexPath.row == 1) {
            
            bind.statueStr = @"已绑定";
            
            
        }else if (self.thirdMethod == UMSocialPlatformType_WechatSession && indexPath.row == 2){
            
            bind.statueStr = @"已绑定";
            
        }else if (self.thirdMethod == UMSocialPlatformType_Sina && indexPath.row == 3){
            
            bind.statueStr = @"已绑定";
            
        }
        
        
        bind.iconStr = _strings[indexPath.row];
        
        bind.imageStr = _images[indexPath.row];
        
        
        
        bind.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        

    }
    
    
    
    
    
    return cell;
}




#pragma tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            
            return 10;
            break;
            
        case 1:
            
            return 10;
            break;
        case 2:
            
            return 35;
            break;
            
        default:
            
            return 0;
            break;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 2) {
        
        return @"账号绑定";
        
    }else{
        return @"";
    }
}


-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 1) {
        
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        HobyCell * hoby = (HobyCell *)cell;
        
        NSLog(@"%lf",hoby.cellH);
        
        return hoby.cellH;
        
        
        
    }
    
    
    return 44;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _index = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        
        
        
        
        //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone;
        
        self.userInteractionEnabled = NO;
        
        [self setUI:indexPath];
        
        [self layoutUIWithIndex:indexPath];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            _dateView.transform = CGAffineTransformMakeTranslation(0, -300);
            
            
        }];
        
    }else if (indexPath.section == 0 && indexPath.row == 3){
        
        
        
        
        //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.userInteractionEnabled = NO;
        
        NSMutableArray * cityModelArray = [CitysModel objectArrayWithKeyValuesArray:_citys error:nil];
        
        
        
        _cityModelArray = cityModelArray;
        
        
        [self setUI:indexPath];
        
        [self layoutUIWithIndex:indexPath];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            _dateView.transform = CGAffineTransformMakeTranslation(0, -300);
            
            
        }];
    
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        
        
        
        self.push();
        
        
        
    }else if (indexPath.section == 2 && indexPath.row == 1){
        
        
        self.autho(indexPath.row , indexPath);
        
        
    }else if (indexPath.section == 2 && indexPath.row == 2){
        
         self.autho(indexPath.row , indexPath);
        
    }else if (indexPath.section == 2 && indexPath.row == 3){
        
         self.autho(indexPath.row , indexPath);
        
        
    }
    
    
}




#pragma pickView data source


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    
    return 2;
}



-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        
        return _cityModelArray.count;
    }else{
        
        
        NSInteger index = [pickerView selectedRowInComponent:0];
        
        CitysModel * area = _cityModelArray[index];
        
        _oldArea = area;
        
        return area.cities.count;
        
    }
    
    
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    
    
    if (component == 0) {
        
        
        CitysModel * city = _cityModelArray[row];
        return city.state;
    }else if(component == 1){
        
        return _oldArea.cities[row];
    }else{
        return nil;
    }
    
    
}





#pragma pickView delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        
        [pickerView reloadComponent:1];
    }
    
}


- (void)cancelClick:(UIButton *)sender{
    
    
    [_dateView removeFromSuperview];
    
    self.userInteractionEnabled = YES;
    
    
    
}



-(void)determineClick:(UIButton *)sender {
    
    NSDateFormatter *  formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * time = [formatter stringFromDate:_datePick.date];
    
    UITableViewCell * cell =  [self cellForRowAtIndexPath:_index];
    
    if (time != nil) {
        
        _birthDay = time;
        
        cell.detailTextLabel.text = time;
        
        [self.saveData setValue:time forKey:@"birthday"];
    }
    
    
    if (_pickView !=nil) {
        
        
        NSInteger ProvinceIndex = [_pickView selectedRowInComponent:0];
        
        NSInteger cityIndex = [_pickView selectedRowInComponent:1];
        
        CitysModel * model = _cityModelArray[ProvinceIndex];
        
        _city = model.state;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@" , model.state , model.cities[cityIndex]];
        
        [self.saveData setValue:model.state forKey:@"province"];
        
        [self.saveData setValue:model.cities[cityIndex] forKey:@"city"];
    }
    
    [_dateView removeFromSuperview];
    
    self.userInteractionEnabled = YES;
    
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"  offsec ===== %f",scrollView.contentOffset.y)
    
    
    NSLog(@"  height %f" , scrollView.contentSize.height);
    
    CGFloat sectionHeaderHeight = 60;//设置你footer高度
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        
        
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
        
        
    } else if (scrollView.contentOffset.y>=scrollView.contentSize.height - [UIScreen mainScreen].bounds.size.height) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight*2, 0, 0, 0);
        
        scrollView.contentSize = CGSizeMake(scrollView.width, 730.0f);

      
        if (scrollView.contentSize.height < 730.0) {
            
            scrollView.contentSize =  CGSizeMake(scrollView.width,sectionHeaderHeight + scrollView.contentSize.height);
            
        }
        
       

            //            size = CGSizeMake(scrollView.width,sectionHeaderHeight + scrollView.contentSize.height);

        
    
        
    }
    
}




@end
