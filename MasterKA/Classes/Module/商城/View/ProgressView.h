//
//  ProgressView.h
//  MasterKA
//
//  Created by 余伟 on 16/12/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property(nonatomic , strong)id  dic;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+(instancetype)progress;



@end
