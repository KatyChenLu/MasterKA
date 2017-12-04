//
//  MyCardCell.h
//  MasterKA
//
//  Created by hyu on 16/4/29.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITextView *infoText;
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
@property (weak, nonatomic) IBOutlet UILabel *cardTitle;
@property (weak, nonatomic) IBOutlet UILabel *cartPrice;
@property (weak, nonatomic) IBOutlet UILabel *cardTIme;
@property (weak, nonatomic) IBOutlet UIView *balckView;
-(void)showCard:(NSDictionary *)dic;

-(void)showCardForSale:(NSDictionary *)dic;

@end
