//
//  GoodsListCellViewMode.m
//  MasterKA
//
//  Created by xmy on 16/5/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GoodsListCellViewMode.h"

@interface GoodsListCellViewMode ()

@property (nonatomic, strong, readwrite) CourseModel *model;

@end

@implementation GoodsListCellViewMode


- (instancetype)initWithModel:(CourseModel*)model{
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)bindGoodsTableViewCell:(CourseTableViewCell *)cell
{
    //    RAC(cell.contentLabel,text)=RACObserve(self.model, content);
//    cell.contentLabel.text = self.model.content;
//    cell.nikeNameLabel.text = self.model.nikename;
//    cell.titleLabel.text = self.model.title;
//    [cell.tagButton setTitle:self.model.tag_name forState:UIControlStateNormal];
//    [cell.likeButton setTitle:self.model.like_count forState:UIControlStateNormal];
//    [cell.browseButton setTitle:self.model.browse_count forState:UIControlStateNormal];
//    
//    [cell.userHeadView setImageWithURLString:self.model.img_top];
//    [cell.coverView setImageWithURLString:self.model.cover];
//    [cell.tagButton addTarget:self action:@selector(tagButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tagButtonOnClick:(id)sender{
//    [self.didClickTagButtonCommand execute:[NSString stringWithFormat:@"%@?tagId=%@&title=%@",URL_MasterShareList,self.model.tag_id,[self.model.tag_name urlencode]]];
}



@end
