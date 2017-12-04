//
//  BaseModel.h
//  MasterKA
//
//  Created by jinghao on 15/12/11.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property (nonatomic)NSInteger code;
@property (nonatomic,strong)NSString* message;
@property (nonatomic,strong)NSDictionary* alert;
@property (nonatomic,strong)id  data;
@end
