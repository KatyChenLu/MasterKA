//
//  searchTableView.m
//  MasterKA
//
//  Created by lijiachao on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#define totalShareCellIdentifer @"totalShareCell"
#define HotMasterCellIdentifer @"HotMasterCell"
#import "UITableView+FDTemplateLayoutCell.h"
#import "searchTableView.h"
#import "LoopScrollView.h"
#import "RVMViewModel.h"
#import "HotMasterCell.h"
#import "totalShareCell.h"
#import "HostManShareModel.h"

@interface searchTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIView* sectionView;
    UILabel*showLabel;
    UILabel* englishShow;
    NSArray* hotCellList;
    NSMutableArray* shareCellList;
    NSMutableArray* shareCellList2;
    NSMutableArray* shareCellList3;
    NSArray* totalList;
    
    BOOL isOK;

    CGFloat x;
    UIView* line;
    
}
@property (nonatomic,strong, readwrite)RACCommand *removeshareCommand;
@property (nonatomic, strong) LoopScrollView *headView;
@property (nonatomic,strong) HostManShareModel* hostManShareList;

@property (nonatomic, strong)NSMutableArray *isAllBtnAtatusArr;
@property (nonatomic, strong)NSIndexPath *selectIndexPath;

@end

@implementation searchTableView

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DeleteSearchView" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showAll" object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if(self = [super initWithFrame:frame style:(UITableViewStyle)style]) {
        
        shareCellList = [NSMutableArray new];
        
        shareCellList2 = [NSMutableArray new];
        
        shareCellList3 = [NSMutableArray new];
        
        self.isAllBtnAtatusArr = [NSMutableArray new];
        
        self.dataSource = self;
        
        self.delegate = self;
        
        self.mtableRfreshId = 3;
        
        self.first1 = NO;
        
        self.currentTag =1;
        
        x = (([UIScreen mainScreen].bounds.size.width-60)/3);
        
        self.yy =x/2-15;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelView:) name:@"DeleteSearchView" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAll:) name:@"showAll" object:nil];
        
        [self registerClass:[HotMasterCell class] forCellReuseIdentifier:HotMasterCellIdentifer];
        
        [self registerClass:[totalShareCell class] forCellReuseIdentifier:totalShareCellIdentifer];
        
        @weakify(self)
        
        
        [RACObserve(self, shareTableList) subscribeNext:^(MasterSearchListModel *list) {
            
            @strongify(self)
            
            if(list.master_list.count>0){
                
                hotCellList = list.master_list;
                
            }
            
            if(self.first1==NO&&list.share_list!=nil){
                
                [shareCellList addObjectsFromArray:list.share_list];
                
                totalList = shareCellList;
                
                self.first1 =YES;
                
            }
            
            if(self.mtableRfreshId ==1){
                
                [shareCellList addObjectsFromArray:list.share_list];
                
                totalList = shareCellList;
                
                self.mtableRfreshId =3;
                
                
                
            }
            
            if(self.mtableRfreshId ==0||self.mtableRfreshId==nil){
                
                [shareCellList removeAllObjects];
                
                [shareCellList addObjectsFromArray:list.share_list];
                
                totalList = shareCellList;
                
                self.mtableRfreshId =3;
                
            }
            
            
            for (int i = 0; i< totalList.count; i++) {
                [self.isAllBtnAtatusArr addObject:@"0"];
            }
            
            [self reloadData];
            
            
        }];
        
        [RACObserve(self, shareTableList2) subscribeNext:^(MasterSearchListModel *list) {
            
            @strongify(self)
            
            if(list.master_list.count>0){
                
                hotCellList = list.master_list;
                
            }
            if(self.first2==NO&&list.share_list!=nil){
                
                [shareCellList2 removeAllObjects];
                
                [shareCellList2 addObjectsFromArray:list.share_list];
                
                totalList = shareCellList2;
                
                self.first2 =YES;
                
            }
            
            if(self.mtableRfreshId ==1){
                
                [shareCellList2 addObjectsFromArray:list.share_list];
                
                totalList = shareCellList2;
                
                self.mtableRfreshId =3;
                
            }
            
            if(self.mtableRfreshId ==0){
                
                [shareCellList2 removeAllObjects];
                
                [shareCellList2 addObjectsFromArray:list.share_list];
                
                totalList = shareCellList2;
                
                self.mtableRfreshId =3;
                
            }
            
            for (int i = 0; i< totalList.count; i++) {
                [self.isAllBtnAtatusArr addObject:@"0"];
            }
            
            [self reloadData];
            
        }];
        
        [RACObserve(self, shareTableList3) subscribeNext:^(MasterSearchListModel *list) {
            
            @strongify(self)
            
            if(list.master_list.count>0){
                
                hotCellList = list.master_list;
                
            }
            
            if(self.first3==NO&&list.share_list!=nil){
                
                [shareCellList3 removeAllObjects];
                
                [shareCellList3 addObjectsFromArray:list.share_list];
                
                totalList = shareCellList3;
                
                self.first3 =YES;
                
            }
            
            if(self.mtableRfreshId ==1){
                
                [shareCellList3 addObjectsFromArray:list.share_list];
                
                totalList = shareCellList3;
                
                self.mtableRfreshId =3;
                
            }
            if(self.mtableRfreshId ==0){
                
                [shareCellList3 removeAllObjects];
                
                [shareCellList3 addObjectsFromArray:list.share_list];
                
                totalList = shareCellList3;
                
                self.mtableRfreshId =3;
                
            }
            
            for (int i = 0; i< totalList.count; i++) {
                [self.isAllBtnAtatusArr addObject:@"0"];
            }
            [self reloadData];
            
        }];
        
    }
    
    return self;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    
    if(scrollView.contentOffset.y>=445){
        
        self.isOnTop =YES;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.mostHostBtn.backgroundColor = [UIColor clearColor];
            
            self.newestBtn.backgroundColor = [UIColor clearColor];
            
            self.guanzhuBtn.backgroundColor = [UIColor clearColor];
            
            line.backgroundColor = RGBFromHexadecimal(0xFEDF1F);
            
        } completion:^(BOOL finished) {

        }];
        
    }else{
        
        self.isOnTop = NO;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.mostHostBtn.backgroundColor = self.currentTag==1?RGBFromHexadecimal(0xFEDF1F):RGBFromHexadecimal(0xEAEAEA);
            
            self.newestBtn.backgroundColor = self.currentTag==2?RGBFromHexadecimal(0xFEDF1F):RGBFromHexadecimal(0xEAEAEA);
            
            self.guanzhuBtn.backgroundColor = self.currentTag==3?RGBFromHexadecimal(0xFEDF1F):RGBFromHexadecimal(0xEAEAEA);
            
            line.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished) {
        
        }];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section ==0){
        
        return 1;
        
    }else{
        
        return totalList.count;
        
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section ==0){
        HotMasterCell*cella;
        cella =[tableView dequeueReusableCellWithIdentifier:HotMasterCellIdentifer forIndexPath:indexPath];
        if(hotCellList!=nil&&hotCellList.count>0){
            [cella  setHotCellData:hotCellList];
        }
        return cella;
    }
    else{
        totalShareCell*cell;
        
        cell =[tableView dequeueReusableCellWithIdentifier:totalShareCellIdentifer forIndexPath:indexPath];
        if(totalList!=nil&& totalList.count>0)
        {
            [cell setShareList:totalList[indexPath.row] isfromHeight:NO deleteIndex:indexPath isAll:[_isAllBtnAtatusArr[indexPath.row] isEqualToString:@"1"]];
        }
        
        return cell;
    }
    //return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        return [tableView fd_heightForCellWithIdentifier:HotMasterCellIdentifer cacheByIndexPath:indexPath configuration:nil];
    }
    
    else{
        return [tableView fd_heightForCellWithIdentifier:totalShareCellIdentifer cacheByIndexPath:indexPath configuration:^(id cell) {
            
            totalShareCell*cella = cell;
            if(totalList!=nil&& totalList.count>0)
            {
                [cella setShareList:totalList[indexPath.row] isfromHeight:YES deleteIndex:indexPath isAll:[_isAllBtnAtatusArr[indexPath.row] isEqualToString:@"1"]];
            }
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
       UIView * footerView = [[UIView alloc]init];
        footerView.backgroundColor = [UIColor whiteColor];
        
        UIView *linview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
        linview.backgroundColor = self.backgroundColor;
        [footerView addSubview:linview];
        
        showLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 50, 20)];
        showLabel.text = @"晒分享";
        showLabel.font = [UIFont systemFontOfSize:14];
        showLabel.textColor = [UIColor blackColor];
        showLabel.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:showLabel];
        
        englishShow = [[UILabel alloc]initWithFrame:CGRectMake(65, 17, 100, 15)];
        englishShow.text = @"Share Yourself";
        englishShow.font = [UIFont systemFontOfSize:12];
        englishShow.textColor = RGBFromHexadecimal(0x999999);
        englishShow.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:englishShow];
        return footerView;
    }else{
        return nil;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section ==1){
        sectionView = [[UIView alloc]init];
        sectionView.backgroundColor = [UIColor whiteColor];
        
        line = [[UIView alloc]initWithFrame:CGRectMake(self.yy, 32, 60, 2)];
        line.backgroundColor = [UIColor clearColor];
        [sectionView addSubview:line];

        self.mostHostBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, x, 28)];
        [self.mostHostBtn setTitle:@"最新" forState:UIControlStateNormal];
        self.mostHostBtn.tag =1;
        self.mostHostBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.mostHostBtn setTitleColor:RGBFromHexadecimal(0x464646) forState:UIControlStateNormal];
        self.mostHostBtn.layer.cornerRadius = 12.5;
        self.mostHostBtn.layer.masksToBounds = YES;
        [self.mostHostBtn addTarget:self action:@selector(clicked1:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:self.mostHostBtn];
        
        self.newestBtn = [[UIButton alloc]initWithFrame:CGRectMake(15*2+x, 5, x, 28)];
        [self.newestBtn setTitle:@"最热" forState:UIControlStateNormal];
        self.newestBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.newestBtn.tag =2;
        self.newestBtn.layer.cornerRadius = 12.5;
        self.newestBtn.layer.masksToBounds = YES;
        [self.newestBtn addTarget:self action:@selector(clicked1:) forControlEvents:UIControlEventTouchUpInside];
        [self.newestBtn setTitleColor:RGBFromHexadecimal(0x464646) forState:UIControlStateNormal];
        [sectionView addSubview:self.newestBtn];
        
        self.guanzhuBtn = [[UIButton alloc]initWithFrame:CGRectMake(15*3+2*x, 5, x, 28)];
        [self.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.guanzhuBtn.layer.cornerRadius = 12.5;
        self.guanzhuBtn.layer.masksToBounds = YES;
        self.guanzhuBtn.tag=3;
        [self.guanzhuBtn addTarget:self action:@selector(clicked1:) forControlEvents:UIControlEventTouchUpInside];
        [self.guanzhuBtn setTitleColor:RGBFromHexadecimal(0x464646) forState:UIControlStateNormal];
        [sectionView addSubview:self.guanzhuBtn];
        if(_isOnTop ==NO){
        self.mostHostBtn.backgroundColor = self.currentTag==1?RGBFromHexadecimal(0xFEDF1F):RGBFromHexadecimal(0xEAEAEA);
        self.newestBtn.backgroundColor = self.currentTag==2?RGBFromHexadecimal(0xFEDF1F):RGBFromHexadecimal(0xEAEAEA);
            self.guanzhuBtn.backgroundColor = self.currentTag==3?RGBFromHexadecimal(0xFEDF1F):RGBFromHexadecimal(0xEAEAEA);
        }
        else{
            self.mostHostBtn.backgroundColor = [UIColor clearColor];
            self.newestBtn.backgroundColor = [UIColor clearColor];
            self.guanzhuBtn.backgroundColor = [UIColor clearColor];
            line.backgroundColor = RGBFromHexadecimal(0xFEDF1F);
        
        }
        return sectionView;
    }
    else{
        return nil;
    }
}


