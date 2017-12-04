//
//  KAMapViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/1.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface KAMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UIGestureRecognizerDelegate , UITextFieldDelegate>
@property(nonatomic , strong)BMKMapView* mapView;

@end

@implementation KAMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
