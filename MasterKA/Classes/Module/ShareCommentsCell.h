//
//  ShareCommentsCell.h
//  MasterKA
//
//  Created by lijiachao on 16/10/10.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCommentsCell : UITableViewCell
@property(nonatomic,strong)UIImageView* commtImageView;
-(void)getCommentData:(NSDictionary*)Data;
@end
