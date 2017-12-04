//
//  QRCodeViewController.h
//  HiGoMaster
//
//  Created by jinghao on 15/7/10.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeViewController : UIViewController
@property (nonatomic, copy) void (^QRCodeCancleBlock) (QRCodeViewController *);//扫描取消
@property (nonatomic, copy) void (^QRCodeSuncessBlock) (QRCodeViewController *,NSString *);//扫描结果
@property (nonatomic, copy) void (^QRCodeFailBlock) (QRCodeViewController *);//扫描失败
@end
