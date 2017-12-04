//
//  MyMsgVC.m
//  MasterKA
//
//  Created by xmy on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyMsgVC.h"
#import "BaseTableViewCell.h"
#import "SystemMessageViewController.h"
#import "MineCommentVC.h"
#import "MinePrivateListVC.h"
#import "ClickLikeController.h"
@interface MyMsgVC ()<rerfeshSystemBall,rerfeshCommentBall,rerfeshMinePrivateBall>

@end

@implementation MyMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    [self.mTableView clearDefaultStyle];
    self.mTableView.backgroundColor = self.view.backgroundColor;
    [self.navigationItem setTitle:@"消息"];
    self.dataSource=[NSMutableArray array];
    self.params[@"system_inform_num"]?[self.dataSource addObject:self.params[@"system_inform_num"]]:nil;
    self.params[@"comment_reply_num"]?[self.dataSource addObject:self.params[@"comment_reply_num"]]:nil;
    self.params[@"letter_num"]?[self.dataSource addObject:self.params[@"letter_num"]]:nil;
    [self.dataSource addObject:@""];
    NSLog(@"%@",self.dataSource);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    BaseTableViewCell *cell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier: [NSString stringWithFormat:@"MyMsgCell%ld",indexPath.row+1]];
    UIImageView *msg =[cell viewWithTag:10];
    if([[self.dataSource objectAtIndex:indexPath.row]integerValue]>0){
        [msg setHidden:NO];
    }else{
        [msg setHidden:YES];
    }
    cell.showCustomLineView = YES;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *vctUrl = @"";
    NSString *title = @"";
    UIViewController *vct;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    if(indexPath.row==0){
        title = @"系统通知";
//        vctUrl = [NSString stringWithFormat:@"%@",URL_MasterMineSystemMsg];
//         vct = [self.urlManager viewControllerWithUrl:vctUrl];
        SystemMessageViewController *myView = [story instantiateViewControllerWithIdentifier:@"SystemMessageViewController"];
        myView.delegate=self;
        myView.params = @{@"title":title};
        if (myView) {
            myView.title = title;
            [self pushViewController:myView animated:YES];
        }

    }else if (indexPath.row==1){
        title = @"评论、回复";
//        vctUrl = [NSString stringWithFormat:@"%@",URL_MasterMineComment];
        MineCommentVC *myView = [story instantiateViewControllerWithIdentifier:@"MineCommentVC"];
        __weak id sself =self;
        myView.delegate=sself;
        myView.params = @{@"title":title};
        if (myView) {
            myView.title = title;
            [self pushViewController:myView animated:YES];
        }
    }else if (indexPath.row==2){
        MinePrivateListVC *myView = [story instantiateViewControllerWithIdentifier:@"MinePrivateListVC"];
        __weak id sself =self;
        myView.delegate=sself;
        title = @"私信";
//        vctUrl = [NSString stringWithFormat:@"%@",URL_MasterMinePrivateList];
        myView.params = @{@"title":title};
        if (myView) {
            myView.title = title;
            [self pushViewController:myView animated:YES];
        }

    }else{
        title = @"点赞";
//        vctUrl = [NSString stringWithFormat:@"%@",URL_MasterMineSystemMsg];
        ClickLikeController *clickLikeVc = [[ClickLikeController alloc]init];
        clickLikeVc.title = title;
        
        
        [self pushViewController:clickLikeVc];
        
    }
    
//    UIViewController *vct = [self.urlManager viewControllerWithUrl:vctUrl];
   }
-(void)rerfeshSystemBall:(NSString *)identity{
    [self.dataSource replaceObjectAtIndex:0 withObject:@"0"];
      NSLog(@"%@",self.dataSource);
    [self.mTableView reloadData];
}
-(void)rerfeshCommentBall:(NSString *)identity{
    [self.dataSource replaceObjectAtIndex:1 withObject:@"0"];
    [self.mTableView reloadData];
}
-(void)rerfeshMinePrivateBall:(NSString *)identity{
    [self.dataSource replaceObjectAtIndex:2 withObject:@"0"];
    [self.mTableView reloadData];
}
@end
