//
//  CommonSelectViewController.m
//  HiGoMaster
//
//  Created by jinghao on 15/9/10.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "CommonSelectViewController.h"

@interface CommonSelectViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,weak)IBOutlet UIButton* cancleButton;
@property (nonatomic,weak)IBOutlet UIButton* sureButton;
@property (nonatomic,weak)IBOutlet UILabel* titleView;
@property (nonatomic,weak)IBOutlet UIPickerView* mPickerView;

@property (nonatomic,strong)NSMutableArray* dataSource;
@property (nonatomic,strong)dispatch_block_t cancelBlock;
@property (nonatomic,strong)dispatch_block_t sureBlock;
@property (nonatomic,assign)NSInteger tempSelectIndex;
@end

@implementation CommonSelectViewController


+ (CommonSelectViewController*)initCommonSelectViewController{
    return [[CommonSelectViewController alloc] initWithNibName:@"CommonSelectViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefatulTitle];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray*)dataSource
{
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setSelectTextArray:(NSArray *)selectTextArray
{
    _selectTextArray = selectTextArray;
    [self.dataSource removeAllObjects];
    if (selectTextArray) {
        [_dataSource addObjectsFromArray:selectTextArray];
        [self.mPickerView reloadAllComponents];
    }
}

- (IBAction)doCancleButton:(id)sender{
    [self dismissPopController];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)doSureButton:(id)sender{
    self.selectIndex = self.tempSelectIndex;
    [self dismissPopController];
    if (self.sureBlock) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.sureBlock();
        });
    }
}

- (void)setDefatulTitle{
    self.titleView.text = self.title;
    if (self.title==nil || self.title.length==0) {
        if(self.navigationItem){
            self.titleView.text=self.navigationItem.title;
        }
    }
}

- (void)popViewControllerIn:(UIViewController *)poppedVC{
    [poppedVC popViewControllerWithMask:self animated:TRUE setEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)popViewControllerIn:(UIViewController *)poppedVC cancelBlock:(void (^)(void))cancelBlock sureBlock:(void (^)(void))sureBlock
{
    
    self.cancelBlock = cancelBlock;
    self.sureBlock = sureBlock;
    
    [poppedVC popViewControllerWithMask:self animated:TRUE setEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}
- (void)dismissPopController{
    [self dismissPopControllerWithMaskAnimated:TRUE];
}


#pragma mark -- UIPickerViewDataSource,UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataSource.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _dataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.tempSelectIndex = row;
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
