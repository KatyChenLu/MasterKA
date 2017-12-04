//
//  DianzanCellectCell.h
//  MasterKA
//
//  Created by lijiachao on 16/10/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface DianzanCellectCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView* topImageView;

-(void)setDianZanCellData:(NSString*)user_top width:(CGFloat)width height:(CGFloat)height;
@end
