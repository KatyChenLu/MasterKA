//
//  FaceUtil.m
//  HiGoMaster
//
//  Created by jinghao on 15/3/23.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "FaceUtil.h"
#define FACE_ICON_NAME      @"(:).+(:)"
@implementation FaceUtil
+ (NSDictionary*)getFaceDictionary{
    static NSMutableDictionary * dic=nil;
    if(dic==nil){
        dic = [NSMutableDictionary dictionary];
        NSArray* faceArray= [[self class] getFaceArray];
        for (id face in faceArray) {
            [dic setObject:face[@"value"] forKey:face[@"key"]];
        }
    }
    return dic;
}
+ (NSArray*)getFaceArray{
    static NSArray * array=nil;
    if(array==nil){
        NSString* path=[[NSBundle mainBundle] pathForResource:@"emoji_code" ofType:@"plist"];
        array =[NSArray arrayWithContentsOfFile:path];
    }
    return array;
}
@end
