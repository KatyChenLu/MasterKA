//
//  KAImageTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/7.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;

- (void)showContentImg:(NSDictionary *)dic;
@end
