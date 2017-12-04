//
//  QRCodeViewController.m
//  HiGoMaster
//
//  Created by jinghao on 15/7/10.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds

//static const float kLineMinY = 185-64*2;
//static const float kLineMaxY = 385-64*2;
//static const float kReaderViewWidth = 200;
//static const float kReaderViewHeight = 200;

@interface QRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *qrSession;//回话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrVideoPreviewLayer;//读取
@property (nonatomic, strong) UIImageView *line;//交互线
@property (nonatomic, strong) NSTimer *lineTimer;//交互线控制
@property (nonatomic, assign) NSInteger kLineMinY;
@property (nonatomic, assign) NSInteger kLineMaxY;
@property (nonatomic, assign) NSInteger kReaderViewWidth;
@property (nonatomic, assign) NSInteger kReaderViewHeight;

@end

@implementation QRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title=@"扫码验单";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    
    CGRect frame = [self getReaderViewBoundsWithSize];
    self.kLineMinY = frame.origin.y;
    self.kLineMaxY = frame.origin.y +frame.size.height;
    self.kReaderViewWidth = frame.size.width;
    self.kReaderViewHeight = frame.size.height;

    [self initUI];
    [self setOverlayPickerView];
    [self startSYQRCodeReading];
    [self initTitleView];
    [self createBackBtn];
}

- (void)dealloc
{
    NSLog(@"dealloc  ===============================%@",self);

    if (_qrSession) {
        [_qrSession stopRunning];
        _qrSession = nil;
    }
    
    if (_qrVideoPreviewLayer) {
        _qrVideoPreviewLayer = nil;
    }
    
    if (_line) {
        _line = nil;
    }
    
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
}

- (void)initTitleView
{
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,20,kDeviceWidth, 44)];
//    bgView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:bgView];
//    
//    UILabel *titleLab = [[UILabel alloc] init];
//    titleLab.text = @"扫一扫";
//    titleLab.font = [UIFont boldSystemFontOfSize:18.0];
//    titleLab.textColor = [UIColor whiteColor];
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    [bgView addSubview:titleLab];
//    [titleLab sizeToFit];
//    titleLab.center = CGPointMake(bgView.width/2 , bgView.height/2);
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(20, 10, 60, 24)];
//    [btn setImage:[UIImage imageNamed:@"QRCode_Nav_Back"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(cancleSYQRCodeReading) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:btn];
}

- (void)createBackBtn
{
    
}

- (void)initUI
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //摄像头判断
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        
        return;
    }
    
    //设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出的代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
//    CGRect interest = [self getReaderViewBoundsWithSize:CGSizeMake(_kReaderViewWidth, _kReaderViewHeight)];
    
     CGRect  interest = [self getReaderViewBoundsWithSizeForOutput];
    [output setRectOfInterest:interest];

//    [output setRectOfInterest:[self getReaderViewBoundsWithSize]];
    
    //拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 读取质量，质量越高，可读取小尺寸的二维码
    if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
    {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else
    {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    if ([session canAddInput:input])
    {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output])
    {
        [session addOutput:output];
    }
    
    //设置输出的格式
    //一定要先设置会话的输出为output之后，再指定输出的元数据类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    
    //设置预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    //设置preview图层的属性
    //preview.borderColor = [UIColor redColor].CGColor;
    //preview.borderWidth = 1.5;
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置preview图层的大小
    preview.frame = self.view.layer.bounds;
    //[preview setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    
    //将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    //[self.view.layer addSublayer:preview];
    self.qrVideoPreviewLayer = preview;
    self.qrSession = session;
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(_kLineMinY / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
}

- (CGRect)getReaderViewBoundsWithSizeForOutput
{
    CGRect frame = [self getReaderViewBoundsWithSize];
    return CGRectMake(frame.origin.y / KDeviceHeight, frame.origin.x / kDeviceWidth, frame.size.height / KDeviceHeight, frame.size.width / kDeviceWidth);
}

- (CGRect)getReaderViewBoundsWithSize
{
    float w = kDeviceWidth*2/3;
    float x = kDeviceWidth*1/6;
    float y = (KDeviceHeight-272-w)/2+64;
    return CGRectMake(x,y,w,w);
}

- (void)setOverlayPickerView
{
    
    float borderWidth = 0.0f;

    CGRect frame = [self getReaderViewBoundsWithSize];
    float lineMinY =frame.origin.y;
    
    UIView *scanCropView = [[UIView alloc] initWithFrame:frame];
    scanCropView.layer.borderColor = [UIColor whiteColor].CGColor;
    scanCropView.layer.borderWidth = 1.0f;
    [self.view addSubview:scanCropView];

    
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 12 * frame.size.width / 320.0)];
    [_line setImage:[UIImage imageNamed:@"QRCodeLine"]];
    [self.view addSubview:_line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, lineMinY)];//80
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, lineMinY, frame.origin.x, frame.size.height)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x+frame.size.width, lineMinY,kDeviceWidth - frame.origin.x-frame.size.width, frame.size.height)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.origin.y+frame.size.height, kDeviceWidth, KDeviceHeight-(frame.origin.y+frame.size.height))];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"QRCodeTopLeft"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x-borderWidth, frame.origin.y-borderWidth, cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodeTopRight"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x+frame.size.width-cornerImage.size.width+borderWidth, frame.origin.y-borderWidth, cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodebottomLeft"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x-borderWidth, frame.origin.y+frame.size.height-cornerImage.size.height+borderWidth, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodebottomRight"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x+frame.size.width-cornerImage.size.width+borderWidth, frame.origin.y+frame.size.height-cornerImage.size.height+borderWidth, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.numberOfLines=0;
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将取景框对准二维码\n即可自动扫描";
    [self.view addSubview:labIntroudction];
    [labIntroudction sizeToFit];
    labIntroudction.center = CGPointMake(kDeviceWidth/2, labIntroudction.height/2+scanCropView.top+scanCropView.height+10);
    
    
