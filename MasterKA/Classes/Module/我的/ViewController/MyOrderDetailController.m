//
//  MyOrderInforMationController.m
//  MasterKA
//
//  Created by hyu on 16/6/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.width == 320) ? YES : NO)
#import "MyOrderDetailController.h"
#import "MyOrderDetailmodel.h"
#import "CommonSelectViewController.h"
#import "GoodDetailViewController.h"
@interface MyOrderDetailController ()<UIGestureRecognizerDelegate,redPacketDelegate>
{
    UILabel* oneLabel;
    UILabel* twoLabel;
    UILabel* threeLabel;
    UIButton* lastBtnView;
    UIView* whiteView;
    UIButton* weixinBtn;
    UIButton* shareGroupBtn;
    UIButton* cancelbtn;
    UIView* backgroudView;
    UIButton* smallRedPack;
    BOOL isRedexit;
}
@property (nonatomic,strong) MyOrderDetailmodel * viewModel;
@property (nonatomic,strong) NSMutableArray * reasonDataSource;
@property (nonatomic,strong) NSString * refuseOrderReason;
@property (nonatomic,strong) UIImageView* redBtn;
@property (nonatomic,strong) UIButton* sendredBtn;
@end

@implementation MyOrderDetailController

@synthesize viewModel = _viewModel;
@synthesize mTableView = _mTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.title = @"订单详情";
    [self.viewModel bindTableView:self.mTableView];
    [self.mTableView.mj_header beginRefreshing];
    [self createSmallred];
    [self createBackview];
    [self createShareView];
    self.isfromCode =self.params[@"isfrom"];
    if([self.isfromCode isEqualToString:@"1"])
    {
        self.viewModel.fromCode = @"1";
        self.viewModel.mainOrderId =self.params[@"oid"];
        self.viewModel.orderId = @"";
        //self.isfromCode =@"2";
        backgroudView.hidden = NO;
    }
    else{
        self.viewModel.orderId=self.params[@"oid"];
        self.viewModel.mainOrderId=@"";
        backgroudView.hidden = YES;
    }
    //    self.viewModel.curPage = @(1);
    //去掉tableView多余的横线
    //    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    self.mTableView.separatorInset=UIEdgeInsetsMake(0,0, 0, 0);//top left bottom right
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoBack{
    if([self.isfromCode isEqualToString:@"1"]){
        [self gotoBack:YES viewControllerName:@"GoodDetailViewController"];
    }
    else{
        [self.searchTitleView resignFirstResponder];
        if ([self canGotoBack]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)createBackview{
    backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backgroudView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7f];
    [self.view addSubview:backgroudView];
}

-(void)createSmallred{
    smallRedPack = [[UIButton alloc]init];
    [smallRedPack setImage:[UIImage imageNamed:@"ling"] forState:UIControlStateNormal];
    [smallRedPack addTarget:self action:@selector(jumpfromRedPack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:smallRedPack];
    [smallRedPack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-7);
        make.bottom.equalTo(self.view).with.offset(-25);
        make.width.mas_equalTo(135/3);
        make.height.mas_equalTo(159/3);
    }];
    smallRedPack.hidden = YES;
}

