//
//  registerView.h
//  MasterKA
//
//  Created by lijiachao on 16/12/22.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol registerDelegate <NSObject>
- (void)DoreGisterFrame;
- (void)DoProtolFrame;
@end
@interface registerView : UIView{
    id <registerDelegate> delegate;
}
@property (nonatomic, assign) id <registerDelegate> delegate;
@end
