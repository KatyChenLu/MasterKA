//
//  PopControllerToolsView.h
//  MasterKA
//
//  Created by jinghao on 16/5/9.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopControllerToolsView : UIView
@property (nonatomic,weak)IBOutlet UILabel *titleView;
@property (nonatomic,weak)IBOutlet UIButton *closeButton;
@property (nonatomic,weak)IBOutlet UIButton *cancleButton;
@property (nonatomic,assign)BOOL showCancleButton;


@property(nullable, nonatomic) SEL                  closeAction;           // default is NULL
@property(nullable, nonatomic,weak)id                   closeTager;

@end
