//
//  HttpManagerCenter.m
//  MasterKA
//
//  Created by jinghao on 15/12/9.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "HttpManagerCenter.h"
#import "MJExtension.h"

#import <sys/utsname.h>

@interface HttpManagerCenter ()

@property (nonatomic,strong,readwrite)NSString *sessionId;



/**
 *  内部统一使用这个方法来向服务端发送请求
 *
 *  @param method       请求方式
 *  @param relativePath 相对路径
 *  @param parameters   参数
 *  @param resultClass  从服务器获取json数据后，解析成那个model
 *
 *  @return RACSignal   信号对象
 */
- (RACSignal *)requestWithMethod:(HttpMethod)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;

- (NSURLSessionTask *)requestWithMethod:(HttpMethod)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock;

@end

@implementation HttpManagerCenter
+ (instancetype)sharedHttpManager{
    static HttpManagerCenter *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        _sharedClient = [[HttpManagerCenter alloc] initWithBaseURL:[NSURL URLWithString:API_DOMAIN]];
        _sharedClient = [[HttpManagerCenter alloc] init];
    //        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.networtType = @"wan";
        //设置请求类型
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
            
        //设置接收接口输出类型
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        
        _sharedClient.requestSerializer.timeoutInterval = 30.f;
        
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status==AFNetworkReachabilityStatusReachableViaWWAN) {
                NSLog(@"移动网络");
                _sharedClient.networtType = @"wan";
            }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){
                NSLog(@"wifi网络");
                _sharedClient.networtType = @"wifi";
            }else if(status == AFNetworkReachabilityStatusUnknown){
                NSLog(@"位置网络");
                _sharedClient.networtType = @"unknown";
            }else{
                NSLog(@"访问网络失败");
            }
        }];
        
        
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
  
    
    return _sharedClient;
}

- (void)cancelAllRequest{
    [self.operationQueue cancelAllOperations];
}

- (void)canlel{
    
}

- (NSURLSessionTask*)doGet:(NSString*)url
                parameters:(NSDictionary *)parameters
               resultClass:(Class)resultClass
           webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock
{
    return [self requestWithMethod:HttpMethodGet relativePath:url parameters:parameters resultClass:resultClass webServiceBlock:webServiceBlock];
}


- (NSURLSessionTask*)doPost:(NSString*)url
                 parameters:(NSDictionary *)parameters
                resultClass:(Class)resultClass
            webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock
{
    return [self requestWithMethod:HttpMethodPost relativePath:url parameters:parameters resultClass:resultClass webServiceBlock:webServiceBlock];
}

- (NSURLSessionTask*)doDelete:(NSString*)url
                   parameters:(NSDictionary *)parameters
                  resultClass:(Class)resultClass
              webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock
{
    return [self requestWithMethod:HttpMethodDelete relativePath:url parameters:parameters resultClass:resultClass webServiceBlock:webServiceBlock];
}

- (NSURLSessionTask*)doPut:(NSString*)url
                parameters:(NSDictionary *)parameters
               resultClass:(Class)resultClass
           webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock
{
    return [self requestWithMethod:HttpMethodPut relativePath:url parameters:parameters resultClass:resultClass webServiceBlock:webServiceBlock];
}

- (NSURLSessionTask*)doPath:(NSString*)url
                 parameters:(NSDictionary *)parameters
                resultClass:(Class)resultClass
            webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock
{
    return [self requestWithMethod:HttpMethodPatch relativePath:url parameters:parameters resultClass:resultClass webServiceBlock:webServiceBlock];
}

- (NSURLSessionTask*)doHead:(NSString*)url
                 parameters:(NSDictionary *)parameters
                resultClass:(Class)resultClass
            webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock
{
    return [self requestWithMethod:HttpMethodHead relativePath:url parameters:parameters resultClass:resultClass webServiceBlock:webServiceBlock];
}


- (NSURLSessionTask*)doPostRequestWithUrl:(NSString*)url  WithParameter:(NSDictionary*)parameter{
    NSURLSessionDataTask* task = [self GET:url parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"doPostRequestWithUrl suecc %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"doPostRequestWithUrl error %@",error);
    }];
    return task;
}



- (RACSignal*)doRacGet:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass{
    return [self requestWithMethod:HttpMethodGet relativePath:url parameters:parameters resultClass:resultClass];
}

