//
//  GuessLikeCollectionCell.m
//  MasterKA
//
//  Created by hyu on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GuessLikeCollectionCell.h"
#import "CourseModel.h"

@implementation GuessLikeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)showGuessLike:(NSDictionary *)dic{
    if([dic isKindOfClass:[CourseModel class]]){
        CourseModel *model = (CourseModel*)dic;
//        [self.cover setImageWithURLString:model.cover placeholderImage:nil];
//        self.title.text=model.title;
//        self.store.text= [NSString stringWithFormat:@"￥%d",[model.price intValue]] ;
//        self.distance.text=[NSString stringWithFormat:@"￥%@",model.market_price];
    }else{
        [self.cover setImageWithURLString:dic[@"cover"] placeholderImage:nil];
        self.title.text=dic[@"title"];
        self.title.numberOfLines = 0;
        self.store.text=[NSString stringWithFormat:@"%@人喜欢",dic[@"view_count"]];
        self.distance.text=dic[@"distance"];
        self.distance.hidden = YES;
        self.lineShow.hidden=YES;
    }
    
}






@end
