//
//  SequenceCell.m
//  MasterKA
//
//  Created by 余伟 on 17/1/10.
//  Copyright © 2017年 jinghao. All rights reserved.
//

#import "SequenceCell.h"

@interface SequenceCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SequenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStr:(NSString *)str
{
    _str = str;
    
    self.label.text = str;
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    
    
}

@end
