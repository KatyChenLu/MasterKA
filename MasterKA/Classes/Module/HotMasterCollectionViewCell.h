//
//  HotMasterCollectionViewCell.h
//  MasterKA
//
//  Created by lijiachao on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HostManShareModel.h"
@interface HotMasterCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView* btn1;
@property(nonatomic,strong)UIImageView* btn2;
@property(nonatomic,strong)UIImageView* btn3;

-(void) setHotMasterCollCellData:(HostManShareModel*)list;

@end
