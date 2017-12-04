//
//  totalShareCell.h
//  MasterKA
//
//  Created by lijiachao on 16/9/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterShareModel.h"

@protocol ShareImgSaveDelegate <NSObject>

- (void)saveImg:(UIImage*)shareImg;

@end


@interface totalShareCell : UITableViewCell

-(void) setShareList:(MasterShareModel*)list isfromHeight:(BOOL)isfromHeight deleteIndex:(NSIndexPath*)deleteIndex isAll:(BOOL)isall;

@property(nonatomic,strong)void (^btnBlock)();
@property(nonatomic,assign)BOOL isShowAll;
@property(nonatomic, weak) id<ShareImgSaveDelegate> delegate;

@end
