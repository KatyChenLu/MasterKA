//
//  SelectDetailViewCell.m
//  MasterKA
//
//  Created by hyu on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "SelectDetailViewCell.h"

@implementation SelectDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showChoice:(NSDictionary *)dic ByIdentifier:(NSString *)identifier{
    if([identifier isEqual:@"store"]){
        self.price.hidden=YES;
        self.name.text =dic[@"store"];
        self.subName.text=dic[@"address"];
        self.tag=[dic[@"course_id"] integerValue];
        self.subNameToleft.priority=750;
        self.subToPrice.priority=250;
    }else{
        self.price.hidden=NO;
        self.name.text =dic[@"custom_spec_name"];
        self.subName.text=[NSString stringWithFormat:@"￥ %@", dic[@"market_price"]];
        
        NSDictionary *attribs = @{NSStrikethroughStyleAttributeName:@(1)};
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.subName.text attributes:attribs];
        [self.subName setAttributedText:attr];
        if(dic[@"groupprice"]!=nil&& [dic[@"tag"]isEqualToString:@"11"])
        {
        self.price.text=[NSString stringWithFormat:@"￥ %@",dic[@"groupprice"]] ;
        }
        else{
        self.price.text=[NSString stringWithFormat:@"￥ %@",dic[@"price"]] ;
        }
        self.tag=[dic[@"course_cfg_id"] integerValue];
        self.subNameToleft.priority=250;
        self.subToPrice.priority=750;
    }
}
@end
