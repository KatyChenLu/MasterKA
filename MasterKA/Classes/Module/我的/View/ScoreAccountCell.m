//
//  ScoreAccountCell.m
//  MasterKA
//
//  Created by hyu on 16/5/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ScoreAccountCell.h"

@implementation ScoreAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showScoreAccount:(NSDictionary *)dic{
    self.instruct.text = dic[@"instruct"];
    self.addtime.text = [self changeTIme:dic[@"addtime"]];
    NSInteger points = [dic[@"get"] integerValue] -  [dic[@"put"] integerValue];
    if (points>0) {
        self.getOrput.textColor = [UIColor colorWithRed:22/255.0f green:152/255.0f blue:75/255.0f alpha:1];
        self.getOrput.text = [NSString stringWithFormat:@"+%ld",(long)points];
    }else{
        self.getOrput.textColor = [UIColor colorWithRed:227/255.0f green:13/255.0f blue:32/255.0f alpha:1];
        self.getOrput.text = [NSString stringWithFormat:@"%ld",(long)points];
    }
}
-(NSString *)changeTIme:(NSString *)str{
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}
@end
