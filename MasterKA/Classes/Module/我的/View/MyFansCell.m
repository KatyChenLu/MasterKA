//
//  MyFansCell.m
//  MasterKA
//
//  Created by hyu on 16/4/29.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyFansCell.h"
#import "SDWebImageManager.h"
#import "MBProgressHUD.h"
@implementation MyFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.removeFollow.layer.masksToBounds=self.fansFollow.layer.masksToBounds=YES;
//    self.removeFollow.layer.cornerRadius=self.fansFollow.layer.cornerRadius=5.0; //设置矩形四个圆角半径
//    self.removeFollow.layer.borderWidth=self.fansFollow.layer.borderWidth=1.0; //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.8, 0.8, 0.8, 1 });
//    self.removeFollow.layer.borderColor=self.fansFollow.layer.borderColor=colorref;//边框颜色
    // Configure the view for the selected state
}
-(void)showMyfans:(NSDictionary *)dic identity:(NSString *)identity shareId:(NSString*)shareId{
    [self.fansHeadImg setImageWithURLString:dic[@"img_top"] placeholderImage:[UIImage imageNamed:@"DefaultImage.png"]];
    self.fansName.text=[dic objectForKey:@"nikename"];
    self.fansSay.text=[dic objectForKey:@"intro"];
    self.fansFollow.tag=[[dic objectForKey:@"uid"] integerValue];
    self.removeFollow.tag=[[dic objectForKey:@"uid"] integerValue];
    if([identity  isEqual:@"fans"]||shareId){
        self.fansFollow.tag=[[dic objectForKey:@"uid"] integerValue];
        self.removeFollow.tag=[[dic objectForKey:@"uid"] integerValue];
        [self.removeFollow addTarget:self action:@selector(removeFollow:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.removeFollow.tag=[[dic objectForKey:@"fid"] integerValue];
    }
    if([[dic objectForKey:@"is_follow"] isEqual:@"0"]){
        self.fansFollow.hidden=NO;
        self.removeFollow.hidden=YES;
    }else{
        self.fansFollow.hidden=YES;
        self.removeFollow.hidden=NO;
    }
}

-(IBAction)BecomeFollow:(id) sender{
 
    [[[HttpManagerCenter sharedHttpManager] addAttention: [NSString stringWithFormat:@"%ld",(long)[sender tag]] resultClass:nil] subscribeNext:^(BaseModel *model){
        if(model.code ==200){
            self.fansFollow.hidden=YES;
            self.removeFollow.hidden=NO;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
            hud.labelText = model.message;
            hud.mode = MBProgressHUDModeCustomView;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.7];
        }
    }];
}
-(void)removeFollow:(id) sender{
    
    [[[HttpManagerCenter sharedHttpManager] removeAttention:[NSString stringWithFormat:@"%ld",(long)[sender tag]] resultClass:nil] subscribeNext:^(BaseModel *model){
        if(model.code ==200){
            self.fansFollow.hidden=NO;
            self.removeFollow.hidden=YES;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
            hud.labelText = model.message;
            hud.mode = MBProgressHUDModeCustomView;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:0.7];
        }
    }];
}
@end
