//
//  MDatePickerView.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/17.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPickerBaseView.h"

typedef void (^MdatePickerBlock)(NSString  *selectValue);

@interface MDatePickerView : MPickerBaseView
/**
 *  显示时间选择器
 *
 *  @param title            标题
 *  @param type             类型（时间、日期、日期和时间、倒计时）
 *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
 *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
 *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title dateType:(UIDatePickerMode)type defaultSelValue:(NSString *)defaultSelValue minDateStr:(NSString *)minDateStr maxDateStr:(NSString *)maxDateStr isAutoSelect:(BOOL)isAutoSelect resultBlock:(MdatePickerBlock)resultBlock;
@end