-(void)switchLine:(int)num{
    
    if(num ==1){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            line.frame = CGRectMake(x/2-15, 32, 60, 2);
            
            NSLog(@"1");
        } completion:^(BOOL finished) {
            self.currentTag = 1;
            self.NextViewControllerBlock(self.currentTag);
            totalList = shareCellList;
            self.btnChanged = NO;
            [self reloadData];
            if(self.isOnTop ==YES){
                NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionTop
                                    animated:NO];
            }
            
        }];
    }
    else if(num ==2){
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            line.frame = CGRectMake(3.0*x/2, 32, 60, 2);
            NSLog(@"1");
        } completion:^(BOOL finished) {
            self.currentTag = 2;
            self.btnChanged = YES;
            self.NextViewControllerBlock(self.currentTag);
            
            // }
            if(self.first2 ==YES){
                totalList = shareCellList2;
                [self reloadData];
                self.btnChanged = NO;
                if(self.isOnTop ==YES){
                    NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionTop
                                        animated:NO];
                }
            }
        }];
    }
    else{
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            line.frame = CGRectMake(5.0*x/2+15, 32, 60, 2);
            NSLog(@"1");
        } completion:^(BOOL finished) {
            
            self.currentTag = 3;
            self.btnChanged = YES;
            self.NextViewControllerBlock(self.currentTag);
            // }
            
            if(self.first3 ==YES){
                totalList = shareCellList3;
                [self reloadData];
                self.btnChanged = NO;
                if(self.isOnTop ==YES){
                    NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionTop
                                        animated:NO];
                }
            }
        }];
    }
}

