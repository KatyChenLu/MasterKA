//
//  MyFansCell.h
//  MasterKA
//
//  Created by hyu on 16/4/29.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFansCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fansHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *fansName;
@property (weak, nonatomic) IBOutlet UILabel *fansSay;
@property (weak, nonatomic) IBOutlet UIButton *fansFollow;
@property (weak, nonatomic) IBOutlet UIButton *removeFollow;
-(void)showMyfans:(NSDictionary *)dic identity:(NSString *)identity shareId:(NSString*)shareId;

@end
