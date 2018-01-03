//
//  ThirdShareView.m
//  MasterKA
//
//  Created by 余伟 on 16/10/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#define SHAREBUTTONWIDTH   ([UIScreen mainScreen].bounds.size.width-1)/4
#define SHAREBUTTONHEIGHT  75
#define MAGIN              1


#import "ThirdShareView.h"
#import "ShareBtn.h"
#import <WXApi.h>

//#import <UMSocialQQHandler.h>

@implementation ThirdShareView
{
    UIView * _bgView;
    NSInteger _shareNum;
    UIView * _shareView;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        
        //蒙板
 
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        [self addGestureRecognizer:tap];
        
          [self addSubview: [self shareView]];
    }
    
    return  self;
}





-(UIView *)shareView
{
    _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-115, [UIScreen mainScreen].bounds.size.width, 115)];
    
    _shareView.backgroundColor = [UIColor colorWithHex:0xf7f7f7];
    
    _shareNum = 2;
    
    if (![WXApi isWXAppInstalled]) {
        
        _shareNum = _shareNum - 2;
        
    }
    
  
    if (_shareNum == 2){
        [self createShareFrom:0 TO:2];
    }else{
//        [self createShareFrom:0 TO:4];
    }
    
    
    UIButton * cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,  _shareView.bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50)];
    
    cancleBtn.borderWidth = 1;
    
    cancleBtn.borderColor = [[UIColor colorWithHex:0xf7f7f7]colorWithAlphaComponent:0.3];
    
    cancleBtn.adjustsImageWhenHighlighted = NO;
    
    [cancleBtn setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:1.0]];
    
    [cancleBtn setTitleColor: [[UIColor colorWithHex:0x757575]colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [cancleBtn addTarget: self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_shareView addSubview:cancleBtn];
 
    return _shareView;
}

- (void)createShareFrom:(int)fromNum TO:(int)toNum{
    
    NSMutableArray * btnArr = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = fromNum ; i < toNum; i++) {
        
        NSInteger orgin = ([UIScreen mainScreen].bounds.size.width-1)/_shareNum;
        
        ShareBtn * shareBtn = [[ShareBtn alloc]initWithFrame:CGRectMake((i- fromNum)*(orgin + MAGIN), 0, orgin, SHAREBUTTONHEIGHT)];
        
        shareBtn.adjustsImageWhenHighlighted = NO;
        
        [shareBtn setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:1.0]];
        
        [shareBtn setTitleColor: [[UIColor blackColor]colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        shareBtn.tag = i ;
        
        
        switch (i) {
            case 0:
                
                [shareBtn setTitle:@"微信好友" forState:UIControlStateNormal];
                
                [shareBtn setImage: [UIImage imageNamed:@"微信好友"] forState:UIControlStateNormal];
                
                break;
                
            case 1:
                
                
                [shareBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
                [shareBtn setImage: [UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
                break;
                
            
                
            default:
                break;
        }
        
        [btnArr addObject:shareBtn];
        
        [_shareView addSubview:shareBtn];
    }
  self.shareBtns = btnArr;
}

-(void)cancelClick:(UIButton *)sender
{
  
    [self cancelAction];
}



-(void)tap:(UIGestureRecognizer *)recognizer
{
    [self cancelAction];
    
}
- (void)cancelAction{
     [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelShare" object:nil];

}



@end
