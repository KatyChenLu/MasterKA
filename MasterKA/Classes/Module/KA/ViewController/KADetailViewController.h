//
//  KADetailViewController.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface KADetailViewController : BaseViewController
@property (nonatomic,strong)UIImageView *mineHeadView;
@property (nonatomic, copy)NSString *headViewUrl;
@property (strong , nonatomic) NSString *ka_course_id;

@end
