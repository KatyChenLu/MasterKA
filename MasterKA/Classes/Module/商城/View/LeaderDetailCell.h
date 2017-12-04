//
//  LeaderDetailCell.h
//  MasterKA
//
//  Created by hyu on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface LeaderDetailCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_top;
@property (weak, nonatomic) IBOutlet UILabel *nikename;
@property (nonatomic,strong)NSString *webUrlString;
@property (nonatomic,strong)IBOutlet UIView *webSuperView;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *webViewHeightLayout;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *webIndicatorView;
@property (strong, nonatomic)UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property(nonatomic ,copy)void(^moreClick)();
@property (weak, nonatomic) IBOutlet UIImageView *Shadow;
@property (weak, nonatomic) IBOutlet UIImageView *xiaJiantou;


@end
