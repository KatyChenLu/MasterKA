//
//  KAHomeTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "KAHomeListModel.h"

@interface KAHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImgview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *IntrLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property(nonatomic ,strong)UILabel * label;

@property(nonatomic ,strong)UILabel * commentLabel;
@property(nonatomic ,strong)NSMutableArray * commentLabelArr;
@property (nonatomic, strong)NSArray *tagsArr;

@property (nonatomic, strong)NSString *ka_course_id;
@property (nonatomic, copy) void(^joinClick)(UIImageView *joinImgView,NSString *ka_course_id);
@property (nonatomic, copy) void(^canceljoinClick)(NSString *ka_course_id);
@property (nonatomic, copy) void(^todoLogin)();
@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic, strong) NSDictionary *kaHomeModel;

@end