-(void)DotoShowRedPaket{
    [self createRed];
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.25*NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        NSLog(@"3秒后添加到队列");
//        
//        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        animation1.duration = 0.8;
//        animation1.repeatCount = 1;
//        animation1.autoreverses = NO;
//        
//        animation1.fromValue = [NSNumber numberWithFloat:0.01];
//        animation1.toValue = [NSNumber numberWithFloat:1];
//        
//        [lastBtnView.layer addAnimation:animation1 forKey:@"scale-layer"];
//        CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
//        animation.duration=0.8f;
//        animation.removedOnCompletion = NO;
//        animation.autoreverses = NO;
//        animation.fillMode = kCAFillModeForwards;
//        animation.repeatCount=1;// repeat forever
//        animation.calculationMode = kCAAnimationCubicPaced;
//        
//        CGMutablePathRef curvedPath = CGPathCreateMutable();
//        CGPathMoveToPoint(curvedPath, NULL, self.view.size.width-7-135/6, self.view.size.height-25-159/6);
//        //        CGPathAddQuadCurveToPoint(curvedPath, NULL, self.view.size.width,-self.view.size.height,self.view.size.width/2, 30);
//        CGPathAddQuadCurveToPoint(curvedPath, NULL, self.view.size.width+60,-60,self.view.size.width/2, 30);
//        CGPathAddQuadCurveToPoint(curvedPath, NULL, -self.view.size.width/2,300,7+135/6, self.view.size.height-25-159/6);
//        CGPathAddQuadCurveToPoint(curvedPath, NULL, self.view.size.width-7-135/6,self.view.size.height-25-159/6,self.view.size.width/2, self.view.size.height/2);
//        
//        animation.path=curvedPath;
//        [lastBtnView.layer addAnimation:animation forKey:nil];
//        
////        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
////        animation2.duration = 0.8;
////        animation2.repeatCount = 1;
////        animation2.removedOnCompletion = NO;
////        animation2.fromValue = [NSNumber numberWithFloat:0.0];
////        animation2.toValue = [NSNumber numberWithFloat:6 * M_PI];
////        [lastBtnView.layer addAnimation:animation2 forKey:nil];
//    });
//    
//    dispatch_time_t time2 = dispatch_time(DISPATCH_TIME_NOW, 1.4*NSEC_PER_SEC);
//    dispatch_after(time2, dispatch_get_main_queue(), ^{
//        lastBtnView.center = CGPointMake(self.view.size.width/2, self.view.size.height/2);
//    });
}

-(void) createShareView{
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.size.height, self.view.size.width, 200)];
    
    whiteView.backgroundColor = RGBFromHexadecimal(0xE2E1E7);
    whiteView.userInteractionEnabled = YES;
    [backgroudView addSubview:whiteView];
    
    UILabel* label = [[UILabel alloc]init];
    label.text = @"分享到";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(whiteView.mas_top).with.offset(6);
        make.height.mas_equalTo(@20);
    }];
    
    weixinBtn = [[UIButton alloc]init];
    weixinBtn.backgroundColor = [UIColor clearColor];
    [weixinBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(shareToweixin) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:weixinBtn];
    
    UILabel* weixinLabel = [[UILabel alloc]init];
    weixinLabel.backgroundColor = [UIColor clearColor];
    weixinLabel.text = @"微信";
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    weixinLabel.font = [UIFont systemFontOfSize:13];
    weixinLabel.textColor = [UIColor blackColor];
    [whiteView addSubview:weixinLabel];
    
    UILabel* pengyouLabel = [[UILabel alloc]init];
    pengyouLabel.backgroundColor = [UIColor clearColor];
    pengyouLabel.text = @"朋友圈";
    pengyouLabel.textAlignment = NSTextAlignmentCenter;
    pengyouLabel.font = [UIFont systemFontOfSize:13];
    pengyouLabel.textColor = [UIColor blackColor];
    [whiteView addSubview:pengyouLabel];
    
    shareGroupBtn = [[UIButton alloc]init];
    shareGroupBtn.backgroundColor = [UIColor clearColor];
    [shareGroupBtn setImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
    [shareGroupBtn addTarget:self action:@selector(shareToPengYou) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:shareGroupBtn];
    
    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView.mas_left).with.offset(86);
        make.top.equalTo(whiteView.mas_top).with.offset(55);
        make.height.width.mas_equalTo(@60);
    }];
    [weixinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weixinBtn);
        make.top.equalTo(weixinBtn.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@20);
    }];
    [shareGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView.mas_right).with.offset(-86);
        make.top.equalTo(whiteView.mas_top).with.offset(55);
        make.height.mas_equalTo(@60);
    }];
    
    [pengyouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(shareGroupBtn);
        make.top.equalTo(shareGroupBtn.mas_bottom).with.offset(5);
        make.height.mas_equalTo(@20);
    }];
    
    cancelbtn = [[UIButton alloc]init];
    cancelbtn.backgroundColor = [UIColor clearColor];
    [cancelbtn setTitle:@"取消分享" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:RGBFromHexadecimal(0x2E76CC) forState:UIControlStateNormal];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelbtn addTarget:self action:@selector(clicktoBackGround) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:cancelbtn];
    
    UIView* line = [[UIView alloc]init];
    line.backgroundColor = RGBFromHexadecimal(0xA9A8AE);
    [whiteView addSubview:line];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(whiteView);
        
        make.height.mas_equalTo(@44);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(whiteView);
        make.bottom.equalTo(whiteView.mas_bottom).with.offset(-44.5);
        make.height.mas_equalTo(@0.5);
    }];
}

