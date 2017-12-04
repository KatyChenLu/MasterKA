//
//  LeaderDetailCell.m
//  MasterKA
//
//  Created by hyu on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LeaderDetailCell.h"
@interface LeaderDetailCell()<UIWebViewDelegate>
//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LeaderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    UIImage *img = [UIImage imageNamed:@"jiantouxia"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _xiaJiantou.image = img;
    _xiaJiantou.tintColor = [UIColor colorWithHex:0xECA946];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWebView:(UIWebView *)webView
{
    _webView = webView;
    if (_webView) {
        [webView removeFromSuperview];
        [self.webSuperView addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.webSuperView);
        }];
    }
}

- (void)setWebUrlString:(NSString *)webUrlString
{
    
//    if (![_webUrlString isEqualToString:webUrlString]) {
        _webUrlString = webUrlString;
        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webUrlString]];
        [requestObj addMasterHeadInfo];
        [self.webView loadRequest:requestObj];
//    }else{
//        UITableView *tableView = [self tableView];
//        [tableView beginUpdates];
//        [tableView endUpdates];
//    }
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    [self.webIndicatorView stopAnimating];
    float htmlHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    htmlHeight = htmlHeight +20;
    self.webViewHeightLayout.constant = htmlHeight;
//     让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.webIndicatorView startAnimating];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.webIndicatorView stopAnimating];
}
- (IBAction)more:(id)sender {
    
    self.moreClick();
    
    
}

@end
