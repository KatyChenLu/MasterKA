//
//  KACollectTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface KACollectTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *KAtitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *KAimgV;
@property (weak, nonatomic) IBOutlet UILabel *KAtime;
@property (weak, nonatomic) IBOutlet UILabel *KApeopleNum;
@property (weak, nonatomic) IBOutlet UILabel *KAPrice;
@property (weak, nonatomic) IBOutlet UIButton *addVoteBtn;

@property (nonatomic, strong)NSString *ka_course_id;
//团建课程是否删除，0：未删除；1：已删除
@property (nonatomic, strong)NSString *is_del;
//团建课程状态，0：下架；1：上架
@property (nonatomic, strong)NSString *status;

@property (nonatomic, strong)NSDictionary *collectDic;

@property (nonatomic, copy) void(^joinClick)(UIImageView *joinImgView,NSString *ka_course_id);
@property (nonatomic, copy) void(^canceljoinClick)(NSString *ka_course_id);

@end
