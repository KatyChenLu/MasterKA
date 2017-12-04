//
//  MasterMsg.m
//  MasterKA
//
//  Created by 余伟 on 16/12/22.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterMsg.h"

@interface MasterMsg ()

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *nikeName;

@property (weak, nonatomic) IBOutlet UILabel *intro;



@end

@implementation MasterMsg

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)masterMsg;
{
    
    MasterMsg * MasterMsg = [[[NSBundle mainBundle]loadNibNamed:@"MasterMsg" owner:nil options:nil]lastObject];
    
    return MasterMsg;
    
}


- (IBAction)more:(id)sender {
    
    self.msg();
}



-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
//    NSDictionary * DIC = dic[0];
    
    [self.headImage setImageWithURLString:dic[@"img_top"]];
    self.intro.text = dic[@"intro"];
    self.nikeName.text = dic[@"nikename"];

    
}


@end
