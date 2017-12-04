//
//  MapCourseController.m
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MapCourseController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "HttpManagerCenter+Course.h"
#import "MapCourseModel.h"
#import "MapModels.h"
#import "MapDetalCourse.h"
#import "MapCourseAnnotation.h"
#import "GoodDetailViewController.h"
#import "CategorySelectView.h"
static dispatch_once_t onceToken;


@interface MapCourseController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UIGestureRecognizerDelegate , UITextFieldDelegate>
@property(nonatomic , strong)BMKMapView* mapView;

@property(nonatomic ,strong)BMKLocationService * locService;

@property(nonatomic , strong)BMKUserLocation * userLocation;

@property(nonatomic ,strong)UITextField*  searchView;

@property(nonatomic, strong)NSArray * annotations;

@property(nonatomic , strong)id category;//分类

@property(nonatomic ,copy)NSString * lag;

@property(nonatomic , copy)NSString * lat;

@property(nonatomic ,strong)UIButton * myLocation;


@end

@implementation MapCourseController
{
    MapDetalCourse * _bgview;
    BOOL _empty;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@" , self.categorys);

    
    onceToken = 0;
    
    self.myLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.myLocation setImage:[UIImage imageNamed:@"dingwei-"] forState:UIControlStateNormal];
    
//    self.myLocation.frame = CGRectMake(ScreenWidth - 30, ScreenHeight - 30, 20, 20);
    
    if (IsPhoneX) {
        self.myLocation.frame = CGRectMake(ScreenWidth - 30, ScreenHeight - 30 - 34, 20, 20);
    }else{
        self.myLocation.frame = CGRectMake(ScreenWidth - 30, ScreenHeight - 30, 20, 20);
    }
    
    [self.myLocation addTarget: self action:@selector(loc:) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.myLocation];
    
    self.navigationItem.titleView = self.searchView;

    self.searchView.delegate = self;
    
    self.searchView.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fangda"]];
    
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [searchBtn setImage:[UIImage imageNamed:@"BackNormal"] forState:UIControlStateNormal];
    
    searchBtn.size = CGSizeMake(35, 44);
    
    [searchBtn addTarget: self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = searchItem;
    
    CategorySelectView * category = [[CategorySelectView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    category.backgroundColor = [UIColor whiteColor];

    [category setFilter:^(id  category) {

        self.category = category==nil?@"":category;
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [self initRemoteWithLag:self.lag lat:self.lat category:self.category];
        
        
//
//        if (category == nil) {
//
//            [self.mapView addAnnotations:self.annotations];
//           
//            return ;
//        }
//        
//        
//        NSArray * arr = self.mapView.annotations;
//        
//        
//        for (int i = 0; i < arr.count; i++) {
//            
//            MapCourseAnnotation * annotation = arr[i];
//            MapModels * model = annotation.model;
//            
//            if (![model.p_category_id isEqualToString:category]) {
//                
//                [self.mapView removeAnnotation:annotation];
//            }
//         
//            
//        }
        
    }];
  
    [self.view addSubview:category];
    
    category.categorys = self.categorys;
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 44, self.view.width , self.view.height-44)];
     self.mapView.zoomLevel = 16;//设置放大级别
    
    [self.view addSubview:self.mapView];
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    self.locService = [[BMKLocationService alloc]init];
//    _locService.distanceFilter = 200;//设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位会增加耗电量
//    _locService.desiredAccuracy = kCLLocationAccuracyHundredMeters;//设定定位精度
//    //开启定位服务
    [_locService startUserLocationService];
    
    self.mapView.scrollEnabled = YES;
    
    self.mapView.showMapScaleBar = YES;
    
    self.mapView.mapScaleBarPosition = CGPointMake(self.view.width-70, self.view.height-114);
    
  
    
    
    
//    self.mapView.centerCoordinate = self.locService.userLocation.location.coordinate;
    
//    BMKCoordinateRegion region ;//表示范围的结构体
//    CLLocationCoordinate2D coor;
//    coor = _locService.userLocation.location.coordinate;
    
//    region.center = coor;//中心点
//    region.span.latitudeDelta = 0.5;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
//    region.span.longitudeDelta = 0.5;//纬度范围
//    [_mapView setRegion:region animated:YES];
    
    
//    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
//    [_mapView setRegion:adjustedRegion animated:YES];
//     BMKLocationViewDisplayParm  设置方向跟随
//    BMKLocationViewDisplayParam* displayParam = [[BMKLocationViewDisplayParam alloc] init];
//    displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
//    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
//    displayParam.locationViewOffsetX = 0.01;//定位偏移量（经度）
//    displayParam.locationViewOffsetY = 0.01;//定位偏移量（纬度）
//    [_mapView updateLocationViewWithParam:displayParam];
//    
    

}


