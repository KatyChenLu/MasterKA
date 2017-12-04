//
//  GenderCell.h
//  MasterKA
//
//  Created by 余伟 on 16/7/7.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenderCell : UITableViewCell


@property(nonatomic ,copy)NSString * genderStr;


@property(nonatomic ,copy)void(^saveGender)(NSString * gender);

@end
