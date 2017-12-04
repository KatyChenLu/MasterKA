//
//  CourseTableViewCell.m
//  MasterKA
//
//  Created by jinghao on 16/5/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CourseTableViewCell.h"

@interface CourseTableViewCell ()
@property (nonatomic,weak)IBOutlet UILabel *courseTitleLabel;
@property (nonatomic,weak)IBOutlet UILabel *priceSaleLabel;
@property (nonatomic,weak)IBOutlet UILabel *priceStandardLabel;
@property (nonatomic,weak)IBOutlet UILabel *courseAddressLabel;
@property (nonatomic,weak)IBOutlet UILabel *courseDistancesLabel;

@property (nonatomic,weak)IBOutlet UIImageView *courseImageView;
@property (nonatomic,weak)IBOutlet UIView *tagContentView;

@property (weak, nonatomic) IBOutlet UILabel *is_groupLab;
@property (weak, nonatomic) IBOutlet UILabel *groupWorld;

@end

@implementation CourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showCustomLineView = YES;
//    @weakify(self)
//    [RACObserve(self, model) subscribeNext:^(CourseModel *model) {
//        @strongify(self)
////        self.courseTitleLabel.text = model.title;
////        self.courseDistancesLabel.text = model.distance;
////        self.courseAddressLabel.text = model.store;
////        [self.courseImageView setImageFadeInWithURLString:model.cover placeholderImage:nil];
////        [self.courseImageView layersMakesToBoundsWithRadius:3];
////        self.priceSaleLabel.text = [model getPriceString];
////
//        if ( model.m_price) {
//            NSDictionary *attribs = @{NSStrikethroughStyleAttributeName:@(1)};
//            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[model getMakertPriceString] attributes:attribs];
//            [self.priceStandardLabel setAttributedText:attr];
//        }else{
//            self.priceStandardLabel.text = nil;
//        }
//        
//        if(model.is_enterprise.boolValue){
//            self.priceStandardLabel.hidden = YES;
//            self.priceSaleLabel.hidden = YES;
//        }else{
//            self.priceStandardLabel.hidden = NO;
//            self.priceSaleLabel.hidden = NO;
//
//        }
//        
//        self.groupWorld.textColor = [UIColor lightGrayColor];
//        
//        if ([model.is_groupbuy isEqualToString:@"1"] ) {
//            
//            self.is_groupLab.hidden = NO;
//            
//        }else{
//            
//            self.is_groupLab.hidden = YES;
//        }
//        
//        if (![model.groupbuy_tip isEqualToString:@""]) {
//            
//            self.groupWorld.hidden = NO;
//            self.groupWorld.text = model.groupbuy_tip;
//        }else{
//            
//            self.groupWorld.hidden = YES;
//            
//        }
//        
//    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