- (RACSignal*)doRacPost:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass{
    return [self requestWithMethod:HttpMethodPost relativePath:url parameters:parameters resultClass:resultClass];
}

- (RACSignal*)doRacDelete:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass{
    return [self requestWithMethod:HttpMethodDelete relativePath:url parameters:parameters resultClass:resultClass];
}

- (RACSignal*)doRacPut:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass{
    return [self requestWithMethod:HttpMethodPut relativePath:url parameters:parameters resultClass:resultClass];
}

- (RACSignal*)doRacPath:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass{
    return [self requestWithMethod:HttpMethodPatch relativePath:url parameters:parameters resultClass:resultClass];
}

- (RACSignal*)doRacHead:(NSString*)url parameters:(NSDictionary *)parameters resultClass:(Class)resultClass{
    return [self requestWithMethod:HttpMethodHead relativePath:url parameters:parameters resultClass:resultClass];
}


#pragma mark -- private

- (NSDictionary*)driveInfo{
    NSMutableDictionary * info = [NSMutableDictionary new];
    [info setObjectNotNull:self.networtType forKey:@"networt_type"];
    [info setObjectNotNull:[NSString stringWithFormat:@"%.0f x %.0f",ScreenWidth,ScreenHeight] forKey:@"screen"];
    [info setObjectNotNull:@"ios_ka" forKey:@"client"];
    [info setObjectNotNull:App_Version forKey:@"app_version"];
    [info setObjectNotNull:[[UIDevice currentDevice] systemName] forKey:@"d_brand"];//iphone
   
    
    [info setObjectNotNull:[HttpManagerCenter iphoneType] forKey:@"d_model"];//
    [info setObjectNotNull:[[UIDevice currentDevice] systemVersion] forKey:@"os_version"];
    [info setObjectNotNull:SharedAppDelegate.locationLat forKey:@"lat"];
    [info setObjectNotNull:SharedAppDelegate.locationLng forKey:@"lng"];
    [info setObjectNotNull:[UserClient sharedUserClient].city_code forKey:@"city_code"];

    
    NSString *appIdentifier = [NSString UUID];
    [info setObjectNotNull:appIdentifier forKey:@"uuid"];
    
//    [info setObjectNotNull:[UserClient sharedUserClient].accessToken forKey:@"token"];
    
    [info setObjectNotNull:[UserClient sharedUserClient].userInfo[@"token"]forKey:@"token"];
    
    //TODO  uuid  lng lat
    
    return info;
}

