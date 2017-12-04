//
//  MineRootViewModel.m
//  MasterKA
//
//  Created by jinghao on 16/2/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MineRootViewModel.h"
#import "MineTableViewCell.h"
#import "MasterWebViewController.h"

#import "MyOrderHomeViewController.h"

@interface MineRootViewModel ()
@property (nonatomic,strong)NSArray *topGroupMenu;




@end

@implementation MineRootViewModel
- (void)initialize {
    [super initialize];
    self.mTableView.backgroundColor = [UIColor whiteColor];
//    self.title = @"我的";
     NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(RefurbishMyInfo:) name:@"RefurbishMyInfo" object:nil];
//    [self initMenu];
    @weakify(self)
    [[[RACObserve(self, dataSource)
       filter:^(NSArray *events) {
           return @(events.count > 0).boolValue;
       }]
      deliverOnMainThread]
     subscribeNext:^(NSArray *events) {
         @strongify(self)
//         [self.mTableView beginUpdates];
         [self.mTableView reloadData];
//         [self.mTableView endUpdates];
     }];
}
-(void)RefurbishMyInfo:(NSNotification *)notify{
    @weakify(self)
    
//    NSString * str = notify.object;
    
    [[self.httpService queryUserCenterWith:nil] subscribeNext:^(BaseModel *model){
        @strongify(self)
        if (model.code==200) {
            self.userInfo = model.data;
                [self loadLocalData];

        }else {

            self.userInfo = nil;
            
            [self loadLocalData];
            
            if (![UserClient sharedUserClient].rawLogin) {
                
                [self.viewController hiddenHUDWithString:@"请登录" error:NO];
            }else{
                
                [self.viewController hiddenHUDWithString:@"获取信息失败" error:NO];
            }
            
        }
    }];

}
- (void)loadLocalData{
    NSMutableArray *results=[[NSMutableArray alloc] initWithArray:[self initmenu:[[[UserClient sharedUserClient].userInfo objectForKey:@"identity"] intValue]]];
//    results=[self initmenu:[[[UserClient sharedUserClient].userInfo objectForKey:@"identity"] intValue]];
    NSMutableArray *data = [NSMutableArray new];

    NSMutableArray *tempGroup =[NSMutableArray new];
    for (MineMenuModel *model in results) {
        [tempGroup addObject:model];
    }
    [data addObject:tempGroup];
    
    

        self.dataSource = data;
        [self.mTableView reloadData];
   
}

- (void)bindTableView:(UITableView *)tableView
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"MineTableViewCell";
    [tableView registerCellWithReuseIdentifier:self.cellReuseIdentifier];
    
}

- (void)configureCell:(MineTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(MineMenuModel*)object
{
    [cell bindViewModel:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 6;}
    else{
        return 6;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section ==0){
    
    switch (indexPath.row) {
        case 0:
            if( [self.viewController doLogin]){
//                [self pushto:@"MineOrderHomeVC"];
//                UITabBarController * tabBar = (UITabBarController*)[[SlideNavigationController sharedInstance].viewControllers firstObject];
//                UINavigationController *nav = (UINavigationController*)[tabBar selectedViewController];
                
                MyOrderHomeViewController *myView = [[MyOrderHomeViewController alloc] init];
                myView.comeIdentifier = @"user";
                [self.viewController pushViewController:myView animated:YES];
            }
            break;
        case 1:
       if( [self.viewController doLogin]){
           [self pushto:@"MyShareViewController"];}
            break;
        case 2:
              if( [self.viewController doLogin]){
                  [self pushto:@"MyCollectionController"];}
            break;
        case 3:
              if( [self.viewController doLogin]){
            if([[self.userInfo objectForKey:@"identity"] intValue]==2){
                [self pushto:@"MybagViewController"];
            }else{
                [self pushto:@"ExchangeViewController"];
            }
              }
            break;
            
        default:
              if( [self.viewController doLogin]){
            if([[self.userInfo objectForKey:@"identity"] intValue]==2){
                [self pushto:@"ExchangeViewController"];
            }else{
            NSString *path = [UserClient sharedUserClient].master_enter_url;
               MasterWebViewController * viewController =[[MasterWebViewController alloc] initWithURL:[NSURL URLWithString:path]
                                                                                            query:nil];
                if (viewController) {
//                    UITabBarController * tabBar = (UITabBarController*)[[SlideNavigationController sharedInstance].viewControllers firstObject];
//                    UINavigationController *nav = (UINavigationController*)[tabBar selectedViewController];
                    [self.viewController pushViewController:viewController animated:NO];
//                    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
//                    }];

                }
            }
//                [self.viewController pushViewControllerWithUrl:path];
            }
            break;
    }
    }
    else{
        
        
        if(indexPath.row==0){
            if([self.viewController doLogin]){
            NSString *path = [UserClient sharedUserClient].enterprise_course_url ;
            [self.viewController pushViewControllerWithUrl:path ];
        
            }
        }
        if(indexPath.row==1){
        ////
        if([self.viewController doLogin]){
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
                UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"SettingViewController"];
                [self.viewController pushViewController:myView animated:YES];
        }
        }
    
    
    }
}



-(void)pushto:(NSString *)identifier{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:identifier];
    if([identifier isEqual:@"MineOrderHomeVC"]){
        myView.params = @{@"comeIdentifier":@"user"};
    }
    if([identifier isEqual:@"MybagViewController"]){
        myView.params = @{@"score":_userInfo[@"m_point"]} ;
    }
//    UITabBarController * tabBar = (UITabBarController*)[[SlideNavigationController sharedInstance].viewControllers firstObject];
//    UINavigationController *nav = (UINavigationController*)[tabBar selectedViewController];
    [self.viewController pushViewController:myView animated:YES];
//    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
//
//    }];

}

//-(NSMutableArray *) initQiyemenu{
//    NSMutableArray *results=[NSMutableArray array];
//    MineMenuModel *model = [MineMenuModel new];
//    model.title = @"我的订单";
//    model.icon = @"我的订单";
//    model.orderNum = 6;
//    [results addObject:model];
//    
//    
//    
//    
//    model = [MineMenuModel new];
//    model.title = @"我的发布";
//    model.icon = @"我的发布";
//    model.orderNum = 7;
//    [results addObject:model];
//
//    return  results;
//}
-(NSMutableArray *) initqiyemenu{
 NSMutableArray *results=[NSMutableArray array];
        MineMenuModel *model = [MineMenuModel new];
        model.title = @"企业团建，定制服务";
        model.icon = @"企业团建";
        model.orderNum = 6;
        [results addObject:model];

        model = [MineMenuModel new];
        model.title = @"设置";
        model.icon = @"设置";
        model.orderNum = 7;
        [results addObject:model];

    return results;
}


-(NSMutableArray *) initmenu: (NSInteger)identity{

    NSMutableArray *results=[NSMutableArray array];
    MineMenuModel *model = [MineMenuModel new];
    model.title = @"我的订单";
    model.icon = @"我的订单";
    model.orderNum = 2;
    [results addObject:model];

     model = [MineMenuModel new];
    model.title = @"活动相册";
    model.icon = @"我的发布";
    model.orderNum = 1;
    [results addObject:model];
 
    model = [MineMenuModel new];
    model.title = @"我的收藏";
    model.icon = @"收藏";
    model.orderNum = 3;
    [results addObject:model];
    
        model = [MineMenuModel new];
        model.title = @"设置";
        model.icon = @"卡券包";
        model.orderNum = 4;
        [results addObject:model];
    
    

    return results;
}
- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
