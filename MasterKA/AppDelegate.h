//
//  AppDelegate.h
//  MasterKA
//
//  Created by jinghao on 15/12/7.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
//百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "LoginView.h"

#import "SlideNavigationController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//当前经度
@property (nonatomic,strong)NSString *locationLng;
//当前维度
@property (nonatomic,strong)NSString *locationLat;
@property (nonatomic,assign)BOOL isAllScreen;
@property (nonatomic,copy)BMKUserLocation *locationInfo;
@property(nonatomic,weak)UIViewController* baseVC;
@property (nonatomic,assign)BOOL isfromprotocol;
@property(nonatomic,strong)LoginView* dengluview;
- (void)openAppMainVCT;

@end

