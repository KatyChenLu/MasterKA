//
//  TYScrollPageTabBar.m
//  MasterKA
//
//  Created by jinghao on 16/4/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TYScrollPageTabBar.h"
@interface TYScrollPageTabBar ()
@property (nonatomic,strong,readwrite)HMSegmentedControl *segmentedControl;
@end

@implementation TYScrollPageTabBar
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.segmentedControl];
    }
    return self;
}

- (HMSegmentedControl*)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:self.bounds];
        __weak typeof(self) mySelf = self;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [mySelf clickedPageTabBarAtIndex:index];
        }];
    }
    return _segmentedControl;
}

// override, auto call ,when TYSlidePageScrollView index change, you can change your pageTabBar index on this method
- (void)switchToPageIndex:(NSInteger)index{
    if (index >= 0 && index < self.segmentedControl.sectionTitles.count) {
        [self.segmentedControl setSelectedSegmentIndex:index animated:YES];
    }
}
@end
