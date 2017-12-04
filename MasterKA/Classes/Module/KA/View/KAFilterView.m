//
//  KAFilterView.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAFilterView.h"
#import "LeftTitleBtn.h"
#import "JLDoubleSlider.h"

#define fontHightRedColor mHexRGB(0xeb3027) //字体深红色
#define fontHightColor mHexRGB(0x585858) //字体深色
#define fontNomalColor mHexRGB(0x999999) //字体浅色

@interface KAFilterView()<TTRangeSliderDelegate,UIGestureRecognizerDelegate>
{
    JLDoubleSlider *_slider;
    UIButton *starBtn;
}
/**
 星级选择数组
 */
@property (nonatomic, strong)NSMutableArray *starSelectArr;
@property (nonatomic, strong)UIView *filterTitleView;
@property (nonatomic, strong)UIView *conditionView;
@property (nonatomic, strong)NSMutableArray *titleBtnArr;

@property (nonatomic, strong) TTRangeSlider *rangeSlider;

@end

@implementation KAFilterView
- (instancetype)initWithFrame:(CGRect)frame withType:(filterType)type{
    if (self = [super initWithFrame:frame]) {
        
        [self creatUIWithFilterArr:self.filterArr withType:type];
    }
    return self;
}

- (NSMutableArray *)filterArr {
    if (!_filterArr) {
        
        NSArray* arr = @[@{@"title":@"不限",@"value":@""},
                         @{@"title":@"¥ 0~99",@"value":@"1"},
                         @{@"title":@"¥ 99~199",@"value":@"2"},
                         @{@"title":@"¥ 199~929",@"value":@"3"},
                         @{@"title":@"¥ 299~399",@"value":@"4"},
                         ];
        _filterArr =[[NSMutableArray alloc]initWithArray:arr];
    }
    return _filterArr;
}

- (void)creatUIWithFilterArr:(NSArray *)filterArr withType:(filterType)type{
    //
//    self.titleBtnArr = [[NSMutableArray alloc] initWithCapacity:3];
    _conditionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    _conditionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.conditionView];
 
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.conditionView.frame = CGRectMake(0, 0, ScreenWidth, 150);
        
 
    }];
    
    if (type == jampanFilter) {
        
            _slider = [[JLDoubleSlider alloc]initWithFrame:CGRectMake(19, 50, ScreenWidth- 38, 50)];
            _slider.unit = @"￥";
            _slider.minNum = 10;
            _slider.maxNum = 400;
            _slider.minTintColor = RGBFromHexadecimal(0xd8d8d8);
        _slider.maxTintColor = RGBFromHexadecimal(0xd8d8d8);
        _slider.mainTintColor = RGBFromHexadecimal(0xefd90e);
        
            [self.conditionView addSubview:_slider];
    }else if(type == optionFilter){
        int totalloc =3;
        CGFloat btnVH = 30; //高
        CGFloat margin = 30; //间距
        
        CGFloat btnVW = (ScreenWidth-margin*(totalloc+1))/totalloc; //宽
        
        int count =(int)filterArr.count;
        for (int i=0;i<count;i++){
            int row =i/totalloc;  //行号
            int loc =i%totalloc;  //列号
            CGFloat btnVX =margin+(margin +btnVW)*loc;
            CGFloat btnVY =40+(margin +btnVH)*row;
            
            starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            starBtn.frame = CGRectMake(btnVX, btnVY, btnVW, btnVH);
            [starBtn setTitle:[NSString stringWithFormat:@"%@",filterArr[i][@"title"]] forState:UIControlStateNormal];
            [starBtn setTitleColor:RGBFromHexadecimal(0xeb3027) forState:UIControlStateSelected];
            [starBtn setTitleColor:RGBFromHexadecimal(0x999999) forState:UIControlStateNormal];
            starBtn.titleLabel.font =[UIFont systemFontOfSize:10];
            starBtn.tag=i+100;
            starBtn.layer.cornerRadius=5;
            starBtn.layer.borderColor =[UIColor colorWithWhite:0.6 alpha:1].CGColor;
            starBtn.layer.borderWidth=1;
            [starBtn  addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.conditionView addSubview: starBtn];
        }
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    tap.delegate = self;
    
    [self addGestureRecognizer:tap];
    
}
#pragma UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    
    if ([NSStringFromClass([touch.view class])isEqualToString:NSStringFromClass([self class])]) {
        
            self.conditionView = nil;
             [self removeFromSuperview];
        
        self.touchBlock();
        
        return YES;
    }
    return NO;
}


-(void)tap:(UITapGestureRecognizer *)recognizer
{
    
    
}


/**
 星级btn点击
 
 */
-(void)starBtnClick:(UIButton *)starBtn{
    
    if (starBtn.tag == 100) {
        
        [self.starSelectArr removeAllObjects];
        starBtn.layer.borderColor=RGBFromHexadecimal(0xeb3027).CGColor;
        starBtn.selected = YES;
        
        for ( int i =1; i<5; i++) {
            
            UIButton *button1 = (UIButton *)[self viewWithTag:100+i];
            button1.selected = NO;
            button1.layer.borderColor=[UIColor colorWithWhite:0.6 alpha:1].CGColor;
        }
        
    }
    else
    {
        UIButton *button = (UIButton *)[self viewWithTag:100];
        
        button.selected = NO;
        button.layer.borderColor=[UIColor colorWithWhite:0.6 alpha:1].CGColor;
        
        starBtn.selected = !starBtn.selected;
        
        if (starBtn.selected) {
            
            [self.starSelectArr addObject:self.filterArr[starBtn.tag - 100][@"value"]];
            starBtn.layer.borderColor=RGBFromHexadecimal(0xeb3027).CGColor;
        }else {
            starBtn.layer.borderColor=[UIColor colorWithWhite:0.6 alpha:1].CGColor;
            [self.starSelectArr removeObject:self.filterArr[starBtn.tag - 100][@"value"]];
        }
        
    }
    
//    self.starSelectStr  =[self.starSelectArr componentsJoinedByString:@","];
//    NSLog(@"subStr:%@",self.starSelectStr);
    
//    if (self.sdStarBlock) {
//        self.sdStarBlock (self.starSelectStr);
//    }
    
}


#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
//  if (sender == self.rangeSliderCustom){
//        NSLog(@"Custom slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
//    }
}

@end
