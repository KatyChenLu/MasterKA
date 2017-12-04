//
//  MapViewController.m
//  MasterKA
//
//  Created by hyu on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MapViewController.h"
#import "SlideNavigationController.h"
#import "CLPaoPaoView.h"

@interface MapViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong)CLPaoPaoView* clPaoPaoView;
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.info[@"title"];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
     _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    NSLog(@"进入普通定位态");
    _mapView.gesturesEnabled = YES;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.zoomLevel = 16;//设置放大级别
    //  _mapView.region = visibleMapRect
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude =[self.info[@"latitude"] doubleValue];
    coor.longitude = [self.info[@"longitude"] doubleValue];
    annotation.coordinate = coor;
    annotation.title = self.info[@"title"];
    annotation.subtitle = self.info[@"address"];
    
    [_mapView addAnnotation:annotation];
    
    
    [_mapView setCenterCoordinate:coor animated:YES];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SlideNavigationController sharedInstance].enableSwipeGesture = NO;

    [_mapView viewWillAppear];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)dealloc {
    NSLog(@"======== %@",self)
    if (_mapView) {
        _mapView = nil;
    }
    if (_locService) {
        _locService = nil;
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark - BMKMapViewDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    
    static NSString *ID=@"annoView";
    BMKAnnotationView *annoView=[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView==nil) {
        annoView=[[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        //点击大头针出现信息（自定义view的大头针默认点击不弹出）
        annoView.canShowCallout=YES;
        annoView.selected = YES;
    }
    annoView.draggable = NO;
    _clPaoPaoView = [[[NSBundle mainBundle] loadNibNamed:@"CLPaoPaoView" owner:nil options:nil] firstObject];
    _clPaoPaoView.titleLabel.text = self.info[@"address"];
    _clPaoPaoView.weizhiLabel.text = self.info[@"title"];
    @weakify(self);
    [_clPaoPaoView setBlock:^(){
        @strongify(self);
        [self daohangAction];
    }];
    
    annoView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:self.clPaoPaoView];
//    //再传递一次annotation模型（赋值）
    annoView.annotation=annotation;
    
    annoView.image=[UIImage imageNamed:@"Pin"];
    
    
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//    rightButton.backgroundColor = [UIColor clearColor];
//    [rightButton setImage:[UIImage imageNamed:@"zhixiang"]  forState:UIControlStateNormal];
//    
//    rightButton.backgroundColor = [UIColor grayColor];
//    
//    [rightButton addTarget:self action:@selector(daohangAction) forControlEvents:UIControlEventTouchUpInside];
//    annoView.rightCalloutAccessoryView = rightButton;
    
    return annoView;
}

- (void)daohangAction {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    CLLocationCoordinate2D coor;
    coor.latitude =[self.info[@"latitude"] doubleValue];
    coor.longitude = [self.info[@"longitude"] doubleValue];
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor addressDictionary:nil]];
        
        currentLocation.name = @"我的位置";
        toLocation.name = self.info[@"title"];
        
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
         
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
        
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@ &backScheme=%@ &lat=%f&lon=%f&dev=0&style=2",@"Master",@"",coor.latitude,coor.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        @weakify(self)
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coor.latitude,coor.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

//-(void)mapView:(BMKMapView *)mapView annotationView:(nonnull MKAnnotationView *)view calloutAccessoryControlTapped:(nonnull UIControl *)control {
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    
//    CLLocationCoordinate2D coor;
//    coor.latitude =[self.info[@"latitude"] doubleValue];
//    coor.longitude = [self.info[@"longitude"] doubleValue];
//    //自带地图
//    [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        NSLog(@"alertController -- 自带地图");
//        
//        //使用自带地图导航
//        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
//        
//        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor addressDictionary:nil]];
//        
//        currentLocation.name = @"我的位置";
//        toLocation.name = self.info[@"title"];
//        
//        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
//                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
//        
//        
//    }]];
//    
//    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
//    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
//        
//        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            NSLog(@"alertController -- 高德地图");
//            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",coor.latitude,coor.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
//            
//        }]];
//    }
//    
//    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
//        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            NSLog(@"alertController -- 百度地图");
//            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",coor.latitude,coor.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
//            
//        }]];
//    }
//    
//    //添加取消选项
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//        [alertController dismissViewControllerAnimated:YES completion:nil];
//        
//    }]];
//    
//    //显示alertController
//    [self presentViewController:alertController animated:YES completion:nil];
//    
//
//}
//- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
