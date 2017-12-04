//
//  GroupMemberCell.m
//  MasterKA
//
//  Created by 余伟 on 16/8/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GroupMemberCell.h"
#import "MemberView.h"

@implementation GroupMemberCell
{
    
    MemberView * _memberView;
    
    
    
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        风水宝地可能是的
//        _memberView = [[MemberView alloc]initWithNum:5];
//        [self.contentView  addSubview:_memberView];
    }
    
//    [self layoutUi];
    
    return  self;
    
    
}




-(void)layoutUi
{
    
    
    @weakify(self)
    [_memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        
    }];
    
    
 
    
}



//-(void)layoutSubviews
//{
//    
//    [super layoutSubviews];
//    
//    [self  layoutUi];
//}




-(void)setInfoDic:(NSDictionary *)infoDic

{
    _infoDic = infoDic;
    
    _memberView.infoDic = infoDic;
    
    NSString *num = infoDic[@"groupbuy_num"];
    

    _memberView = [[MemberView alloc]initWithNum:[num integerValue]];
    [self.contentView  addSubview:_memberView];
  
    _memberView.infoDic = infoDic;
    
    [self layoutUi];
    
    
    
    
    

    
    
    

}



@end
