//
//  ForgetPwdView.h
//  MasterKA
//
//  Created by lijiachao on 16/12/22.
//  Copyright © 2016年 jinghao. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol ForgetPwdViewDelegate <NSObject>
- (void)DoreForgetPwdFrame;
@end

@interface ForgetPwdView : UIView{
    id <ForgetPwdViewDelegate> delegate;
}
@property (nonatomic, assign) id <ForgetPwdViewDelegate> delegate;
@end
