//
//  MasterWebViewController.m
//  MasterKA
//
//  Created by jinghao on 16/1/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterWebViewController.h"
#import <WebKit/WebKit.h>
#import "MainTabBarController.h"

@interface MasterWebViewController ()<UIWebViewDelegate,UIActionSheetDelegate,WKNavigationDelegate,WKScriptMessageHandler>
{
    NSTimer *_timer;	// 用于UIWebView保存图片
    int _gesState;	  // 用于UIWebView保存图片
    NSString *_imgURL;  // 用于UIWebView保存图片
}

@property (nonatomic,strong)WKWebView *mWkWebView;
@property (nonatomic,strong)UIWebView *mWebView;
@property (nonatomic,strong)UIBarButtonItem *closeWebViewItem;
@property (nonatomic,strong)UIBarButtonItem *shareButtonItem;
@property (nonatomic,strong)NSDictionary *shareDict;
@property (nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong)UIProgressView *progressView;

@end


static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";

// 用于UIWebView保存图片
enum
{
    GESTURE_STATE_NONE = 0,
    GESTURE_STATE_START = 1,
    GESTURE_STATE_MOVE = 2,
    GESTURE_STATE_END = 4,
    GESTURE_STATE_ACTION = (GESTURE_STATE_START | GESTURE_STATE_END),
};

@implementation MasterWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mWkWebView];
    [self.view addSubview:self.progressView];
    
    
    [self.view addSubview:self.activityIndicatorView];
    [self.mWkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.right.and.top.and.left.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);

    }];
    
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    [self.mWkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self loadRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    NSLog(@"beginWebView");
    [self addNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    [self.mWkWebView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    self.mWkWebView = nil;
}


- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginNotification:) name:MasterUserLoginNotification object:nil];
}

- (void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MasterUserLoginNotification object:nil];
}

- (void)userLoginNotification:(id)sender{
    if (self.mWkWebView.canGoBack) {
        [self.mWkWebView reload];
    }else{
        [self loadRequest];
    }
}

- (BOOL)canGotoBack
{
    if ([self.mWkWebView canGoBack]) {
        if (self.navigationItem.leftBarButtonItems.count<2) {
            [self.navigationItem addLeftBarButtonItem:self.closeWebViewItem animated:TRUE];
        }
        [self.mWkWebView goBack];
        return FALSE;
    }else{
        return TRUE;
    }
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIActivityIndicatorView*)activityIndicatorView
{
    if(!_activityIndicatorView){
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

- (UIBarButtonItem*)closeWebViewItem{
    if (!_closeWebViewItem) {
        _closeWebViewItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    }
    return _closeWebViewItem;
}

//- (UIWebView*)mWebView{
//    if (!_mWebView) {
//        _mWebView = [[UIWebView alloc] init];
//        _mWebView.delegate = self;
//        _mWebView.opaque = NO;
//        _mWebView.backgroundColor = [UIColor clearColor];
//    }
//    return _mWebView;
//}

- (WKWebView *)mWkWebView {
    if (!_mWkWebView) {
        
        //        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //        WKUserContentController *userContent = [[WKUserContentController alloc] init];
        //        [userContent addScriptMessageHandler:self name:@"NativeMethod"];
        //        config.userContentController = userContent;
        _mWkWebView = [[WKWebView alloc] init];
        _mWkWebView.navigationDelegate = self;
        
        
    }
    return _mWkWebView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  2)];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 4.0f);
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}

- (void)loadRequest {
    if (! [@"http" isEqualToString:[self.url protocol]]&&! [@"https" isEqualToString:[self.url protocol]]) {
        self.url = [NSURL URLWithString:[self.params objectForKey:@"url"]];
    }
    
    NSLog(@"-----%@" , self.url);
    
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:self.url];
    
    [requestObj addMasterHeadInfo];
    
    [self.mWkWebView loadRequest:requestObj];
}

- (UIBarButtonItem*)shareButtonItem
{
    if (!_shareButtonItem) {
        _shareButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Share_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonOnClick:)];
    }
    return _shareButtonItem;
}

