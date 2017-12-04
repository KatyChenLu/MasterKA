//
//  ViewControllerCell.m
//  MasterKA
//
//  Created by jinghao on 16/6/22.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ViewControllerCell.h"

@implementation ViewControllerCell

- (void)awakeFromNib
{
//    @weakify(self);
//    [RACObserve(self, viewController) subscribeNext:^(UIViewController *vct) {
//        @strongify(self);
//        if (vct) {
//            [vct.view removeFromSuperview];
//            [self.contentView addSubview:vct.view];
//            [vct.view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self.contentView);
//            }];
//        }
//    }];
}

- (void)setViewController:(UIViewController *)viewController
{
    if (viewController) {
        [viewController.view removeFromSuperview];
        [self.contentView addSubview:viewController.view];
        [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}

@end
