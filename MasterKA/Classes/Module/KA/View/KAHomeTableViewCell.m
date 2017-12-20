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

@interface KAHomeTableViewCell()

@property(nonatomic ,assign)CGFloat totalWidth;

@property(nonatomic ,strong)UILabel * beforeLabel;

@end
@implementation KAHomeTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setKaHomeModel:(NSDictionary *)kaHomeModel {
    
    _kaHomeModel = kaHomeModel;
    self.nameLabel.text = _kaHomeModel[@"course_title"];
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.IntrLabel.text = _kaHomeModel[@"course_sub_title"];
    self.timeLabel.text = _kaHomeModel[@"course_time"];
    self.countLabel.text = _kaHomeModel[@"people_num"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",_kaHomeModel[@"course_price"]];
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.topImgview setImageFadeInWithURLString:_kaHomeModel[@"course_cover"] placeholderImage:nil];
    
    self.ka_course_id = _kaHomeModel[@"ka_course_id"];
    
    
    

        [self.voteBtn setBackgroundImage:[UIImage imageWithColor:MasterDefaultColor] forState:UIControlStateSelected];
        [self.voteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.voteBtn setTitle:@"加入投票" forState:UIControlStateNormal];
    

        [self.voteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [self.voteBtn setTitleColor:RGBFromHexadecimal(0xb9b8af) forState:UIControlStateSelected];
        [self.voteBtn setTitle:@"取消投票" forState:UIControlStateSelected];
    

    if ([_kaHomeModel[@"is_vote_cart"] isEqualToString:@"0"]) {
        self.voteBtn.selected = NO;
        self.voteBtn.borderWidth = 0.0f;
         self.voteBtn.borderColor = [UIColor clearColor];
        
    }else{
        self.voteBtn.selected = YES;
        self.voteBtn.borderWidth = 1.0f;
        self.voteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
    }
    
    
 
    [self.tipView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipView);
        
        make.left.equalTo(self.tipView).offset(10);
        
        make.height.equalTo(@20);
    }];
    
   NSArray *comments = _kaHomeModel[@"tags_name"];
    self.commentLabel.text = comments[0];
    if (self.commentLabelArr) {

        [self.commentLabelArr enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {

            [obj removeFromSuperview];

        }];

    }
    NSMutableArray * topicLabels = [NSMutableArray arrayWithCapacity:10];
    
    for (int i =0; i<comments.count; i++) {
        if (i == 0) {
              CGSize size  = [comments[0] sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:SpecialFont  size:10]}];
            NSInteger firstW = size.width + 10.0;
            [self.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(firstW);
            }];
            
            self.totalWidth = size.width +10;
            
            self.beforeLabel = _commentLabel;
        }else {
            UILabel *nextLabel = [[UILabel alloc] init];
            nextLabel.text = comments[i];
            nextLabel.tag = i;
            nextLabel.textColor = [UIColor blackColor];
            
            nextLabel.font = [UIFont fontWithName:SpecialFont  size:12];
            
            nextLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            nextLabel.textAlignment = NSTextAlignmentCenter;
            
            nextLabel.layer.cornerRadius = 3.0f;
            nextLabel.layer.masksToBounds = YES;
            [topicLabels addObject:nextLabel];
            [self.tipView addSubview:nextLabel];
               CGSize nextSize  = [comments[i] sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:SpecialFont  size:10]}];
            
            if (self.totalWidth + 6+10+nextLabel.width <=ScreenWidth) {
                [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.beforeLabel.mas_right).offset(6);
                    
                    make.top.equalTo(self.beforeLabel);
                    
                    make.width.mas_equalTo(nextSize.width+10);
                    
                    make.height.equalTo(@20);
                }];
                self.totalWidth += (nextSize.width +6);
            }else {
                
                [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.commentLabel);
                    
                    make.top.equalTo(self.beforeLabel.mas_bottom).offset(10);
                    
                    make.height.equalTo(@12);
                    
                }];
                
                self.totalWidth = nextSize.width + 10;
            }
             self.beforeLabel = nextLabel;
            
            
        }
        self.commentLabelArr = topicLabels;
    }
    
    
    
}
- (IBAction)voteBtnAction:(id)sender {
    if ([UserClient sharedUserClient].rawLogin) {
        if (self.voteBtn.selected) {
            self.canceljoinClick(self.ka_course_id);
            [_kaHomeModel setValue:@"0" forKey:@"is_vote_cart"];
            self.voteBtn.borderWidth = 0.0f;
            self.voteBtn.borderColor = [UIColor clearColor];
            
        }else{
            self.joinClick(self.topImgview,self.ka_course_id);
            [_kaHomeModel setValue:@"1" forKey:@"is_vote_cart"];
            
            self.voteBtn.borderWidth = 1.0f;
            self.voteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
            
        }
        
        self.voteBtn.selected = !self.voteBtn.selected;
    }else{
        self.todoLogin();
    }
 
    
}

//topic
- (UILabel *)commentLabel{
    
    if (!_commentLabel) {
        
        _commentLabel = [[UILabel alloc]init];
        
        _commentLabel.textColor = [UIColor blackColor];
        
        _commentLabel.font = [UIFont fontWithName:SpecialFont  size:10];
        
        _commentLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        
        _commentLabel.tag = 0;
        
        _commentLabel.textAlignment = NSTextAlignmentCenter;
        
        _commentLabel.userInteractionEnabled = YES;
        
        _commentLabel.layer.cornerRadius = 3.0f;
        _commentLabel.layer.masksToBounds = YES;
        
    }
    
    return _commentLabel;
    
}
@end
