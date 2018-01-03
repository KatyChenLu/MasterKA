//
//  UIViewController+Share.m
//  MasterKA
//
//  Created by jinghao on 15/12/21.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "UIViewController+Share.h"

#define kShareViewKey        @"ShareView"
@implementation UIViewController (Share)
@dynamic shareView;


-(void)setShareView:(ThirdShareView *)shareView {
    objc_setAssociatedObject(self, kShareViewKey, shareView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(ThirdShareView *)shareView{
    return objc_getAssociatedObject(self, kShareViewKey);
}

- (void)shareContentOfApp:(NSString*)title content:(NSString*)content imageUrl:(NSString*)imageUrl shareToPlatform:(UMSocialPlatformType)type{
    
    [self shareContentOfApp:title content:content imageUrl:imageUrl linkUrl:nil shareToPlatform:type];
   
}

- (void)shareContentOfApp:(NSString*)title content:(NSString*)content imageUrl:(NSString*)imageUrl linkUrl:(NSString*)linkUrl shareToPlatform:(UMSocialPlatformType)type
{
    
    if (linkUrl==nil || ![linkUrl isKindOfClass:[NSString class]] || linkUrl.length==0) {
        linkUrl = WEB_DOMAIN;
    }
    
    imageUrl = [imageUrl masterFullImageUrl];
    
    
     //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:imageUrl];
    //设置网页地址
    shareObject.webpageUrl = linkUrl;

    
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];


    
}

- (void)shareContentOfApp:(NSDictionary*)shareInfo
{
    self.shareView = [[ThirdShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
    
    [self.shareView.shareBtns enumerateObjectsUsingBlock:^( ShopTopImageBtn * btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        btn.data = shareInfo;
        
        [btn addTarget: self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    
    NSLog(@"shareInfo  %@",shareInfo);
}
- (void)shareContentOfApp:(NSDictionary *)shareInfo cancelVoteArr:(NSArray *)cancelArr {
    self.shareView = [[ThirdShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
    
    [self.shareView.shareBtns enumerateObjectsUsingBlock:^( ShopTopImageBtn * btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        btn.data = shareInfo;
        btn.model = cancelArr;
        
        [btn addTarget: self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }];
    
    NSLog(@"shareInfo  %@",shareInfo);
}

//朋友圈
-(void)shareWbFCWithModel:(NSDictionary*)shareInfo{
    
    
    [[ShareTool defaultShare] thirdShareWithPlatformType:UMSocialPlatformType_WechatTimeLine title:shareInfo[@"title"] descr:shareInfo[@"desc"] imageUrl:shareInfo[@"imgUrl"] linkUrl:shareInfo[@"link"]  succcess:^(id data) {
        
//        if (arr.count) {
//            for (NSString *kaid in arr) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelVote" object:@{@"ka_course_id":kaid}];
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelShare" object:nil];
        
//            }
//        }
        
        
    } fail:^(NSError *error) {
        
    }];
}
-(void)shareWeChatWithModel:(NSDictionary*)shareInfo{
    
    
    [[ShareTool defaultShare] thirdShareWithPlatformType:UMSocialPlatformType_WechatSession title:shareInfo[@"title"] descr:shareInfo[@"desc"] imageUrl:shareInfo[@"imgUrl"] linkUrl:shareInfo[@"link"]  succcess:^(id data) {
        
//        if (arr.count) {
//            for (NSString *kaid in arr) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelVote" object:@{@"ka_course_id":kaid}];
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelShare" object:nil];
//            }
//        }
        
        
    } fail:^(NSError *error) {
        
    }];
}
-(void)shareSinaWithModel:(NSDictionary*)shareInfo {
    
    
    
    [[ShareTool defaultShare] thirdShareWithPlatformType:UMSocialPlatformType_Sina title:shareInfo[@"title"] descr:shareInfo[@"desc"] imageUrl:shareInfo[@"imgUrl"] linkUrl:shareInfo[@"link"]  succcess:^(id data) {
        
    } fail:^(NSError *error) {
        
    }];
}
-(void)shareQQWithModel:(NSDictionary*)shareInfo{
    
    
    
    [[ShareTool defaultShare] thirdShareWithPlatformType:UMSocialPlatformType_QQ title:shareInfo[@"title"] descr:shareInfo[@"desc"] imageUrl:shareInfo[@"imgUrl"] linkUrl:shareInfo[@"link"]  succcess:^(id data) {
        
    } fail:^(NSError *error) {
        
    }];
    
}
-(void)shareClick:(ShopTopImageBtn *)sender
{
    
    
    switch (sender.tag) {
        case 0://微信
            
            [self shareWeChatWithModel:sender.data ];
            
            
            break;
            
        case 1://朋友圈
            
            [self shareWbFCWithModel:sender.data ];
            
            break;
            

            
        default:
            break;
            
    }
    
    
    
    
    [self.shareView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelShare" object:nil];
    NSLog(@"share");
    
}
@end
