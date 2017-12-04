//
//  ShareTool.m
//  MasterKA
//
//  Created by 陈璐 on 2017/3/16.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "ShareTool.h"

@implementation ShareTool
+(ShareTool *)defaultShare {
    static ShareTool *shareTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       shareTool = [[ShareTool alloc] init];
    });
    return shareTool;
}


-(void)thirdShareWithPlatformType:(UMSocialPlatformType)type title:(NSString *)title descr:(NSString *)content imageUrl:(NSString *)imgurl linkUrl:(NSString *)linkurl succcess:(ShareSuccessBlock)successBlock fail:(ShareFailsBlock)failBlock{
    //如果没有链接则转跳
    if (linkurl==nil || ![linkurl isKindOfClass:[NSString class]] || linkurl.length==0) {
        linkurl = WEB_DOMAIN;
    }
    if ([imgurl isEqualToString:@""]) {
        imgurl = (id)[UIImage imageNamed:@"icon-info"];
    }else{
        imgurl=[imgurl masterFullImageUrl];
    }
    
    
    if (type == UMSocialPlatformType_Sina) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //设置文本
        messageObject.text = content;
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        [shareObject setShareImage:imgurl];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                failBlock(error);
            }else{
                NSLog(@"response data is %@",data);
                successBlock(data);
            }
        }];
    }else{
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:imgurl];
        //设置网页地址
        shareObject.webpageUrl = linkurl;
        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
                failBlock(error);
            }else{
                successBlock(data);
            }
            
        }];
    }
    
    
}

@end
