//
//  AticleDetailImageCell.h
//  HiMaster3
//
//  Created by 余伟 on 16/10/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AticleDetailModel.h"
#import <FLAnimatedImage.h>

@interface AticleDetailImageCell : UITableViewCell

-(void)configueCellWithModel:(NSDictionary * )dic;
@property(nonatomic , strong)FLAnimatedImageView * detailImage;

@property(nonatomic ,strong)UIImage * image;

@property(nonatomic ,copy)void(^height)();


@end
