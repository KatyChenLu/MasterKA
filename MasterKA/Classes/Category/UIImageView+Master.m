//
//  UIImageView+Master.m
//  MasterKA
//
//  Created by jinghao on 15/12/23.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "UIImageView+Master.h"

@implementation UIImageView (Master)
- (void)setImageWithURLString:(NSString *)url{
    [self setImageWithURLString:url placeholderImage:nil];
}

- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder{
    if (placeholder==nil) {
        placeholder = [UIImage imageNamed:@"LoadingDefault"];
    }
    url = [url masterFullImageUrl];
    
    //缓存时间

    
//     [SDImageCache sharedImageCache].config.maxCacheAge = 30*24*60*60;
    
    [[SDImageCache sharedImageCache] setMaxMemoryCountLimit:400];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
//    self.browserImages = @[url];
//    self.canBrowser = YES;
    
}

- (void)setImageFadeInWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder  {
    if (placeholder==nil) {
//        placeholder = [self placeholderImageWithSize:self.size];
        placeholder = [UIImage imageNamed:@"LoadingDefault"];
        
    }
    url = [url masterFullImageUrl];
//    self.contentMode =UIViewContentModeScaleAspectFit;
    [self sd_setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:placeholder
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                      placeholder =  [UIImage placeholderImageWithSize:image.size];
                       if (image && cacheType == SDImageCacheTypeNone) {
                           CATransition *transition = [CATransition animation];
                           transition.type = kCATransitionFade;
                           transition.duration = 0.2;
                           transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                           [self.layer addAnimation:transition forKey:nil];
                       }
                   }];
    
    
}

- (void)layersMakesToBoundsWithRadius:(CGFloat)radius {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, self.width, self.height);
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = CGRectMake(0, 0, self.width, self.height);
    borderLayer.lineWidth = 1.f;
    borderLayer.strokeColor = [UIColor clearColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.width, self.height) cornerRadius:radius];
    maskLayer.path = bezierPath.CGPath;
    borderLayer.path = bezierPath.CGPath;
    
    [self.layer insertSublayer:borderLayer atIndex:0];
    [self.layer setMask:maskLayer];
    
}

- (UIColor *)colorAtPixel:(CGPoint)point inImage:(UIImage *)image {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
/**
 传入需要的占位图尺寸 获取占位图
 
 @param size 需要的站位图尺寸
 @return 占位图
 */
- (UIImage *)placeholderImageWithSize:(CGSize)size {
    // 中间LOGO图片
    UIImage *image = [UIImage imageNamed:@"LoadingDefault"];
    // 占位图的背景色
    UIColor *backgroundColor = [self colorAtPixel:CGPointMake(1, 1) inImage:image];

    // 根据占位图需要的尺寸 计算 中间LOGO的宽高
    CGFloat logoWH = (size.width > size.height ? size.height : size.width) * 0.5;
    CGSize logoSize = CGSizeMake(logoWH, logoWH);
    // 打开上下文
    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
    // 绘图
    [backgroundColor set];
    UIRectFill(CGRectMake(0,0, size.width, size.height));
    CGFloat imageX = (size.width / 2) - (logoSize.width / 2);
    CGFloat imageY = (size.height / 2) - (logoSize.height / 2);
    [image drawInRect:CGRectMake(imageX, imageY, logoSize.width, logoSize.height)];
    UIImage *resImage =UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return resImage;
    
}

@end
