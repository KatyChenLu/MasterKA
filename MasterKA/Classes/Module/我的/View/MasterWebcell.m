//
//  MasterWebcell.m
//  MasterKA
//
//  Created by hyu on 16/6/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterWebcell.h"
@interface MasterWebcell()<UIWebViewDelegate>
@end
@implementation MasterWebcell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setWebView:(UIWebView *)webView
{
    if (_webView != webView ) {
        _webView = webView;
        [webView removeFromSuperview];
        [self.contentView addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}
@end