-(void)shareToweixin{
   
    [[ShareTool defaultShare] thirdShareWithPlatformType:UMSocialPlatformType_WechatSession title:self.viewModel.fenxiangTitle descr:self.viewModel.desc imageUrl:self.viewModel.imgUrl linkUrl:self.viewModel.link succcess:^(id data) {
        
        NSLog(@"分享成功！");
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)shareToPengYou{

    [[ShareTool defaultShare] thirdShareWithPlatformType:UMSocialPlatformType_WechatTimeLine title:self.viewModel.fenxiangTitle descr:self.viewModel.desc imageUrl:self.viewModel.imgUrl linkUrl:self.viewModel.link  succcess:^(id data) {
        
        NSLog(@"分享成功！");
        
    } fail:^(NSError *error) {
        
    }];
    
}

-(void)redReturnPacket{
    [self.view addSubview:smallRedPack ];
    CAKeyframeAnimation *animation4=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation4.duration=0.5f;
    animation4.removedOnCompletion = NO;
    animation4.autoreverses = NO;
    animation4.fillMode = kCAFillModeForwards;
    animation4.repeatCount=1;// repeat forever
    animation4.calculationMode = kCAAnimationCubicPaced;
    
    CGMutablePathRef curvedPath2 = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath2, NULL, self.view.size.width/2, self.view.size.height/2);
    
    //        CGPathAddQuadCurveToPoint(curvedPath, NULL, self.view.size.width,-self.view.size.height,self.view.size.width/2, 30);
    CGPathAddQuadCurveToPoint(curvedPath2, NULL, self.view.size.width+75,self.view.size.height/2+100,self.view.size.width-7-135/6, self.view.size.height-25-159/6);
    
    // CGPathAddCurveToPoint(curvedPath,NULL,50.0,275.0,150.0,275.0,70.0,120.0);
    
    animation4.path=curvedPath2;
    
    [lastBtnView.layer addAnimation:animation4 forKey:nil];
    CABasicAnimation *animation5 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation5.duration = 0.5;
    animation5.repeatCount = 1;
    animation5.autoreverses = NO;
    
    animation5.fromValue = [NSNumber numberWithFloat:1];
    animation5.toValue = [NSNumber numberWithFloat:0.01];
    animation5.removedOnCompletion = NO;
    animation5.fillMode = kCAFillModeForwards;
    animation5.autoreverses = NO;
    
    [lastBtnView.layer addAnimation:animation5 forKey:@"scale-layer2"];
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation2.duration = 0.5;
    animation2.repeatCount = 1;
    animation2.removedOnCompletion = NO;
    animation2.fromValue = [NSNumber numberWithFloat:0.0];
    animation2.toValue = [NSNumber numberWithFloat:6 * M_PI];
    [lastBtnView.layer addAnimation:animation2 forKey:nil];
}

-(void)createRed{
    isRedexit = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicktoBackGround)];//点击手势
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture setNumberOfTapsRequired:1];
    tapGesture.delegate = self;
    [backgroudView addGestureRecognizer:tapGesture];
    CGFloat x = self.view.size.width - 60;
    CGFloat y = x*1.1;
    lastBtnView = [[UIButton alloc]init];
    lastBtnView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lastBtnView];
    
    self.redBtn = [[UIImageView alloc]init];
    self.redBtn.backgroundColor = [UIColor clearColor];
    [self.redBtn setImage:[UIImage imageNamed:@"logo"]];
    self.redBtn.userInteractionEnabled = YES;
    [lastBtnView addSubview:self.redBtn];
    
