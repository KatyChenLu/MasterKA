//
//  CourseModel.m
//  MasterKA
//
//  Created by jinghao on 16/5/9.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"tags" : @"tags_name"
             };
}

//- (NSString*)getPriceString;
//{
//    NSString *str = [NSString stringWithFormat:@"￥%@",self.price];
//    if (self.is_mpay.intValue==1) {
//        str = [NSString stringWithFormat:@"%@ M",self.m_price];
//    }
//    return str;
//}
//- (NSString*)getMakertPriceString
//{
//    if(self.show_market_price && self.show_market_price.length>0){
//        NSString *str = [NSString stringWithFormat:@"￥%@",self.show_market_price];
////        if (self.is_mpay.intValue==1) {
////            str = [NSString stringWithFormat:@"%@ M",self.show_market_price];
////        }
//        return str;
//    }else{
//        return self.show_market_price;
//    }
//}
@end
