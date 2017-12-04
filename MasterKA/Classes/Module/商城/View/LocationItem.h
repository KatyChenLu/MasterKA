//
//  LocationItem.h
//  HiGoMaster
//
//  Created by jinghao on 15/6/14.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FSDPickerItemProtocol.h"
@interface LocationItem : NSObject <FSDPickerItemProtocol>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) BOOL selected;
@property (strong,nonatomic)CityModel* data;
@end
