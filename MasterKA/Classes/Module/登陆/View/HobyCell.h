//
//  HobyCell.h
//  MasterKA
//
//  Created by 余伟 on 16/7/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HobyCell : UITableViewCell

@property(nonatomic ,strong)NSArray * arr;

@property(nonatomic ,assign)CGFloat cellH;

@property(nonatomic ,copy)void(^saveData)(NSMutableString *hobyStr);


@end
