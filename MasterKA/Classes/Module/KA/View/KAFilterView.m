//
//  KAFilterView.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAFilterView.h"
#import "LeftTitleBtn.h"

//#import "TTRangeSlider.h"
//#import "JLDoubleSlider.h"
//#import "NMRangeSlider.h"
#import "YHSlider.h"

#define fontHightRedColor mHexRGB(0xeb3027) //字体深红色
#define fontHightColor mHexRGB(0x585858) //字体深色
#define fontNomalColor mHexRGB(0x999999) //字体浅色

@interface KAFilterView()<UIGestureRecognizerDelegate>
{
    
    UIButton *starBtn;
    
}

@property (nonatomic, strong)UIView *conditionView;
@property (nonatomic, strong)NSMutableArray *titleBtnArr;

@property (nonatomic, strong) YHSlider *rangeSlider;


@end

@implementation KAFilterView

-(instancetype)initWithFrame:(CGRect)frame withFilerMin:(CGFloat)filerMin filerMax:(CGFloat)filerMax selectMin:(CGFloat)selectMin selectMax:(CGFloat)selectMax sliderArr:(NSArray *)sliderArr{
        if (self = [super initWithFrame:frame]) {
            self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            _conditionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
            _conditionView.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.conditionView];
            [UIView animateWithDuration:0.3 animations:^{
                self.conditionView.frame = CGRectMake(0, 0, ScreenWidth, 150);
            }];
            self.rangeSlider = [[YHSlider alloc] initWithFrame:CGRectMake(20, 19, ScreenWidth-20*2, 62)];

            self.rangeSlider.minmumValue = filerMin ;
            self.rangeSlider.maxmumValue = filerMax ;
            self.rangeSlider.firstValue = selectMin ;
            self.rangeSlider.secondValue = selectMax ;
            self.rangeSlider.firstSliderImg = [UIImage imageNamed:@"sliderBtn"];
            self.rangeSlider.secondSliderImg = [UIImage imageNamed:@"sliderBtn"];
            self.rangeSlider.minimumTrackTintColor = RGBFromHexadecimal(0xd8d8d8);
            self.rangeSlider.maximumTrackTintColor = RGBFromHexadecimal(0xd8d8d8);
            self.rangeSlider.thumbTintColor = RGBFromHexadecimal(0xfed90e);
            
            self.rangeSlider.sliderArr = sliderArr;
            
            [self.conditionView addSubview:self.rangeSlider];
        
            
            
            UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sendBtn.frame =CGRectMake(0, 100, ScreenWidth, 45);
            [sendBtn setTitle:@"完成" forState:UIControlStateNormal];
            [sendBtn setTitleColor:RGBFromHexadecimal(0xfec80e) forState:UIControlStateNormal];
            [sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self.conditionView addSubview:sendBtn];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            
            tap.delegate = self;
            
            [self addGestureRecognizer:tap];

        }
    return self;
}

#pragma UIGestureRecognizerDelegate
- (void)sendBtnAction {
    self.filterSendBlock(self.rangeSlider.firstValue, self.rangeSlider.secondValue);
}
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


@end
