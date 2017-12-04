//
//  SelectDetailViewCell.h
//  MasterKA
//
//  Created by hyu on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *subName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subNameToleft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subToPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *choseImg;
-(void)showChoice:(NSDictionary *)dic ByIdentifier:(NSString *)identifier;
@end
