//
//  LoopScrollView.m
//  MasterKA
//
//  Created by jinghao on 15/12/8.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "LoopScrollView.h"
#import "SDCycleScrollView.h"
#import "Masonry.h"

@interface LoopScrollView () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation LoopScrollView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonInit];
        
    }
    
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles urls:(NSArray *)urls{
    
    return [self initWithFrame:CGRectZero titles:titles urls:urls];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles urls:(NSArray *)urls{
    
    _titles = titles;
    
    _urls = urls;
    
    return [self initWithFrame:frame];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self commonInit];
        
    }
    
    return self;
    
}

- (void)commonInit {
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.frame delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    
    _cycleScrollView.titlesGroup = self.titles;
    
    _cycleScrollView.currentPageDotColor = MasterDefaultColor;
    
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    
    _cycleScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _cycleScrollView.autoScroll = self.isAutoScroll;
    
    [self addSubview:_cycleScrollView];
    
    _cycleScrollView.imageURLStringsGroup = self.urls;
}

- (void)setUrls:(NSArray *)urls{
    
    _urls = urls;
    
    _cycleScrollView.imageURLStringsGroup = urls;
    
    _cycleScrollView.canBorwser = self.canBorwser;
    
    if(urls.count  <= 1){
        
        _cycleScrollView.infiniteLoop = NO;
        
    }
    
}

- (void)setTitles:(NSArray *)titles{
    
    _titles = titles;
    
    _cycleScrollView.titlesGroup = self.titles;
    
}
-(void)setIsAutoScroll:(BOOL)isAutoScroll {
    
    _isAutoScroll = isAutoScroll;
    
   _cycleScrollView.autoScroll = isAutoScroll;
    
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _cycleScrollView.frame = self.bounds;
}

#pragma mark -

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleView:didSelectedIndex:)]) {
        
        [self.delegate circleView:self didSelectedIndex:index];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleView:didScrollToIndex:)]) {
        
        [self.delegate circleView:self didScrollToIndex:index];
    }
}

#pragma mark - Getter and Setter

- (void)setShowPageControl:(BOOL)showPageControl {
    
    _showPageControl = showPageControl;
    
    if (_cycleScrollView) {
        
        _cycleScrollView.showPageControl = showPageControl;
    }
}


- (void)setShowTitleControl:(BOOL)showTitleControl {
    
    showTitleControl = showTitleControl;
    
    if (_cycleScrollView) {
        _cycleScrollView.titleLabelHeight = 0;
        
    }
}

@end
