//
//  BaseTableViewCell.m
//  MasterKA
//
//  Created by jinghao on 15/12/24.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "BaseTableViewCell.h"
@interface BaseTableViewCell ()
@property (nonatomic,strong,readwrite)UIView *lineView;
@property (nonatomic,strong,readwrite)UIView *topLineView;
@end

@implementation BaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (UIView*)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.with.offset(0.5f);
            make.bottom.equalTo(self.mas_bottom);
            make.left.right.equalTo(self);
        }];
    }
    return _lineView;
}

- (UIView*)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_topLineView];
        [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.with.offset(0.5f);
            make.top.equalTo(self.mas_top);
            make.left.right.equalTo(self);
        }];
    }
    return _topLineView;
}

- (void)setShowCustomLineView:(BOOL)showCustomLineView
{
    _showCustomLineView = showCustomLineView;
    if (showCustomLineView) {
        self.lineView.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.lineView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setShowTopLineView:(BOOL)showTopLineView
{
    _showTopLineView = showTopLineView;
    if (showTopLineView) {
        self.topLineView.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.topLineView.backgroundColor = [UIColor clearColor];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView)
    {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)bindViewModel:(id)viewModel{
    
}
@end
