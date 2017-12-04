//
//  UIViewController+Master.h
//  MasterKA
//
//  Created by jinghao on 15/12/18.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerAnimation.h"
@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)canGotoBack;

@end

typedef void (^ViewControlerCallback) (id callBackData);


@interface UIViewController (Master)<BackButtonHandlerProtocol>

@property (nonatomic,readonly,strong)ViewControllerAnimation* vctAnimation;

@property (nonatomic,strong)ViewControlerCallback callbackBlock;

+ (UIViewController*)viewControllerDefaultStoryboardWithIdentifier:(NSString*)identifier;

+ (UIViewController*)viewControllerWithStoryboard:(NSString*)storyboard identifier:(NSString*)identifier;

+ (UIViewController*)viewControllerWithName:(NSString*)name;

- (void)hidesTabBar:(BOOL)hidden;

- (void)pushViewController:(UIViewController*) viewController animated:(BOOL)animated;

- (void)pushViewController:(UIViewController*) viewController;

- (void)showActionSheetForImage:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing;

@end
