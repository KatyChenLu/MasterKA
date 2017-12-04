//
//  InterestCollectionViewCell.m
//  MasterKA
//
//  Created by jinghao on 16/1/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "InterestCollectionViewCell.h"

@implementation InterestCollectionViewCell

- (void)awakeFromNib
{
    self.choiced = FALSE;
    self.interestImageView.cornerRadius = 8.0f;
    self.maskView.cornerRadius = 8.0f;
}

- (void)setChoiced:(BOOL)choiced
{
    _choiced = choiced;
    if (choiced) {
        self.maskView.backgroundColor = [UIColor colorWithHex:0x19AA23 alpha:0.3];
        self.interestSelectImageView.hidden = FALSE;
    }else{
        self.maskView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3];
        self.interestSelectImageView.hidden = TRUE;
    }
}

@end
