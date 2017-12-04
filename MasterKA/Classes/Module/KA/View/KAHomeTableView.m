//
//  KAHomeTableView.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAHomeTableView.h"


#import "UITableView+FDTemplateLayoutCell.h"
#import "KAHomeTableViewCell.h"

#import "KADetailViewController.h"


@interface KAHomeTableView ()<UITableViewDelegate, UITableViewDataSource>{
    CALayer     *layer;
    UIImageView *_imageView;
    UIButton    *_btn;
}

@property (nonatomic,strong) UIBezierPath *path;
@end


@implementation KAHomeTableView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if ( self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        
        self.backgroundColor = RGBFromHexadecimal(0xf7f5f6);
        
        self.delegate = self;
        
        self.dataSource = self;
        
//        [self setSeparatorInset:UIEdgeInsetsZero];
        
        [self setSeparatorColor:RGBFromHexadecimal(0xdbdbdb)];
        
        [self registerNib:[UINib nibWithNibName:@"KAHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"KAHomeTableViewCell"];
        
    }
   
    
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [tableView fd_heightForCellWithIdentifier:@"KAHomeTableViewCell" cacheByIndexPath:indexPath configuration:nil];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 37;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    linview.backgroundColor = MasterBackgroundColer;
    [headerView addSubview:linview];
    
    UILabel * showLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 26)];
    showLabel.text = @"热门推荐";
    showLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
    showLabel.textColor = [UIColor blackColor];
    showLabel.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:showLabel];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.kaHomeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KAHomeTableViewCell *kaHomeCell =[tableView dequeueReusableCellWithIdentifier:@"KAHomeTableViewCell" forIndexPath:indexPath];
    kaHomeCell.kaHomeModel = self.kaHomeData[indexPath.row];
    
    
    
    @weakify(self);
    [kaHomeCell setJoinClick:^(UIImageView *joinImgView) {
        @strongify(self);
        
        UIView *view = self.baseVC.navigationController.view;
        CGPoint startPoint = [view convertPoint:joinImgView.center fromView:joinImgView];
        if (!layer) {
            _btn.enabled = NO;
            layer = [CALayer layer];
            layer.contents = (__bridge id)joinImgView.image.CGImage;
            layer.contentsGravity = kCAGravityResizeAspectFill;
            layer.bounds = CGRectMake(0, 0, 50, 50);
            [layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];
            layer.masksToBounds = YES;
            layer.position =startPoint;
       
            [self.window.layer addSublayer:layer];
        }
//        [self groupAnimation];
        
        
        
         CGPoint endPoint = CGPointMake(ScreenWidth - 30, 50);
        [self showAddCartAnmationSview:view
                             imageView:joinImgView
                              starPoin:startPoint
                              endPoint:endPoint
                           dismissTime:0.55];
    }];
    
    return kaHomeCell;
}
- (void)showAddCartAnmationSview:(UIView *)sview
                       imageView:(UIImageView *)imageView
                        starPoin:(CGPoint)startPoint
                        endPoint:(CGPoint)endpoint
                     dismissTime:(float)dismissTime
{
    
    
    self.path = [UIBezierPath bezierPath];
    [_path moveToPoint:startPoint];
    [_path addQuadCurveToPoint:endpoint controlPoint:CGPointMake(150, 20)];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.2f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.2;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 0.6f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"group"];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //    [anim def];
    if (anim == [layer animationForKey:@"group"]) {
        
//        AppDelegate*   appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        KAHomeViewController  *kahomeVC = (KAHomeViewController *)appdelegate.baseVC;
        
        _btn.enabled = YES;
        [layer removeFromSuperlayer];
        layer = nil;
        [UserClient sharedUserClient].voteNum++;
        if ([UserClient sharedUserClient].voteNum) {
            self.baseVC.cntLabel.hidden = NO;
        }
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        self.baseVC.cntLabel.text = [NSString stringWithFormat:@"%ld",[UserClient sharedUserClient].voteNum];
        [self.baseVC.cntLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        
        [self.baseVC.voteNavView.layer addAnimation:shakeAnimation forKey:nil];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KAHomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    KADetailViewController *kaDetailVC = [[KADetailViewController alloc] init];
    
    kaDetailVC.headViewUrl = @"123";
    
    id object = [self nextResponder];
    
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        object = [object nextResponder];
    }
    
    UIViewController *uc=(UIViewController*)object;
    [uc.navigationController pushViewController:kaDetailVC animated:YES];


}

@end
