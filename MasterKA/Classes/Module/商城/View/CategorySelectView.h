//
//  CategorySelectView.h
//  MasterKA
//
//  Created by 余伟 on 16/12/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategorySelectView : UIView
@property(nonatomic ,strong)NSArray * categorys;

@property(nonatomic , copy)void(^filter)(id category);

@end
