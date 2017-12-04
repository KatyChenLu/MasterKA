//
//  OrderInformationCell.h
//  MasterKA
//
//  Created by hyu on 16/6/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *QR_Code;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *thisOrderId;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *classTime;
@property (weak, nonatomic) IBOutlet UILabel *specName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *QRstatus;

@property (weak, nonatomic) IBOutlet UILabel *recivePeo;
@property (weak, nonatomic) IBOutlet UILabel *reciveAddr;

@property (weak, nonatomic) IBOutlet UILabel *recivePeoData;
@property (weak, nonatomic) IBOutlet UILabel *reciveAddrData;

@property (weak, nonatomic) IBOutlet UILabel *classAddr;
-(void)prepareView :(NSDictionary *)orderInfo;
@property (weak, nonatomic) IBOutlet UIButton *refuseOrder;
@end