//clicked changed
-(void)clicked1:(UIButton*)sender{
    int tag = sender.tag;
    if(tag !=self.currentTag){
        
        
        switch (sender.tag) {
            case 1:
                self.yy =x/2-15;
                if(self.isOnTop==YES){
                    [self switchLine:1];
                }
                else{
                    self.currentTag = tag;
                    self.NextViewControllerBlock(self.currentTag);
                    totalList = shareCellList;
                    self.btnChanged = NO;
                    [self reloadData];
//                    if(self.isOnTop ==YES){
//                        NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//                        [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionTop
//                                            animated:NO];
//                    }
                }
                break;
            case 2:
                self.yy =3.0*x/2;
                if(self.isOnTop==YES){
                    [self switchLine:2];}
                else{
                    self.currentTag = tag;
                    self.btnChanged = YES;
                    self.NextViewControllerBlock(self.currentTag);
                    
                    // }
                    if(self.first2 ==YES){
                        totalList = shareCellList2;
                        [self reloadData];
                        self.btnChanged = NO;
                    }
                }
                break;
                
            case 3:
                
                if(![UserClient sharedUserClient].rawLogin){
                //    UIViewController *vc = [MasterUrlManager getViewControllerWithUrl:URL_MasterLoginRoot];
                    id object = [self nextResponder];
                    
                    while (![object isKindOfClass:[UIViewController class]] &&
                           object != nil) {
                        object = [object nextResponder];
                    }
                    
                    BaseViewController *uc=(BaseViewController*)object;
                    [uc doLogin];
//                    [uc presentViewController:vc animated:TRUE completion:^{
//                    }];
                    
                }else{
                    self.yy =5.0*x/2+15;
                    if(self.isOnTop==YES){
                        [self switchLine:3];}
                    else{
                        self.currentTag = tag;
                        self.btnChanged = YES;
                        self.NextViewControllerBlock(self.currentTag);
                        // }
                        
                        if(self.first3 ==YES){
                            totalList = shareCellList3;
                            [self reloadData];
                            self.btnChanged = NO;
                        }
                    }
                }
                break;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 1)
    {
        return 37;
        
    }
    else{
        return 7.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0)
    {
        return 40;
    }
    else{
        return 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //  去掉cell点击灰的效果
    if(indexPath.section ==1){
        MasterShareModel *mode = totalList[indexPath.row];
        
        self.selectIndexPath = indexPath;
        
        id object = [self nextResponder];
        
        while (![object isKindOfClass:[UIViewController class]] &&
               object != nil) {
            object = [object nextResponder];
        }
        BaseViewController *uc=(BaseViewController*)object;
        if([mode.master isEqualToString:@"user"]){
            
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserShare" bundle:[NSBundle mainBundle]];
            UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"UserShareDetailViewController"];
            
            MasterShareModel *mode = totalList[indexPath.row];
            NSDictionary * dic =mode.detail[0];
            
            myView.params = @{@"shareId":mode.share_id,@"media_type":[dic objectForKey:@"media_type"],@"movieurl":[dic objectForKey:@"intro"],@"row":@(indexPath.row)} ;
            
            [uc.navigationController pushViewController:myView animated:YES];
        }
        else{
            NSString * url = [NSString stringWithFormat:@"%@?shareId=%@",URL_MasterShareDetail,mode.share_id];
            [uc pushViewControllerWithUrl:url];
        }
    }
}
- (void)showAll:(NSNotification *)notification {
 
    NSIndexPath * index = [notification object][0];
    for (int i = 0; i < _isAllBtnAtatusArr.count; i++) {
        if (i == index.row) {
            
            _isAllBtnAtatusArr[i] = [_isAllBtnAtatusArr[i] isEqualToString:@"1"]?@"0":@"1";
        }
    }
    [self reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    
}

-(void)cancelView:(NSNotification*) notification{
    isOK = NO;
    NSArray* array =  [notification object];
    if([array[2] isEqualToString:@"user"]){
    @weakify(self);
    [[[HttpManagerCenter sharedHttpManager] removeUserShare:array[0] resultClass:nil] subscribeNext:^(BaseModel *model){
        @strongify(self);
        if(model.code ==200){
            isOK =YES;
          //  [self.viewController hiddenHUDWithString:model.message error:NO];
            NSMutableArray * temp =[[NSMutableArray alloc]initWithArray:totalList];
            
            NSIndexPath * index = array[1];
            [temp removeObjectAtIndex:index.row];
            totalList = temp;
            if(self.currentTag ==1){
               [shareCellList removeObjectAtIndex:index.row];
                
            }
            else if(self.currentTag ==2){
             [shareCellList2 removeObjectAtIndex:index.row];
            
            }
            else {
            
            [shareCellList3 removeObjectAtIndex:index.row];
            }
            [self reloadData];
        }else{
           // [self showRequestErrorMessage:model];
        }
    }
      completed:^{
          if(isOK ==YES){
          if(self.currentTag ==1){
              for (int i=0;i<shareCellList2.count;i++) {
                  MasterShareModel*model = shareCellList2[i];
                  if([model.share_id isEqualToString:array[0]]){
                      [shareCellList2 removeObjectAtIndex:i];
                  }
              }
              for (int i=0;i<shareCellList3.count;i++) {
                  MasterShareModel*model = shareCellList3[i];
                  if([model.share_id isEqualToString:array[0]]){
                      [shareCellList3 removeObjectAtIndex:i];
                  }
              }
          }
          
          else if(self.currentTag ==2){
              for (int i=0;i<shareCellList.count;i++) {
                  MasterShareModel*model = shareCellList[i];
                  if([model.share_id isEqualToString:array[0]]){
                      [shareCellList removeObjectAtIndex:i];
                  }
              }
              for (int i=0;i<shareCellList3.count;i++) {
                  MasterShareModel*model = shareCellList3[i];
                  if([model.share_id isEqualToString:array[0]]){
                      [shareCellList3 removeObjectAtIndex:i];
                  }
              }
          }
          else if(self.currentTag ==3){
              for (int i=0;i<shareCellList2.count;i++) {
                  MasterShareModel*model = shareCellList2[i];
                  if([model.share_id isEqualToString:array[0]]){
                      [shareCellList2 removeObjectAtIndex:i];
                  }
              }
              for (int i=0;i<shareCellList.count;i++) {
                  MasterShareModel*model = shareCellList[i];
                  if([model.share_id isEqualToString:array[0]]){
                      [shareCellList removeObjectAtIndex:i];
                  }
              }
          }
          }
      }
     ];
    }
    else{
        @weakify(self);
        [[[HttpManagerCenter sharedHttpManager] removeMasterShare:array[0] resultClass:nil] subscribeNext:^(BaseModel *model){
            @strongify(self);
            if(model.code ==200){
                isOK = YES;
                //  [self.viewController hiddenHUDWithString:model.message error:NO];
                NSMutableArray * temp =[[NSMutableArray alloc]initWithArray:totalList];
                
                NSIndexPath * index = array[1];
                [temp removeObjectAtIndex:index.row];
                totalList = temp;
                if(self.currentTag ==1){
                    [shareCellList removeObjectAtIndex:index.row];
                    
                }
                else if(self.currentTag ==2){
                    [shareCellList2 removeObjectAtIndex:index.row];
                    
                }
                else {
                    
                    [shareCellList3 removeObjectAtIndex:index.row];
                }
                [self reloadData];
            }else{
                // [self showRequestErrorMessage:model];
            }
        }
    completed:^{
        if(isOK == YES){
        if(self.currentTag ==1){
            for (int i=0;i<shareCellList2.count;i++) {
                MasterShareModel*model = shareCellList2[i];
                if([model.share_id isEqualToString:array[0]]){
                    [shareCellList2 removeObjectAtIndex:i];
                }
            }
            for (int i=0;i<shareCellList3.count;i++) {
                MasterShareModel*model = shareCellList3[i];
                if([model.share_id isEqualToString:array[0]]){
                    [shareCellList3 removeObjectAtIndex:i];
                }
            }
        }
        else if(self.currentTag ==2){
            for (int i=0;i<shareCellList.count;i++) {
                MasterShareModel*model = shareCellList[i];
                if([model.share_id isEqualToString:array[0]]){
                    [shareCellList removeObjectAtIndex:i];
                }
            }
            for (int i=0;i<shareCellList3.count;i++) {
                MasterShareModel*model = shareCellList3[i];
                if([model.share_id isEqualToString:array[0]]){
                    [shareCellList3 removeObjectAtIndex:i];
                }
            }
            
        }
        else if(self.currentTag ==3){
            for (int i=0;i<shareCellList2.count;i++) {
                MasterShareModel*model = shareCellList2[i];
                if([model.share_id isEqualToString:array[0]]){
                    [shareCellList2 removeObjectAtIndex:i];
                }
            }
            for (int i=0;i<shareCellList.count;i++) {
                MasterShareModel*model = shareCellList[i];
                if([model.share_id isEqualToString:array[0]]){
                    [shareCellList removeObjectAtIndex:i];
                }
            }
        }
        }
    } ];
    }
}

- (void)addCommentWithSendMessage:(NSDictionary *)sendMessage indexRow:(NSString *)row {
    if (sendMessage != nil && ![row isEqualToString:@""]) {
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[row integerValue] inSection:1];
        
        totalShareCell *cell =  [self cellForRowAtIndexPath:indexpath];
        
        
        MasterShareModel* model = totalList[indexpath.row];
        
        
//        [model.comment_list insertObject:sendMessage atIndex:0];
        
        [model.comment_list insertObject:sendMessage atIndex:model.comment_list.count];
        
        [cell setShareList:model isfromHeight:NO deleteIndex:indexpath isAll:[_isAllBtnAtatusArr[self.selectIndexPath.row] isEqualToString:@"1"]];
        
    }
    

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
