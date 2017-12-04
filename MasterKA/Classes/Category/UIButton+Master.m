////
////  UIButton+Master.m
////  HiGoMaster
////
////  Created by jinghao on 15/2/6.
////  Copyright (c) 2015年 jinghao. All rights reserved.
////
//
#import "UIButton+Master.h"
#import "UIButton+WebCache.h"
#import "UIView+Master.h"
#import <objc/runtime.h>

@implementation UIButton (Master)
- (void)buttonTextCenter{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, self.frame.size.width, 0.0, 0.0)];
}
- (void)setImageUrlForState:(UIControlState)state
                    withUrl:(NSString *)url
           placeholderImage:(UIImage *)placeholderImage{
    url = [url masterFullImageUrl];
    [self sd_setImageWithURL:[NSURL URLWithString:url] forState:state placeholderImage:placeholderImage];
//    [self setImageForState:state withURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
}
- (void)setBackgroundImageUrlForState:(UIControlState)state
                    withUrl:(NSString *)url
           placeholderImage:(UIImage *)placeholderImage{
    url = [url masterFullImageUrl];
    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:state placeholderImage:placeholderImage];
//    [self setBackgroundImageForState:state withURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
}

- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
    float width = imageSize.width>titleSize.width?imageSize.width:titleSize.width;
    self.contentEdgeInsets = UIEdgeInsetsMake(-(self.height-totalHeight)/2,-(self.width-width)/2, -(self.height-totalHeight)/2,-(self.width-width)/2);
    //    self.width = imageSize.width;
    //    self.height = totalHeight;
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

- (void)rightImage
{
    const int DEFAULT_SPACING = 6.0f;
    [self rightImage:DEFAULT_SPACING];
}
- (void)rightImage:(float)spacing
{
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes: @{NSFontAttributeName:self.titleLabel.font }]; //[self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGSize imgSize = self.imageView.bounds.size;
    imgSize.width+=spacing;
    UIEdgeInsets imgInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleInsets = UIEdgeInsetsZero;
    
    imgInsets.left = titleSize.width;
//    imgInsets.right =  titleBounds.size.width;
    
//    titleInsets.right = self.frame.size.height / 2 - 4;
    titleInsets.left =-(imgSize.width*2);
    CGRect frame = self.frame;
    [self setImageEdgeInsets:imgInsets];
    [self setTitleEdgeInsets:titleInsets];
    [self sizeToFit];
    self.left += (frame.size.width-self.width)/2;
    self.top += (frame.size.height-self.height)/2;
}


-(void)setCityStr:(NSString *)cityStr
{
    
    
    objc_setAssociatedObject(self, @"cityNameCity", cityStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



-(NSString*)cityStr{
    
    
    
    return objc_getAssociatedObject(self, @"cityNameCity");
}




@end
