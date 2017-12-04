//
//  UIImageView+Browser.h
//  MasterKA
//
//  Created by jinghao on 16/6/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface UIImageView (Browser)<MWPhotoBrowserDelegate>
@property (nonatomic,assign)BOOL canBrowser;
@property (nonatomic,strong)NSArray *browserImages;
@end
