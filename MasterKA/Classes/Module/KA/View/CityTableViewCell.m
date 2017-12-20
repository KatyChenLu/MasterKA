//
//  CityTableViewCell.m
//  HiMaster3
//
//  Created by 余伟 on 16/9/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CityTableViewCell.h"
#import "UILabel+MasterFont.h"

@interface CityTableViewCell()

@property (strong, nonatomic) UIImageView *cityImage;

@property (strong, nonatomic) UILabel *cityName;

@property (strong, nonatomic) UILabel *cityPinYin;

@property(strong , nonatomic)  UIImageView *address;

@end

@implementation CityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self  layoutUI];
        
    }
    
    @weakify(self)
    
    [RACObserve(self, model)subscribeNext:^(CityModel * model) {
        
        @strongify(self)
        
        [self.cityImage setImageWithURLString:model.pic_url];
        
        self.cityName.text = self.model.alias_name;
        
        self.cityPinYin.text = self.model.pingyin;
        
        self.address.hidden = ![[UserClient sharedUserClient].city_name isEqualToString:model.alias_name];
        
    }];
    
    return self;
}

- (void)layoutUI{
    
    self.cityImage = [[UIImageView alloc]init];
    
    self.cityName = [[UILabel alloc]init];
    
    self.cityName.textColor = [UIColor whiteColor];
    
    self.cityPinYin = [[UILabel alloc]init];
    
    self.cityPinYin.textColor = [UIColor whiteColor];
    
    self.address = [[UIImageView alloc]init];
    
    self.address = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dingwei"]];
    
    [self.contentView addSubview:self.cityImage];
    [self.contentView addSubview:self.cityName];
    [self.contentView addSubview:self.cityPinYin];
    [self.contentView addSubview:self.address];
    
    @weakify(self)
    
    [self.cityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self)
        
        make.top.equalTo(self.contentView);
        
        make.left.equalTo(self.contentView);
        
        make.right.equalTo(self.contentView);
        
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1);
        
    }];
    
    [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self)
        
        make.centerX.mas_equalTo(self.cityImage.centerX);
        
        make.centerY.mas_equalTo(self.cityImage.centerY).offset(-10);
        
    }];
    
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self)
        
        make.centerX.mas_equalTo(self.cityImage.centerX).offset(-40);
        
        make.centerY.mas_equalTo(self.cityImage.centerY).offset(-10);
        
        //        make.width.height.equalTo(@5);
        
    }];
    
    [self.cityPinYin mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self)
        
        make.centerX.mas_equalTo(self.cityImage.centerX);
        
        make.centerY.mas_equalTo(self.cityImage.centerY).offset(10);
        
    }];
    
}


- (void)buildMore:(NSDictionary *)dic{
    
    self.cityImage.image = [UIImage imageNamed:dic[@"imageName"]];
    
    [self.cityName mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView);
        
        make.centerY.equalTo(self.contentView);
        
    }];
    
    self.cityName.text = @"更多城市敬请期待......";
    
}

- (void)hiddenAddress{
    
    self.address.hidden = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
