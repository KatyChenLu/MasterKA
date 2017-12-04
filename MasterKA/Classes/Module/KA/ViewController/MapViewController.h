//
//  MapViewController.h
//  MasterKA
//
//  Created by hyu on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface MapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    IBOutlet BMKMapView* _mapView;
    BMKLocationService* _locService;
}
@property(nonatomic, strong) NSDictionary *info;
@end