//    UIView *scanCropView = [[UIView alloc] initWithFrame:frame];
//    scanCropView.layer.borderColor = [UIColor whiteColor].CGColor;
//    scanCropView.layer.borderWidth = borderWidth;
//    [self.view addSubview:scanCropView];
//    [scanCropView sendSubviewToBack:self.view];
}


#pragma mark -
#pragma mark 输出代理方法

//此方法是在识别到QRCode，并且完成转换
//如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    if (metadataObjects.count > 0)
    {
        [self stopSYQRCodeReading];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        if (obj.stringValue && ![obj.stringValue isEqualToString:@""] && obj.stringValue.length > 0)
        {
            NSLog(@"---------%@",obj.stringValue);
            
            if (self.QRCodeSuncessBlock) {
                self.QRCodeSuncessBlock(self,obj.stringValue);
            }
        }
        else
        {
            if (self.QRCodeFailBlock) {
                self.QRCodeFailBlock(self);
            }
        }
    }
    else
    {
        if (self.QRCodeFailBlock) {
            self.QRCodeFailBlock(self);
        }
    }
}


#pragma mark -
#pragma mark 交互事件

- (void)startSYQRCodeReading
{
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    
    [self.qrSession startRunning];
    
    NSLog(@"start reading");
}

- (void)stopSYQRCodeReading
{
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    
    [self.qrSession stopRunning];
    
    NSLog(@"stop reading");
}

//取消扫描
- (void)cancleSYQRCodeReading
{
    [self stopSYQRCodeReading];
    
    if (self.QRCodeCancleBlock)
    {
        self.QRCodeCancleBlock(self);
    }
    NSLog(@"cancle reading");
}


#pragma mark -
#pragma mark 上下滚动交互线


- (void)animationLine
{
    __block CGRect frame = _line.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        frame.origin.y = (KDeviceHeight-272-kDeviceWidth*2/3)/2+64;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            _line.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (_line.frame.origin.y >= _kLineMinY)
        {
            if (_line.frame.origin.y >= _kLineMaxY - 12)
            {
                frame.origin.y = _kLineMinY;
                _line.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    _line.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
}


//- (void)animationLine
//{
//    __block CGRect frame = _line.frame;
//    CGRect resetRect =[self getReaderViewBoundsWithSize];
//    static BOOL flag = YES;
//    
//    if (flag)
//    {
////        frame.origin.y = kLineMinY;
//        flag = NO;
//        
//        [UIView animateWithDuration:1.0 / 5 animations:^{
//            
//            frame.origin.y += 5;
//            _line.frame = frame;
//            
//        } completion:nil];
//    }
//    else
//    {
//        if (_line.frame.origin.y >= resetRect.origin.y)
//        {
//            if (_line.frame.origin.y >= resetRect.origin.y+resetRect.size.height)
//            {
//                frame.origin.y = resetRect.origin.y;
//                _line.frame = frame;
//                
//                flag = YES;
//            }
//            else
//            {
//                [UIView animateWithDuration:1.0 / 5 animations:^{
//                    
//                    frame.origin.y += 5;
//                    _line.frame = frame;
//                    
//                } completion:nil];
//            }
//        }
//        else
//        {
//            flag = !flag;
//        }
//    }
//    
//    //NSLog(@"_line.frame.origin.y==%f",_line.frame.origin.y);
//}
- (void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
