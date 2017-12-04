//
//  MydetailModel.h
//  MasterKA
//
//  Created by hyu on 16/5/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"

@interface MasterOrUserHomepageModel : TableViewModel<UIWebViewDelegate>
@property (strong , nonatomic) NSString *uid;
@property(nonatomic, strong) NSDictionary *info;
@property(nonatomic, strong) NSMutableArray *detailSection;
@property(nonatomic, assign) NSInteger segmented_index;
@property (nonatomic,assign)CGFloat alphaNavigationBar;
@property (nonatomic, assign) BOOL  fresh;
@property (nonatomic,strong)RACCommand *question;
@property (nonatomic,strong)RACCommand *attention;
@property (nonatomic,strong)RACCommand *share;
@property (nonatomic,strong)RACCommand *dianZan;
@property (nonatomic, strong) UIWebView *subWebView;
@end
