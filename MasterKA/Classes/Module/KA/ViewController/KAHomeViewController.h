//
//  KAHomeViewController.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseViewController.h"
#import "SlideNavigationController.h"
@interface KAHomeViewController : BaseViewController<SlideNavigationControllerDelegate>
@property (nonatomic, assign) NSInteger cnt;
@end