//    CGFloat oney = 239*y/650-5;
    
    oneLabel = [[UILabel alloc]init];
    oneLabel.backgroundColor = [UIColor clearColor];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    oneLabel.text = [NSString stringWithFormat:@"可用于购买%@元以上任意正价课程",self.viewModel.limitPrice];
    oneLabel.textColor = RGBFromHexadecimal(0x48473F);
    oneLabel.font = [UIFont systemFontOfSize:IS_IPHONE5==YES?10:12.5];
    [self.redBtn addSubview:oneLabel];
    
    UIImageView* radiusView = [[UIImageView alloc]init];
    [radiusView setImage:[UIImage imageNamed:@"radius"]];
    [self.redBtn addSubview:radiusView];
    
    twoLabel = [[UILabel alloc]init];
    
    twoLabel.backgroundColor = [UIColor clearColor];
    twoLabel.textAlignment = NSTextAlignmentCenter;
    twoLabel.text =  [NSString stringWithFormat:@"仅限%@前使用",self.viewModel.endTime];
    twoLabel.textColor = RGBFromHexadecimal(0xED9100);
    twoLabel.font = [UIFont systemFontOfSize:IS_IPHONE5==YES?9.5:12];
    [radiusView addSubview:twoLabel];
    
    CGFloat tempy1 = 221*y/650;
    
    CGFloat middlewidth = 453*x/591;
    CGFloat leftwidth = 69*x/591+5;
    
    UILabel* aaa = [[UILabel alloc]initWithFrame:CGRectMake(1, tempy1, 0.5, 0.5)];
    aaa.backgroundColor = [UIColor clearColor];
    [self.redBtn addSubview:aaa];
    
    [lastBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(x);
        make.height.mas_equalTo(y);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    [self.redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(lastBtnView);
    }];
    
    CGSize stringSize = [twoLabel.text sizeWithFont:[UIFont systemFontOfSize:IS_IPHONE5==YES?9.5:12]
                                  constrainedToSize:CGSizeMake(middlewidth, 9999)
                                      lineBreakMode:NSLineBreakByTruncatingHead];
    CGFloat twolabwidth = stringSize.width+20;
    CGFloat beHeight = 86*y/650;
    CGFloat onlabelHeight = (beHeight-10)/2;
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aaa.mas_bottom).with.offset(4);
        make.left.equalTo(self.redBtn.mas_left).with.offset(leftwidth);
        make.right.equalTo(self.redBtn.mas_right).with.offset(-leftwidth);
        make.height.mas_equalTo(onlabelHeight);
    }];
    [radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneLabel.mas_bottom).with.offset(2);
        make.centerX.equalTo(self.redBtn.mas_centerX);
        make.width.mas_equalTo(twolabwidth);
        make.height.mas_equalTo(onlabelHeight);
    }];
    
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(radiusView);
    }];
    
    CGFloat daiJinleft = 305*x/591;
    CGFloat daijinBottom = 361*y/650;
    UIView* daiJinLine = [[UIView alloc]initWithFrame:CGRectMake(daiJinleft+5, 1, 0.5, 0.5)];
    daiJinLine.backgroundColor = [UIColor clearColor];
    [self.redBtn addSubview:daiJinLine];
    
    UIView* daiJinbotomLine = [[UIView alloc]initWithFrame:CGRectMake(10, daijinBottom+2, 0.5, 0.5)];
    daiJinbotomLine.backgroundColor = [UIColor clearColor];
    [self.redBtn addSubview:daiJinbotomLine];
    
    UILabel* daiJinLabel = [[UILabel alloc]init];
    daiJinLabel.backgroundColor = [UIColor clearColor];
    daiJinLabel.textAlignment = NSTextAlignmentRight;
    [daiJinLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:IS_IPHONE5==YES?23:26]];
    
    daiJinLabel.text = [NSString stringWithFormat:@"%@元",self.viewModel.redPrice];
    daiJinLabel.textColor = RGBFromHexadecimal(0xE63123);
    [self.redBtn addSubview:daiJinLabel];
    
    [daiJinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(radiusView.mas_bottom).with.offset(7);
        make.right.equalTo(daiJinLine.mas_left).with.offset(-1);
        make.bottom.equalTo(daiJinbotomLine.mas_top).with.offset(-0.5);
        make.left.equalTo(oneLabel.mas_left).with.offset(1);
    }];
    
    self.sendredBtn = [[UIButton alloc]init];
    [self.sendredBtn setBackgroundColor:[UIColor clearColor]];
    
    [self.sendredBtn addTarget:self action:@selector(clickToshare) forControlEvents:UIControlEventTouchUpInside];
    [self.redBtn addSubview:self.sendredBtn];
    CGFloat redBotom = y*18/650;
    CGFloat sendHeight = y*91/650;
    [self.sendredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.redBtn.mas_bottom).with.offset(-redBotom);
        make.left.equalTo(self.redBtn.mas_left).with.offset(15);
        make.right.equalTo(self.redBtn.mas_right).with.offset(-15);
        make.height.mas_equalTo(sendHeight);
    }];
   // [self createShareView];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:lastBtnView]||[touch.view isDescendantOfView:whiteView]) {
        return NO;
    }
    return YES;
}

