//
//  KACustomViewController.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/13.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KACustomViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (strong, nonatomic) NSMutableArray  *dataSource;
@end