- (UITextField*)searchView
{
    if (!_searchView) {
        _searchView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 30)];
        [_searchView setBackgroundColor:[UIColor colorWithHex:0xffffff]];
        [_searchView setCornerRadius:15];
        _searchView.font = [UIFont systemFontOfSize:13.0f];
        _searchView.returnKeyType  = UIReturnKeySearch;
        _searchView.enablesReturnKeyAutomatically = NO;
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
        
        _searchView.leftView =leftView;
        
        _searchView.leftViewMode = UITextFieldViewModeAlways;
        _searchView.placeholder =@"在地图中搜索:";
        [_searchView setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchView.tintColor = [UIColor colorWithHex:0xe2b910];
        
    }
    return _searchView;
}

-(void)search:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        
        
    }];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // 添加一个PointAnnotation
    self.myLocation.hidden = NO;
   }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    self.myLocation.hidden = YES;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

-(void)loc:(UIButton *)sender
{
     [_mapView setCenterCoordinate:_userLocation.location.coordinate animated:YES];
    
}



#pragma UITextViewDelegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSLog(@"%@" , textField.text);
    
    
    [self initRemoteWithLag:self.lag lat:self.lat category:self.category];
    
    
    
       return YES;
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
    
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation];
   
    self.userLocation = userLocation;
    
        dispatch_once(&onceToken, ^{
    
             [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
            NSString * lag = [NSString stringWithFormat:@"%lf" , _locService.userLocation.location.coordinate.longitude];
            //
            NSString * lat = [NSString stringWithFormat:@"%lf" , _locService.userLocation.location.coordinate.latitude];
            
            self.lag = lag;
            self.lat = lat;
            
            [self initRemoteWithLag:lag lat:lat category:@""];
    
        });

}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        
        MapCourseAnnotation *mapAnnotation = (MapCourseAnnotation*)newAnnotationView.annotation;
        
        MapModels * model = mapAnnotation.model;
        
        
        NSString * url = model.category_pic_url;
     
        
        NSRange range;
        range = [url rangeOfString:@"."];
        if (range.location != NSNotFound) {
            NSLog(@"found at location = %lu, length = %lu",(unsigned long)range.location,(unsigned long)range.length);
            NSString *ok = [url substringFromIndex:range.location];
            NSLog(@"%@",ok);
            
          url = [NSString stringWithFormat:@"%@_50%@", [url substringToIndex:range.location],[url substringFromIndex:range.location]];
            
        }else{
            NSLog(@"Not Found");  
        }
           url = [url masterFullImageUrl];
        
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRefreshCached progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            
            newAnnotationView.image = image;
        }];
        
       
        
      //  newAnnotationView.image = [UIImage imageNamed:@"search"];
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.canShowCallout = NO;

        return newAnnotationView;
    }
    return nil;
}


-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
    NSLog(@"didSelectAnnotationView");
    
    
    if ([view.annotation isKindOfClass:[MapCourseAnnotation class]]) {
        
        
        MapCourseAnnotation * annotation = view.annotation;
        
        
        if (!_bgview) {

            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            
            _bgview = [[MapDetalCourse alloc]initWithFrame:CGRectMake(10, ScreenHeight, ScreenWidth-20, 80)];
            
                _bgview.backgroundColor = [UIColor whiteColor];
            
            [_bgview addGestureRecognizer:tap];
            
            
            
            [self.view addSubview:_bgview];
            
     //       [_bgview layoutIfNeeded];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _bgview.transform = CGAffineTransformMakeTranslation(0, -150);
                self.myLocation.transform = CGAffineTransformMakeTranslation(0, -90);
            }];
        }
        
        _bgview.model = annotation.model;
    }
    
}


