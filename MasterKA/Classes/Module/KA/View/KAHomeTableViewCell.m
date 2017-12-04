//
//  KAHomeTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAHomeTableViewCell.h"
#import "KAHomeViewController.h"
#import "MainTabBarController.h"

@implementation KAHomeTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setKaHomeModel:(CourseModel *)kaHomeModel {
    
    _kaHomeModel = kaHomeModel;
    
    self.nameLabel.text = _kaHomeModel.title;
    self.IntrLabel.text = _kaHomeModel.nikename;
    self.timeLabel.text = _kaHomeModel.distance;
    self.countLabel.text = _kaHomeModel.course_id;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",_kaHomeModel.price];
    [self.topImgview setImageFadeInWithURLString:_kaHomeModel.cover placeholderImage:nil];
    
    
}
- (IBAction)voteBtnAction:(id)sender {
    
    self.joinClick(self.topImgview);
    
}


@end
