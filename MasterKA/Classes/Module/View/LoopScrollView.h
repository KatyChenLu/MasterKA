//
//  LoopScrollView.h
//  MasterKA
//
//  Created by jinghao on 15/12/8.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoopScrollView;

@protocol LoopScrollViewDelegate <NSObject>


- (void)circleView:(LoopScrollView *)view didSelectedIndex:(NSInteger)index;

- (void)circleView:(LoopScrollView *)view didScrollToIndex:(NSInteger)index;


@end

@interface LoopScrollView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *urls;

@property (nonatomic, assign) BOOL isAutoScroll;

@property (nonatomic,assign)BOOL canBorwser;

@property (nonatomic, weak) id<LoopScrollViewDelegate> delegate;

@property (nonatomic, assign) BOOL showPageControl;

@property (nonatomic, assign) BOOL showTitleControl;

-(instancetype)initWithTitles:(NSArray *)titles urls:(NSArray *)urls;

@end