-(void)clickToshare{
    smallRedPack.userInteractionEnabled = NO;
    isRedexit = NO;
    [self redReturnPacket];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [lastBtnView removeFromSuperview];
        lastBtnView = nil;
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation1.duration = 0.3;
        animation1.repeatCount = 1;
        animation1.autoreverses = YES;
        animation1.fromValue = [NSNumber numberWithFloat:1];
        animation1.toValue = [NSNumber numberWithFloat:1.4];
        
        [smallRedPack.layer addAnimation:animation1 forKey:@"scale-layer5"];
    });
    dispatch_time_t time3 = dispatch_time(DISPATCH_TIME_NOW, 1.4*NSEC_PER_SEC);
    dispatch_after(time3, dispatch_get_main_queue(), ^{
        //        [lastBtnView removeFromSuperview];
        //        lastBtnView = nil;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if(whiteView!=nil){
                [self.view addSubview:whiteView];
                whiteView.frame = CGRectOffset(whiteView.frame, 0, -264);
            }
        } completion:^(BOOL finished) {
            //smallRedPack.userInteractionEnabled = NO;
            // [self.view insertSubview:smallRedPack belowSubview:whiteView];
        }];
    });
}
-(void)clicktoBackGround{
    smallRedPack.userInteractionEnabled = YES;
    if(isRedexit == YES){
        isRedexit = NO;
        
        [self redReturnPacket];
        backgroudView.hidden = YES;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8*NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [lastBtnView removeFromSuperview];
            lastBtnView = nil;
            CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animation1.duration = 0.3;
            animation1.repeatCount = 1;
            animation1.autoreverses = YES;
            animation1.fromValue = [NSNumber numberWithFloat:1];
            animation1.toValue = [NSNumber numberWithFloat:1.4];
            
            [smallRedPack.layer addAnimation:animation1 forKey:@"scale-layer5"];
        });
    }
    else{
        backgroudView.hidden = YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if(whiteView!=nil){
                [self.view addSubview:whiteView];
                whiteView.frame = CGRectOffset(whiteView.frame, 0, 264);
            }
        } completion:^(BOOL finished) {
            //            smallRedPack.userInteractionEnabled = NO;
            //             [self.view insertSubview:smallRedPack belowSubview:whiteView];
        }];
    }
}

-(void)jumpfromRedPack{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if(whiteView!=nil){
            [self.view addSubview:whiteView];
            backgroudView.hidden = NO;
            whiteView.frame = CGRectOffset(whiteView.frame, 0, -264);
        }
    } completion:^(BOOL finished) {
    }];
}

-(void)hideBackGroudview{
    if(backgroudView !=nil){ backgroudView.hidden =YES;}
    if(smallRedPack!=nil) {smallRedPack.hidden = YES;}
}

-(void)showSmallred{
    smallRedPack.hidden = NO;
}
#pragma mark -- getter and setter

- (MyOrderDetailmodel*)viewModel{
    if (_viewModel==nil) {
        _viewModel = [[MyOrderDetailmodel alloc] initWithViewController:self];
        _viewModel.delegate = self;
    }
    return _viewModel;
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
