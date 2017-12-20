//
//  KAPlaceAndMomentCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface KAPlaceAndMomentCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *KAimgView;
@property (weak, nonatomic) IBOutlet UILabel *KAtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *KAcontentLabel;
@property (weak, nonatomic) IBOutlet UILabel *KApeopleNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *KAPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dotImg;
- (void)showPlaces:(NSDictionary *)dic;
- (void)showMoment:(NSDictionary *)dic;
@end
