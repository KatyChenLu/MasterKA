//
//  MainTabBarController.h
//  MasterKA
//
//  Created by jinghao on 15/12/22.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainTabBarController : UITabBarController<SlideNavigationControllerDelegate>

@property (nonatomic,strong)NSArray *tabBarBtn;

@end
