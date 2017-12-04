//
//  UIImageView+Master.h
//  MasterKA
//
//  Created by jinghao on 15/12/23.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (Master)
- (void)setImageWithURLString:(NSString *)url;

- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageFadeInWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder;

- (void)layersMakesToBoundsWithRadius:(CGFloat)radius;
@end