-(void)tap:(UITapGestureRecognizer *)tap{
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    
    GoodDetailViewController *goodVc = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    
    
    goodVc.params= @{@"courseId":_bgview.model.course_id,@"coverStr":_bgview.model.cover};
    
    [self.navigationController pushViewController:goodVc animated:YES];
}


- (void)mapStatusDidChanged:(BMKMapView *)mapView;
{
    
    NSLog(@"latitude===%f  ,longitude===%f " , self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude);
 
    NSLog(@"mapStatusDidChanged");
    
}


- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;
{

    NSString * lag = [NSString stringWithFormat:@"%lf" , _mapView.centerCoordinate.longitude];
    //
    NSString * lat = [NSString stringWithFormat:@"%lf" , _mapView.centerCoordinate.latitude];
    
    self.lag = lag;
    self.lag = lag;
    
    [self  initRemoteWithLag:lag lat:lat category:self.category];
    
    [_bgview removeFromSuperview];
    _bgview = nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.myLocation.transform = CGAffineTransformIdentity;
    }];
    
}





-(void)initRemoteWithLag:(NSString *)lagStr lat:(NSString *)latStr category:(NSString *)category
{
   
    
    
    RACSignal * signal = [[HttpManagerCenter sharedHttpManager]queryCourseWithLng:lagStr AndLat:latStr withCategoryId:category resultClass:[MapCourseModel class]];
    
    
    @weakify(self)
    [signal subscribeNext:^(BaseModel * model) {
        @strongify(self)
        
        if (model.code == 200) {
            
            NSLog(@"%@" , model.data);
            
            MapCourseModel * course = model.data;
            
            MapModels * mapModel = nil;
            
            [self.mapView removeAnnotations:self.mapView.annotations];
            for (int i = 0; i < course.course_list.count; i++) {
                
                mapModel = course.course_list[i];
                
                MapCourseAnnotation* annotation = [[MapCourseAnnotation alloc]init];
                CLLocationCoordinate2D coor;
                coor.latitude = [mapModel.lat floatValue];
                coor.longitude = [mapModel.lng floatValue];
                annotation.coordinate = coor;
                annotation.title = mapModel.title;
                annotation.model = mapModel;
                [_mapView addAnnotation:annotation];

            }
            
            if ([self.searchView.text isEqualToString:@""]||self.searchView.text == nil) {
                
            }else{
                
                NSMutableArray * anno = [NSMutableArray arrayWithCapacity:10];
                for (int i = 0; i < self.mapView.annotations.count; i++) {
                    
                    MapCourseAnnotation * annotation = self.mapView.annotations[i];
                    MapModels * model = annotation.model;
                    
                    
                    if (![model.title containsString:self.searchView.text options:NSForcedOrderingSearch]) {
                        
                        
                        [anno addObject:annotation];
                        
                    }else
                    {
                        _empty = YES;
                    }
                    
                }
                
                [self.mapView removeAnnotations:anno];
                if (!_empty) {
                    
                    
                    
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"附近没有相关课程,可以尝试其他关键字" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                    
                    [alert show];
                }
            }
         
            


       

            
          
            CLLocationCoordinate2D  northEast = [self.mapView convertPoint:CGPointMake(self.mapView.width, 0) toCoordinateFromView:self.mapView];
            //
            CLLocationCoordinate2D southWest = [self.mapView convertPoint:CGPointMake(0, self.mapView.height) toCoordinateFromView:self.mapView];
            
            BMKCoordinateBounds bound;
            bound.southWest = southWest;
            bound.northEast = northEast;
            //
            
            NSLog(@"--------%f", northEast.latitude);
            NSLog(@"%f", southWest.latitude);
            
            
            
            self.annotations = self.mapView.annotations;
            //
            //            [self.mapView showAnnotations:  [self.mapView annotationsInCoordinateBounds:bound] animated:YES];
            
            
        }
        
        
    }];

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
