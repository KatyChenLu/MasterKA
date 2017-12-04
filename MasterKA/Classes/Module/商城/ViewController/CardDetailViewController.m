//
//  CardDetailViewController.m
//  MasterKA
//
//  Created by hyu on 16/5/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CardDetailViewController.h"

@interface CardDetailViewController ()

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCardDetail];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getCardDetail{
    [[[HttpManagerCenter sharedHttpManager] getCardDetail:self.params[@"cardId"] resultClass:nil] subscribeNext:^(BaseModel *model){
        if(model.code==200){
            _cardInfo=model.data;
            [_pic_url setImageWithURLString:_cardInfo[@"pic_url"] placeholderImage:nil];
               self.intro.text = self.cardInfo[@"intro"];
        }else{
//            [self hiddenHUDWithString:model.message error:NO];
            [self showRequestErrorMessage:model];
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
