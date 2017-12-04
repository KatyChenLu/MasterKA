//
//  GuessLikeCollectionCell.h
//  MasterKA
//
//  Created by hyu on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuessLikeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UILabel *distance;
-(void)showGuessLike:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet UIView *lineShow;
@end