- (NSString*)getSignByParams:(NSDictionary*)params{
    NSArray *keys = [params allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *values = [NSMutableString new];
    for (NSString *key in sortedArray) {
        [values appendFormat:@"%@",[params objectForKey:key]];
//        [values appendString:[params objectForKey:key]];
    }
    return [values md5HexDigest];
}

- (NSMutableDictionary*)packageParameters:(NSDictionary*)parameters{
    NSMutableDictionary *postParams = [NSMutableDictionary new];
    NSMutableDictionary *realParams = [NSMutableDictionary new];
    
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *strTime=[NSString stringWithFormat:@"%.0f",time];
    [realParams setObjectNotNull:strTime forKey:@"timestamp"];
    if (parameters) {
        [realParams setValuesForKeysWithDictionary:parameters];
    }
    [postParams setObjectNotNull:[self driveInfo] forKey:@"device"];
    [postParams setObjectNotNull:Rest_Version forKey:@"rest_version"];
    [postParams setObjectNotNull:realParams forKey:@"data"];
    [postParams setObjectNotNull:[self getSignByParams:realParams] forKey:@"sign"];
    return postParams;
}

- (RACSignal *)requestWithMethod:(HttpMethod)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass{
    NSString* path = relativePath;
    NSString* methodStr = @"GET";
    switch (method) {
        case HttpMethodPost:
            methodStr = @"POST";
            break;
        case HttpMethodPut:
            methodStr = @"PUT";
            break;
        case HttpMethodDelete:
            methodStr = @"DELETE";
            break;
        case HttpMethodPatch:
            methodStr = @"PATCH";
            break;
        case HttpMethodHead:
            methodStr = @"HEAD";
            break;
        default:
            break;
    }
    NSLog(@"start rac request");
    NSDictionary *postParams = [self packageParameters:parameters];
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        NSString *urlString = [path hasPrefix:@"http"] ? path:[NSString stringWithFormat:@"%@?%@",API_DOMAIN,path];
        NSLog(@"method : %@ urlString  %@ postData:%@",methodStr,urlString,postParams);
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:methodStr URLString:urlString parameters:postParams error:nil];
        
        NSString *timeoutInterval = parameters[timeOut];
        if(timeoutInterval && ![timeoutInterval isEqualToString:@""]){
            double timeout = [timeoutInterval doubleValue];
            if(timeout && timeout>request.timeoutInterval && [request isKindOfClass:[NSMutableURLRequest class]]){
                ((NSMutableURLRequest*)request).timeoutInterval = timeout;
            }
        }
        NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            NSLog(@" url %@   error : %@",response.URL,error);
            NSLog(@"url %@ /n  responseObject %@",response.URL,responseObject);
            NSLog(@"end rac request");
            BaseModel* model = [BaseModel new];
            if (error) {
                model.code = 201;
                model.message = @"请求失败";
                [subscriber sendNext:model];

//                [subscriber sendNext:RACTuplePack(model, response)];
                
//                NSLog(@"start rac request error %@",error);
//                NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
//                if (responseObject) {
//                    userInfo[RACAFNResponseObjectErrorKey] = responseObject;
//                }
//                NSError *errorWithRes = [NSError errorWithDomain:error.domain code:error.code userInfo:[userInfo copy]];
//                [subscriber sendError:errorWithRes];
            } else {
                model.code = [[responseObject objectForKey:@"code"] integerValue];
                model.message = [responseObject objectForKey:@"msg"];
                model.alert = [responseObject objectForKey:@"alert"];
                if (![model.alert[@"msg"] isEqualToString:@""]) {
                    
                    MBProgressHUD * HUD = [[MBProgressHUD alloc]init];
                    
                    HUD.mode = MBProgressHUDModeText;
                    
                    HUD.labelText = model.alert[@"msg"];
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
                    
                    HUD.removeFromSuperViewOnHide = YES;
                    
                    [HUD show:YES];
                    
                    [HUD hide:YES afterDelay:2];
                    
                    
                }
                if (resultClass!=NULL) {
                    NSError* jsonError = nil ;
                    id data = [responseObject objectForKey:@"data"];
                    if ([data isKindOfClass:[NSArray class]]) {
                        model.data = [resultClass objectArrayWithKeyValuesArray:data error:&jsonError];
                    }else if([data isKindOfClass:[NSDictionary class]]){
                        model.data = [resultClass objectWithKeyValues:data error:&jsonError];
                        NSLog(@"data==+++++===%@",model.data);
                    }else if([data isKindOfClass:[NSNull class]]){
                        model.data = nil;
                    }else{
                        model.data = data;
                    }
                    if (jsonError==nil) {
                        [subscriber sendNext:model];
//                        [subscriber sendNext:RACTuplePack(model, response)];
                    }else{
                        [subscriber sendNext:model];
//                        [subscriber sendNext:RACTuplePack(model, response)];
                    }
                }else{
                    model.data = [responseObject objectForKey:@"data"];
                    //                    [subscriber sendNext:RACTuplePack(model, response)];
                    [subscriber sendNext:model];
                }
            }
           
//            NSString *cookies= ((NSHTTPURLResponse*)response).allHeaderFields[@"Set-Cookie"];
//            [self setCookies:cookies];
            [subscriber sendCompleted];
        }];
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

