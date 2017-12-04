//
//  HobyViewController.m
//  MasterKA
//
//  Created by 余伟 on 16/12/8.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HobyViewController.h"
#import "HobyCollectionViewCell.h"
#import "HobyView.h"
#import "HttpManagerCenter+StartApp.h"
#import "StartSubCategoryModel.h"
#import "UserHobyBtn.h"


@interface HobyViewController ()

@property(nonatomic ,strong)NSMutableArray * hobys;

@end

@implementation HobyViewController
{
    HobyView * _hobyView;
    
}


-(NSMutableArray *)hobys
{
    if (!_hobys) {
        
        _hobys = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _hobys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    bgView.backgroundColor = [UIColor colorWithHex:0xf8f8f5];
    
    
    UILabel * hobyLabel = [[UILabel alloc]init];
    
    if (IsPhoneX) {
        hobyLabel.frame = CGRectMake(0, 44, ScreenWidth, 80-44);
    }else{
          hobyLabel.frame = CGRectMake(0, 0, ScreenWidth, 80);
    }
    
    [bgView addSubview:hobyLabel];
  
    
    hobyLabel.textAlignment = NSTextAlignmentCenter;
    
    hobyLabel.text = @"喜欢什么爱好?";
    
    hobyLabel.backgroundColor = [UIColor colorWithHex:0xf8f8f5];
    
    [self.view addSubview:bgView];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];

    _hobyView = [[HobyView alloc]initWithFrame:CGRectMake(0, 80, self.view.width, self.view.height-130) collectionViewLayout:flowLayout];
    
    _hobyView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_hobyView];
    
     [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    UIButton * selectHobyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    selectHobyBtn.frame      = CGRectMake(0, self.view.height-50, self.view.width, 50);
    [self.view addSubview:selectHobyBtn];
    [selectHobyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    selectHobyBtn.backgroundColor = [UIColor lightGrayColor];
    [selectHobyBtn setTitle:@"选择你喜欢玩的(多选)" forState:UIControlStateNormal];
    
    [selectHobyBtn addTarget: self action:@selector(gotoMainViewController:) forControlEvents:UIControlEventTouchUpInside];
    selectHobyBtn.backgroundColor = [UIColor colorWithHex:0xf8f8f5];
    [selectHobyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    

    
    [_hobyView setSelectbtnEnable:^(UserHobyBtn * sender) {

        
    
        
        
        if (sender.selected) {
            
            
            [self.hobys addObject:[[sender hoby]pid]];
            
            NSLog(@"addObject-----%ld" , self.hobys.count);
        }else
        {
            
            //if ([self.hobys containsObject:[[sender hoby]pid]]) {
                
                //NSInteger  index = [self.hobys  indexOfObject:[[sender hoby]pid]];
                
              //  [self.hobys removeObjectAtIndex:index];
                
           //}
            
            [self.hobys removeObject:[[sender hoby]pid]];
            
            NSLog(@"removeObject----%ld" , self.hobys.count);
            
            
            
        }
        
        
        if (self.hobys.count) {
            
            selectHobyBtn.enabled = YES;
            
            [selectHobyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [selectHobyBtn setTitle:@"保存我的选择" forState:UIControlStateNormal];
            selectHobyBtn.backgroundColor = MasterDefaultColor;
        }else
        {
            selectHobyBtn.enabled = NO;
            
            selectHobyBtn.backgroundColor = [UIColor colorWithHex:0xf8f8f5];
            [selectHobyBtn setTitle:@"选择你喜欢玩的(多选)" forState:UIControlStateNormal];
            
        }
        
 
    }];
    
    [self initRemote];
    
}

- (void)gotoMainViewController:(id)sender{
    [SharedAppDelegate openAppMainVCT];
    
    RACSignal * signal = [[HttpManagerCenter sharedHttpManager]bindCategorys:self.hobys WithUserResultClass:nil];
    
    [signal subscribeNext:^(BaseModel * model) {
        
        
        if (model.code == 200) {
            
            
        }else
        {
            
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"绑定失败" message:nil
//                                   
//                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//         
//            [alert show];
            
        }
       
        
    }];
    
    
}



-(void)initRemote
{
    RACSignal * signal = [[HttpManagerCenter sharedHttpManager]getSubCategoryResultClass:[StartSubCategoryModel class]];
                          
    [signal subscribeNext:^(BaseModel *model) {
       
        if (model.code == 200) {
            
            
            _hobyView.model = model.data;
            
            NSLog(@"%@" , model.data);
            
            
        }
        
        
        
    }];
    
    
    
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
