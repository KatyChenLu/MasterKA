//
//  TableViewCell.m
//  MasterKA
//
//  Created by hyu on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TimeAndStoreCell.h"

@implementation TimeAndStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showTimeAndStore:(NSDictionary *)dic{
    self.img_iden.image=[UIImage imageNamed:dic[@"img_name"]] ;
    self.name.text=dic[@"name"];

}
@end
