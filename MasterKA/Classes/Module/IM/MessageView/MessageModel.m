/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //code
    }
    
    return self;
}
- (void)setDictData:(NSDictionary*)dict
{
    self.type = eMessageBodyType_Text;
    self.status = eMessageDeliveryState_Delivered;
    self.messageId = dict[@"id"];
    self.content = dict[@"content"];
    self.time = [dict[@"currentTime"] integerValue];
    NSString* sendUid = dict[@"sendUid"];
    if (![sendUid isEqualToString:[UserClient sharedUserClient].userId]) {
        self.isSender = FALSE;
        //            model.headImageUrl = fullImageUrl(dict[@"acceptImgTop"]);
        //            model.nickName = dict[@"acceptNickName"];
        //            model.username = dict[@"acceptNickName"];
        self.headImageUrl = dict[@"sendImgTop"];
        self.nickName = dict[@"sendNickName"];
        self.username = dict[@"sendNickName"];
    }else{
        self.isSender = TRUE;
        self.headImageUrl = dict[@"sendImgTop"];
        self.nickName = dict[@"sendNickName"];
        self.username = dict[@"sendNickName"];
    }
    NSString* type = dict[@"type"];
    if ([type isEqualToString:@"2"]) {
        self.type = eMessageBodyType_Image;
        self.imageRemoteURL = dict[@"content"];
        self.thumbnailRemoteURL = dict[@"content"];
        CGFloat width = [dict[@"width"] floatValue];
        CGFloat height = [dict[@"height"] floatValue];
        CGSize size={width,height};
        self.size=size;
    }
    self.timeString = dict[@"addtime"];
}
- (void)dealloc{
    
}

@end
