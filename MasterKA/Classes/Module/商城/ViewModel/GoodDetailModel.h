//
//  GoodDetailModel.h
//  MasterKA
//
//  Created by hyu on 16/5/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"

@interface GoodDetailModel : TableViewModel
@property (strong , nonatomic) NSString *course_id;
@property(nonatomic, strong) NSDictionary *info;
@property(nonatomic, strong) NSMutableArray *detailSection;
@property (nonatomic,strong,readonly)RACCommand *courseCommand;
@property (nonatomic,strong,readonly)RACCommand *gotoDetail;
@property (nonatomic,strong)RACCommand *engagements;
@property (nonatomic,strong)RACCommand *question;
@property (nonatomic,strong)RACCommand *shoucang;
@property (nonatomic,strong)RACCommand *share;
//@property (nonatomic,strong) NSString *discount;
@property (nonatomic, assign) BOOL  fresh;
@property (nonatomic, strong) UIWebView *subWebView;
@property (nonatomic,assign)float alphaNavigationBar;

@property(nonatomic , copy)void(^group_buy)(NSDictionary * dic);


@end
