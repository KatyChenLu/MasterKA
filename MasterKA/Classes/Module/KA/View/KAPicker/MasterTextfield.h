//
//  MasterTextfield.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/17.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MasterTFTapActionBlock)();
typedef void (^MasterTFEndEditBlock)(NSString *text);

@interface MasterTextfield : UITextField
/** textField 的点击回调 */
@property (nonatomic, copy) MasterTFTapActionBlock tapActionBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) MasterTFEndEditBlock endEditBlock;

@end
