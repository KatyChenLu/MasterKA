//
//  KAFilterView.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTRangeSlider.h"



@interface KAFilterView : UIView

typedef NS_ENUM(NSInteger,filterType){
    jampanFilter =0,
    optionFilter,
};

/**
 筛选arr
 */
@property (nonatomic,strong) NSMutableArray *filterArr;



@property(nonatomic , copy)void(^filter)(id ID);
@property(nonatomic, copy)void(^touchBlock)();
@property (nonatomic, assign) filterType type;

- (instancetype)initWithFrame:(CGRect)frame withType:(filterType)type;
@end
