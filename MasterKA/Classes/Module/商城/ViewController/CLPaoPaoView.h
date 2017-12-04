//
//  CLPaoPaoView.h
//  HiMaster3
//
//  Created by ChenLu on 2017/6/6.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^daohangBlock)();

@interface CLPaoPaoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *weizhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *daohangButton;
@property (nonatomic, copy) daohangBlock block;
@end
