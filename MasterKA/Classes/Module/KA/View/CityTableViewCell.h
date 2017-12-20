//
//  CityTableViewCell.h
//  HiMaster3
//
//  Created by 余伟 on 16/9/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell

@property(nonatomic, strong)CityModel * model;

-(void)buildMore:(NSDictionary *)dic;

-(void)hiddenAddress;

@end
