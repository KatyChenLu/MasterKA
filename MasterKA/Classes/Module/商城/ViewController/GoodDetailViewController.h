//
//  GoodDetailViewController.h
//  MasterKA
//
//  Created by hyu on 16/5/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"
#import "CouseDetailHeadView.h"
@interface GoodDetailViewController : BaseViewController
@property (strong , nonatomic) NSString *course_id;
@property (weak, nonatomic) IBOutlet UIButton *yueIt;
@property (strong, nonatomic) IBOutlet UIButton *question;
@property (weak, nonatomic) IBOutlet UIView *groupView;

@property(weak,nonatomic) IBOutlet UIButton * group_buyBtn;

@property (weak, nonatomic) IBOutlet UIView *aloneView;

@property (weak, nonatomic) IBOutlet UIButton *teleToCompany;
@property (nonatomic,strong)UIImageView *mineHeadView;

@property (weak, nonatomic) IBOutlet UIView *isGroupCourse;

@property (weak, nonatomic) IBOutlet UILabel *groupLab;

@property (weak, nonatomic) IBOutlet UILabel *groupPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *alonelab;


@property (weak, nonatomic) IBOutlet UILabel *alonePriceLab;

@property (weak, nonatomic) IBOutlet UIButton *alone_buyBtn;





@end
