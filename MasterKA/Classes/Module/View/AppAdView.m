//
//  AppAdView.m
//  HiGoMaster
//
//  Created by jinghao on 15/12/17.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "AppAdView.h"

@interface AppAdView (){
    NSTimer* cancelTimer;
}
@property (nonatomic,weak)IBOutlet UIButton* cancelButton;
@property (nonatomic,strong)UITapGestureRecognizer* imageTap;
@property (nonatomic,assign)BOOL userCancle;
@end

@implementation AppAdView


- (void)awakeFromNib
{
    [self initViews];
}

- (void)initViews{
    self.maxTimmer = 3;
    self.adImageView.userInteractionEnabled = YES;
    [self.adImageView addGestureRecognizer:self.imageTap];
    [self startCancelTimter];
}

- (UITapGestureRecognizer*)imageTap{
    if (!_imageTap) {
        _imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAdViewController)];
        _imageTap.numberOfTouchesRequired = 1; //手指数
        _imageTap.numberOfTapsRequired = 1; //tap次数
    }
    return _imageTap;
}

- (void)setAdData:(id)adData{
    _adData = adData;
    
}

- (void)setMaxTimmer:(NSInteger)maxTimmer
{
    _maxTimmer = maxTimmer;
    [self.cancelButton setTitle:[NSString stringWithFormat:@"跳过(%ld)",(long)self.maxTimmer] forState:UIControlStateNormal];
}

- (void)startCancelTimter{
    if (cancelTimer==nil) {
        NSTimeInterval timeInterval =1.0 ;
        cancelTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:TRUE];
    }
}

- (void)stopCancelTimter{
    if (cancelTimer) {
        [cancelTimer invalidate];
        cancelTimer = nil;
    }
}

-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    if (_maxTimmer>0) {
        _maxTimmer--;
        [self.cancelButton setTitle:[NSString stringWithFormat:@"跳过(%ld)",(long)_maxTimmer] forState:UIControlStateNormal];
    }else{
        [self dismissAdView:TRUE];
    }
}

- (IBAction)doCancelButton:(id)sender{
    [self dismissAdView:TRUE];
}

- (void)openAdViewController{
    [self dismissAdView:FALSE];
}

- (void)dismissAdView:(BOOL)cancel{
    [self stopCancelTimter];
    self.userCancle = cancel;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (self.userCancle ==FALSE && self.appAdViewBlock) {
            self.appAdViewBlock(self.adData);
        }else if(self.userCancle == true && self.appAdFinishBlock){
            self.appAdFinishBlock();
        }
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
