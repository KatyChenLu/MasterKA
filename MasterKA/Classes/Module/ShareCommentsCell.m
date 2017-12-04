//
//  ShareCommentsCell.m
//  MasterKA
//
//  Created by lijiachao on 16/10/10.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ShareCommentsCell.h"
#import "Masonry.h"

@interface ShareCommentsCell(){}

@property(nonatomic,strong)UIImageView* userTopImageView;
@property(nonatomic,strong)UILabel* nikenameTitle;
@property(nonatomic,strong)UILabel* userCommtLabel;
@property(nonatomic,strong)UIView* dianzanView;
@property(nonatomic,strong)UIButton* dianzanBtn;
@end

@implementation ShareCommentsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBFromHexadecimal(0xF0F0F2);
        CGRect frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width-57;
        self.contentView.frame = frame;
        self.dianzanView = [[UIView alloc]init];
        self.dianzanView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.dianzanView];

        self.dianzanBtn = [[UIButton alloc]init];
        self.dianzanBtn.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.dianzanBtn];
        
        self.commtImageView = [[UIImageView alloc]init];
        self.commtImageView.image = [UIImage imageNamed:@"评论"];
        self.commtImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.commtImageView];
        
        self.userTopImageView = [[UIImageView alloc]init];
        self.userTopImageView.backgroundColor = [UIColor clearColor];

        self.userTopImageView.layer.cornerRadius = 17;
        self.userTopImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.userTopImageView];
        
        self.nikenameTitle = [[UILabel alloc]init];
        self.nikenameTitle.backgroundColor = [UIColor clearColor];
        //self.nikenameTitle.text = @"坏红红火火";
        self.nikenameTitle.font = [UIFont systemFontOfSize:12];
        self.nikenameTitle.textColor = RGBFromHexadecimal(0x465682);
        [self.contentView addSubview:self.nikenameTitle];
        
        self.userCommtLabel = [[UILabel alloc]init];
        self.userCommtLabel.backgroundColor = [UIColor clearColor];
        self.userCommtLabel.font = [UIFont systemFontOfSize:12];
        self.userCommtLabel.textColor = RGBFromHexadecimal(0x464646);
        self.userCommtLabel.numberOfLines = 0;
        [self.contentView addSubview:self.userCommtLabel];
        
        [self.commtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(13);
            make.height.width.mas_equalTo(@18);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            
        }];
        [self.userTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(4);
            make.height.width.mas_equalTo(@34);
            make.left.equalTo(self.commtImageView.mas_right).with.offset(10);
        }];
        [self.nikenameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.height.mas_equalTo(@15);
            make.width.mas_equalTo(@200);
            make.left.equalTo(self.userTopImageView.mas_right).with.offset(6);
        }];
        [ self.userCommtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nikenameTitle.mas_bottom).with.offset(0.2);
            //make.height.mas_equalTo(@15);
            make.left.equalTo(self.userTopImageView.mas_right).with.offset(6);
            make.right.equalTo(self.contentView.mas_right).with.offset(-2);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
    }
    return self;
}

-(void)getCommentData:(NSDictionary*)Data{
    
    if([Data objectForKey:@"img_top"])
    {
        [self.userTopImageView  setImageWithURLString:[Data objectForKey:@"img_top"] placeholderImage:nil];
    }
    NSString *text = [Data objectForKey:@"content"];
    [self.userCommtLabel setEmojiText:text];
    self.nikenameTitle.text =[Data objectForKey:@"nikename"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
