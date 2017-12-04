//
//  MyShareCell.h
//  MasterKA
//
//  Created by hyu on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyShareCell : UITableViewCell
-(void)showMyShare:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet UIImageView *img_top;
@property (weak, nonatomic) IBOutlet UILabel *nikename;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIView *imageListView;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UILabel *seeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lengthToimg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lengthToImglist;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priorty2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priorty3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priorty0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priorty1;

@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img5;
@property (strong, nonatomic) IBOutlet UIImageView *img6;
@property (strong, nonatomic) IBOutlet UIImageView *img4;
@property (strong, nonatomic) IBOutlet UIImageView *img9;
@property (strong, nonatomic) IBOutlet UIImageView *img7;
@property (strong, nonatomic) IBOutlet UIImageView *img8;
@property (strong, nonatomic) NSMutableArray *ImgViewArray;
@end
