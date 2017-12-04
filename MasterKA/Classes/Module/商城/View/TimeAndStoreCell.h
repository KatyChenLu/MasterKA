//
//  TableViewCell.h
//  MasterKA
//
//  Created by hyu on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeAndStoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_iden;
@property (weak, nonatomic) IBOutlet UILabel *name;
-(void)showTimeAndStore:(NSDictionary *)dic;
@end