- (void)shareButtonOnClick:(id)sender{
    if(self.shareDict){
        [self shareContentOfApp:self.shareDict];
    }
}

- (void)setShareDict:(NSDictionary *)shareDict
{
    _shareDict = shareDict;
    if (shareDict) {
        [self.navigationItem setRightBarButtonItem:self.shareButtonItem animated:YES];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark ——— WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    [self.activityIndicatorView startAnimating];
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.activityIndicatorView stopAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.activityIndicatorView stopAnimating];
    
    //设置title
    NSString *title = webView.title;
    if(![title isEmpty]){
        self.title=title;
    }
    
    //设置分享信息
    [webView evaluateJavaScript:@"app_share();" completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        
        if (item && [item isKindOfClass:[NSString class]]) {
            self.shareDict = [NSJSONSerialization JSONObjectWithData:[item dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
            
        }else{
            self.shareDict = nil;
        }
        
        NSLog(@"======shareJson===========%@",item);
    }];
    
    
    // 防止内存泄漏
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    // 响应touch事件，以及获得点击的坐标位置，用于保存图片
    //    [theWebView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
    
    //    [super webViewDidFinishLoad:theWebView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if(message.name ==nil || [message.name isEqualToString:@""])
        return;
    //message body : js 传过来值
    NSLog(@"message.body ==%@",message.body);
    
}

/// 是否允许加载网页 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    //    NSLog(@"urlString=%@",urlString);
    if ([urlString hasPrefix:@"master://nmcourse_index"]) {
        MainTabBarController * tabBar = (MainTabBarController *)self.tabBarController;
        
        tabBar.selectedIndex = 3;
        
        UIButton * btn =   tabBar.tabBarBtn[0];
        
        btn.selected = NO;
        
        
        btn = tabBar.tabBarBtn[3];
        
        btn.selected = YES;
        
        
        [self.navigationController popViewControllerAnimated:NO];
        
    }else if ([urlString hasPrefix:@"master:"]) {
        [self pushViewControllerWithUrl:urlString];
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.mWkWebView.estimatedProgress;
        if (self.mWkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.5f animations:^{
                self.progressView.alpha = 0.0f;
                self.progressView.progress = 0.0f;
            }];
        }else{
            self.progressView.alpha = 1.0f;
        }
    }
}

//
//// 功能：如果点击的是图片，并且按住的时间超过1s，执行handleLongTouch函数，处理图片的保存操作。
//- (void)handleLongTouch {
//    NSLog(@"%@", _imgURL);
//    if (_imgURL && _gesState == GESTURE_STATE_START) {
//        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
//        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
//        [sheet showInView:[UIApplication sharedApplication].keyWindow];
//    }
//}
//// 功能：保存图片到手机
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
//        return;
//    }
//    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
//    if ([title isEqualToString:@"保存到手机"]) {
//        if (_imgURL) {
//            NSLog(@"imgurl = %@", _imgURL);
//        }
//        //        NSString *urlToSave = [self.mWkWebView stringByEvaluatingJavaScriptFromString:_imgURL];
//        [self.mWkWebView evaluateJavaScript:_imgURL completionHandler:^(id _Nullable item, NSError * _Nullable error) {
//            
//            NSLog(@"image url = %@", item);
//            
//            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item]];
//            UIImage* image = [UIImage imageWithData:data];
//            
//            //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
//            //        NSLog(@"UIImageWriteToSavedPhotosAlbum = %@", urlToSave);
//            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }];
//        
//    }
//}
//// 功能：显示对话框
//-(void)showAlert:(NSString *)msg {
//    NSLog(@"showAlert = %@", msg);
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"提示"
//                          message:msg
//                          delegate:self
//                          cancelButtonTitle:@"确定"
//                          otherButtonTitles: nil];
//    [alert show];
//}
//// 功能：显示图片保存结果
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
//{
//    if (error){
//        NSLog(@"Error");
//        [self showAlert:@"保存失败..."];
//    }else {
//        NSLog(@"OK");
//        [self showAlert:@"保存成功！"];
//    }
//}
//// 网页加载完成时触发
//#pragma mark UIWeb0Delegate implementation
//- (void)webViewDidFinishLoad:(UIWebView*)theWebView
//{
//    // Black base color for background matches the native apps
////    theWebView.backgroundColor = [UIColor blackColor];
//
//    [self.activityIndicatorView stopAnimating];
//
//    NSString *title = [theWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    if(![title isEmpty]){
//        self.title=title;
//    }
//
//    NSString *shareJson = [theWebView stringByEvaluatingJavaScriptFromString:@"app_share();"];
//    if (shareJson && [shareJson isKindOfClass:[NSString class]] && shareJson.length>0) {
//        self.shareDict = [NSJSONSerialization JSONObjectWithData:[shareJson dataUsingEncoding:NSUTF8StringEncoding]
//                                                         options:NSJSONReadingMutableContainers
//                                                           error:nil];
//    }else{
//        self.shareDict = nil;
//    }
//    NSLog(@"======shareJson===========%@",shareJson);
//    // 当iOS版本大于7时，向下移动20dp
////    if (!IOS7) { }
//
//    // 防止内存泄漏
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//
//    // 响应touch事件，以及获得点击的坐标位置，用于保存图片
////    [theWebView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
//
////    [super webViewDidFinishLoad:theWebView];
//}

