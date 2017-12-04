//
//  MasterMsgCell.m
//  MasterKA
//
//  Created by 余伟 on 17/2/6.
//  Copyright © 2017年 jinghao. All rights reserved.
//

#import "MasterMsgCell.h"
#import "MasterMsg.h"

@implementation MasterMsgCell
{
    MasterMsg * _msgCell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        _msgCell = [MasterMsg masterMsg];
        
        @weakify(self)
        
        [_msgCell setMsg:^{
            
            @strongify(self)
            self.master();
            
        }];
        
        
        [self.contentView addSubview:_msgCell];
        
        [self layout];
        
        
    }
    return self;
}



-(void)layout{
    
    @weakify(self)
    [_msgCell mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
}


-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    _msgCell.dic = dic;
    
    
}

@end
