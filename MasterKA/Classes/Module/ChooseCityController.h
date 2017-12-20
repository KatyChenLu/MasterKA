//
//  ChooseCityController.h
//  HiMaster3
//
//  Created by 余伟 on 16/9/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseCityController : UIViewController


@property(nonatomic ,copy)void(^changeCityBlock)(CityModel *model);

@end
