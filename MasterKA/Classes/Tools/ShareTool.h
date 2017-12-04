//
//  ShareTool.h
//  MasterKA
//
//  Created by 陈璐 on 2017/3/16.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ShareSuccessBlock)(id data);
typedef void (^ShareFailsBlock)(NSError *error);

@interface ShareTool : NSObject

@property (nonatomic,strong) ShareSuccessBlock successBlock;
@property (nonatomic,strong) ShareFailsBlock failBlock;





+(ShareTool *)defaultShare;

-(void)thirdShareWithPlatformType:(UMSocialPlatformType)type title:(NSString *)title descr:(NSString *)content imageUrl:(NSString *)imgurl linkUrl:(NSString *)linkurl succcess:(ShareSuccessBlock)successBlock fail:(ShareFailsBlock)failBlock;

@end
