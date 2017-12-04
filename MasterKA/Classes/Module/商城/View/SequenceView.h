//
//  SequenceView.h
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftTitleBtn.h"

@interface SequenceView : UIView

@property(nonatomic ,copy)void(^dismiss)(id index);

@property(nonatomic ,strong)NSArray * source;

@property(nonatomic ,strong)UITableView * sequenceTableView;

@property(nonatomic ,strong)LeftTitleBtn * sequenceBtn;


@end
