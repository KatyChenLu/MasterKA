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



@end
