//
//  CourseItemView.m
//  MasterKA
//
//  Created by jinghao on 16/5/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CourseItemView.h"

@interface CourseItemView ()
@property (nonatomic,weak)IBOutlet UILabel *courseTitleLabel;
@property (nonatomic,weak)IBOutlet UILabel *priceSaleLabel;
@property (nonatomic,weak)IBOutlet UILabel *priceStandardLabel;
@property (nonatomic,weak)IBOutlet UILabel *courseAddressLabel;
@property (nonatomic,weak)IBOutlet UILabel *courseDistancesLabel;

@property (nonatomic,weak)IBOutlet UIImageView *courseImageView;
@property (nonatomic,weak)IBOutlet UIView *tagContentView;


@end

@implementation CourseItemView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
//        UIView *containerView = [[[UINib nibWithNibName:@"CourseItemView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        containerView.frame = newFrame;
//        [self addSubview:containerView];
    }
    return self;
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [[NSBundle mainBundle] loadNibNamed:@"CourseItemView" owner:self options:nil];
    [self addSubview:self.view];
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.courseImageView.cornerRadius = 6.0f;
}


- (void)awakeFromNib {
    [super awakeFromNib];
//    @weakify(self)
//    [RACObserve(self, model) subscribeNext:^(CourseModel *model) {
//        @strongify(self)
//        self.courseTitleLabel.text = model.title;
//        self.courseDistancesLabel.text = model.distance;
//        self.courseAddressLabel.text = model.store;
//        [self.courseImageView setImageWithURLString:model.cover];
//        self.priceSaleLabel.text = [model getPriceString];
        
//        if ( model.m_price) {
//            NSDictionary *attribs = @{NSStrikethroughStyleAttributeName:@(1)};
//            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[model getMakertPriceString] attributes:attribs];
//            [self.priceStandardLabel setAttributedText:attr];
//        }else{
//            self.priceStandardLabel.text = nil;
//        }
//        NSArray *tag = model.tags;
//        for (UIView *view in [self.tagContentView subviews]) {
//            [view removeFromSuperview];
//        }
//        if (tag && tag.count>0) {
//            UIView *lastView = nil;
//            for (int i=0; i<tag.count; i++) {
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                [button setTitle:tag[i] forState:UIControlStateNormal];
//                [button setCornerRadius:4.0f];
//                button.borderWidth = 0.5;
//                button.borderColor = MasterDefaultColor;
//                button.titleLabel.font = [UIFont systemFontOfSize:11.0f];
//                button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
//                [button setTitleColor:[UIColor colorWithHex:0x979797] forState:UIControlStateNormal];
//                [self.tagContentView addSubview:button];
//                if (lastView) {
//                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(lastView.mas_right).with.offset(5.0f);
//                        make.top.and.bottom.equalTo(self.tagContentView);
//                    }];
//                }else{
//                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(self.tagContentView);
//                        make.top.and.bottom.equalTo(self.tagContentView);
//                    }];
//                }
//                lastView = button;
//            }
//        }
//    }];
}

@end
