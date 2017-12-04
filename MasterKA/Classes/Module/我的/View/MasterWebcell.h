//
//  MasterWebcell.h
//  MasterKA
//
//  Created by hyu on 16/6/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface MasterWebcell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *masterWeb;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *webViewHeightLayout;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *webIndicatorView;
@property (strong, nonatomic)UIWebView *webView;
@property (nonatomic,strong)NSString *webUrlString;
@end
