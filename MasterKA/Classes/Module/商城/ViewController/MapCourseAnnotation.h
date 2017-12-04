//
//  MapCourseAnnotation.h
//  MasterKA
//
//  Created by 余伟 on 16/12/19.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "MapModels.h"

@interface MapCourseAnnotation : BMKPointAnnotation

@property(nonatomic ,strong)MapModels * model;

@end
