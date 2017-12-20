//
//  KACustomViewController.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/13.
//  Copyright © 2017年 chenlu. All rights reserved.
//

//typedef NS_ENUM(NSInteger, CourseCustomType) {
//    CustomView_none = 0,
//    CustomView_course,
//};

#import <UIKit/UIKit.h>

@interface KACustomViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (weak, nonatomic) IBOutlet UIButton *addVoteBtn;

//@property (nonatomic,assign)CourseCustomType *courseCustomType
@property (nonatomic, strong) NSString *courseID;
@property (nonatomic, strong) NSString *courseTitle;
@property (strong, nonatomic) NSMutableArray  *dataSource;
@end