#pragma mark -- UIWebViewDelegate

//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [self.activityIndicatorView startAnimating];
//     NSLog(@"webViewDidStartLoad");
//}


//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    [self.activityIndicatorView stopAnimating];
//}


//
//// 功能：UIWebView响应长按事件
//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType {
//    
//    
//    NSString *urlString = _request.URL.absoluteString;
//    if ([urlString hasPrefix:@"master://nmcourse_index"]) {
//        MainTabBarController * tabBar = (MainTabBarController *)self.tabBarController;
//        
//        tabBar.selectedIndex = 3;
//        
//        UIButton * btn =   tabBar.tabBarBtn[0];
//        
//        btn.selected = NO;
//        
//        
//        btn = tabBar.tabBarBtn[3];
//        
//        btn.selected = YES;
//        
//        
//        [self.navigationController popViewControllerAnimated:NO];
//        
//        return YES;
//    }
//    if ([urlString hasPrefix:@"master:"]) {
//        [self pushViewControllerWithUrl:urlString];
//        return NO;
//    }
//    //    NSString *requestString = [[_request URL] absoluteString];
//    //    NSArray *components = [requestString componentsSeparatedByString:@":"];
//    //    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
//    //                                   isEqualToString:@"myweb"]) {
//    //        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
//    //        {
//    //            //NSLog(@"you are touching!");
//    //            //NSTimeInterval delaytime = Delaytime;
//    //            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
//    //            {
//    //                /*
//    //                 @需延时判断是否响应页面内的js...
//    //                 */
//    //                _gesState = GESTURE_STATE_START;
//    //                NSLog(@"touch start!");
//    //
//    //                float ptX = [[components objectAtIndex:3]floatValue];
//    //                float ptY = [[components objectAtIndex:4]floatValue];
//    //                NSLog(@"touch point (%f, %f)", ptX, ptY);
//    //
//    //                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
//    //                NSString * tagName = [self.mWebView stringByEvaluatingJavaScriptFromString:js];
//    //                _imgURL = nil;
//    //                if ([tagName isEqualToString:@"IMG"]) {
//    //                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
//    //                }
//    //                if (_imgURL) {
//    //                    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
//    //                }
//    //            }
//    //            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
//    //            {
//    //                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
//    //                _gesState = GESTURE_STATE_MOVE;
//    //                NSLog(@"you are move");
//    //            }
//    //        }
//    //        else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
//    //            [_timer invalidate];
//    //            _timer = nil;
//    //            _gesState = GESTURE_STATE_END;
//    //            NSLog(@"touch end");
//    //        }
//    //        return NO;
//    //    }
//    return YES;
//    //    return [super webView:webView shouldStartLoadWithRequest:_request navigationType:navigationType];
//}



@end