//- (NSURLSessionTask *)requestWithMethod:(HttpMethod)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass webServiceBlock:(void (^)(id data,NSError* error))webServiceBlock
//{
//    NSString* path = relativePath;
//    NSString* methodStr = @"GET";
//    switch (method) {
//        case HttpMethodPost:
//            methodStr = @"POST";
//            break;
//        case HttpMethodPut:
//            methodStr = @"PUT";
//            break;
//        case HttpMethodDelete:
//            methodStr = @"DELETE";
//            break;
//        case HttpMethodPatch:
//            methodStr = @"PATCH";
//            break;
//        case HttpMethodHead:
//            methodStr = @"HEAD";
//            break;
//        default:
//            break;
//    }
//    NSLog(@"start request");
//    NSString *urlString = [path hasPrefix:@"http"] ? path:[NSString stringWithFormat:@"%@?%@",API_DOMAIN,path];
//    NSLog(@"method : %@ urlString  %@",methodStr,urlString);
//
//    NSDictionary *postParams = [self packageParameters:parameters];
//    
//    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:methodStr URLString:path parameters:postParams success:^(NSURLSessionDataTask * tast, id responseObject) {
//        
//        NSLog(@"start request success");
//        if (resultClass!=NULL) {
//            BaseModel* model = [BaseModel new];
//            model.code = [[responseObject objectForKey:@"code"] integerValue];
//            model.message = [responseObject objectForKey:@"message"];
//            id data = [responseObject objectForKey:@"data"];
//            NSError* jsonError = nil ;
//            if ([data isKindOfClass:[NSArray class]]) {
//                model.data = [resultClass objectArrayWithKeyValuesArray:data error:&jsonError];
//            }else if([data isKindOfClass:[NSDictionary class]]){
//                model.data = [resultClass objectWithKeyValues:data error:&jsonError];
//            }else if([data isKindOfClass:[NSNull class]]){
//                model.data = nil;
//            }else{
//                model.data = data;
//            }
//            if (jsonError==nil) {
//                webServiceBlock(model,NULL);
//            }else{
//                webServiceBlock(responseObject,NULL);
//            }
//        }else{
//            webServiceBlock(responseObject,NULL);
//        }
//        NSLog(@"start request success object");        
//    } failure:^(NSURLSessionDataTask * tast, NSError * error) {
//        webServiceBlock(NULL,error);
//        NSLog(@"start rac request error");
//    }];
//    [dataTask resume];
//    return dataTask;
//}

- (void)setCookies:(NSString*)cookies{
    
    NSHTTPCookieStorage* cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    if (self.sessionId && [self.sessionId isEqualToString:cookies]) {
        return;
    }else if(cookies==nil){
//        [cookiesStorage.cookies delete:<#(nullable id)#>]
    }
    self.sessionId = cookies;
    
    NSMutableArray *cookisArray=[NSMutableArray arrayWithCapacity:20];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    NSArray *theArray = [cookies componentsSeparatedByString:@"; "];
    for (int i =0 ; i<[theArray count]; i++) {
        NSString *val=theArray[i];
        if ([val rangeOfString:@"="].length>0)
        {
            NSArray *subArray = [val componentsSeparatedByString:@"="];
            for (int i =0 ; i<[subArray count]; i++) {
                NSString *subVal=subArray[i];
                if ([subVal rangeOfString:@", "].length>0)
                {
                    NSArray *subArray2 = [subVal componentsSeparatedByString:@", "];
                    for (int i =0 ; i<[subArray2 count]; i++) {
                        NSString *subVal2=subArray2[i];
                        [cookisArray addObject:subVal2];
                    }
                }
                else
                {
                    [cookisArray addObject:subVal];
                }
            }
        }
        else
        {
            [cookisArray addObject:val];
        }
    }
    for (int idx=0; idx<cookisArray.count; idx+=2) {
        NSString *key=cookisArray[idx];
        NSString *value;
        if ([key isEqualToString:@"Expires"])
        {
            value=[NSString stringWithFormat:@"%@, %@",cookisArray[idx+1],cookisArray[idx+2]];
            idx+=1;
        }
        else
        {
            value=cookisArray[idx+1];
        }
        NSLog(@"cookie value:%@=%@",key,value);
        [cookieProperties setObject:value forKey:key];
    }
    
    [cookieProperties setObject:@"Master" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"sdfsdf" forKey:NSHTTPCookieValue];
    //关键在这里，要设置好domain的值，这样webview发起请求的时候就会带上我们设置好的cookies
    [cookieProperties setObject:[NSString stringWithFormat:@"mail.%@",WEB_DOMAIN] forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:WEB_DOMAIN forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    //[cookieProperties setObject:@"gtergr" forKey:@"Device-Model"];
    // 使用cookie传递参数
    NSLog(@"%@  \n  %@",cookieProperties,cookiesStorage.cookies);
    //cookie同步webview
//    NSHTTPCookie * userCookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//    [cookiesStorage setCookie:userCookie];
    
}

//返回手机具体型号(比如 5s 6s)
+ (NSString *)iphoneType {
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];

    return platform;
    
}


@end
