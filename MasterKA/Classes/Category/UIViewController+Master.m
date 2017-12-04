//
//  UIViewController+Master.m
//  MasterKA
//
//  Created by jinghao on 15/12/18.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "UIViewController+Master.h"
#import "MBProgressHUD.h"

@implementation UIViewController (Master)

+ (UIViewController*)viewControllerDefaultStoryboardWithIdentifier:(NSString*)identifier{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
}

+ (UIViewController*)viewControllerWithStoryboard:(NSString*)storyboard identifier:(NSString*)identifier{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyboard
                                                             bundle: nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
}

+ (UIViewController*)viewControllerWithName:(NSString*)name
{
    UIViewController *cvt = nil;
    @try {
         NSArray *views = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
        if (views.count>0) {
            Class class = NSClassFromString(name);
            cvt = (UIViewController *)[[class alloc] initWithNibName:name bundle:nil];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    if (cvt == nil) {
        Class class = NSClassFromString(name);
        cvt = (UIViewController *)[[class alloc] init];
    }
    return cvt;
}

- (void)hidesTabBar:(BOOL)hidden
{
    if(hidden){
        [self hideTabBar];
    }else{
        [self showTabBar];
    }
}


- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    self.tabBarController.tabBar.hidden = YES;
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
  
    
    NSLog(@"========hideTabBar");
}

- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    self.tabBarController.tabBar.hidden = NO;
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);

    
    
    NSLog(@"========showTabBar");

}

- (void)pushViewController:(UIViewController*) viewController animated:(BOOL)animated
{
//    [[GCDQueue mainQueue] queueBlock:^{
//        UITabBarController * tabBar = (UITabBarController*)[[SlideNavigationController sharedInstance].viewControllers firstObject];
//        UINavigationController *nav = (UINavigationController*)[tabBar selectedViewController];
//        [nav pushViewController:viewController animated:animated];
//        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
//
//        }];
//
//    }];
     [self.navigationController pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController animated:NO];
}


- (void)setCallbackBlock:(ViewControlerCallback)callbackBlock{
    objc_setAssociatedObject(self, @selector(callbackBlock), callbackBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ViewControlerCallback)callbackBlock
{
    ViewControlerCallback callback = objc_getAssociatedObject(self, @selector(callbackBlock));
    return callback;
}

- (void)setVctAnimation:(ViewControllerAnimation *)vctAnimation
{
    objc_setAssociatedObject(self, @selector(vctAnimation), vctAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ViewControllerAnimation*)vctAnimation
{
    ViewControllerAnimation* vctAn = objc_getAssociatedObject(self, @selector(vctAnimation));
    if (vctAn==nil) {
        vctAn = [[ViewControllerAnimation alloc] init];
        self.vctAnimation = vctAn;
    }
    return vctAn;
}
- (void)showActionSheetForImage:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];
    @weakify(self)
    [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        @strongify(self)
        if (buttonIndex.integerValue==0) {//从相册
            UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
            pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerLibrary.delegate = delegate;
            pickerLibrary.allowsEditing = allowsEditing;
            [self presentViewController:pickerLibrary animated:YES completion:nil];
        }else if(buttonIndex.integerValue==1){//拍照
            UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
            pickerLibrary.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerLibrary.delegate = delegate;
            pickerLibrary.allowsEditing = allowsEditing;
            [self presentViewController:pickerLibrary animated:YES completion:nil];
        }
    }];
}
@end


@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(canGotoBack)]) {
        shouldPop = [vc canGotoBack];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // Workaround for iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    
    return NO;
}


@end
