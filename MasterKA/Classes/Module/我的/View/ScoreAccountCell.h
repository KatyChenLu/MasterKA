//
//  ScoreAccountCell.h
//  MasterKA
//
//  Created by hyu on 16/5/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *instruct;
@property (weak, nonatomic) IBOutlet UILabel *addtime;
@property (weak, nonatomic) IBOutlet UILabel *getOrput;
-(void)showScoreAccount:(NSDictionary *)dic;
@end
