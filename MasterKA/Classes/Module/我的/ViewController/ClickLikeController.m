//
//  ClickLikeController.m
//  
//
//  Created by 余伟 on 16/8/23.
//
//

#define LikeListCell @"ClickLikeCell"

#import "ClickLikeController.h"
#import "ClickLikeCell.h"
#import "HttpManagerCenter.h"
#import "ClickLikeModel.h"
#import "MasterTableHeaderView.h"
#import "MasterTableFooterView.h"
@interface ClickLikeController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic ,strong)NSMutableArray * dataSource;


@end


@implementation ClickLikeController
{
    UITableView *_likeList;
    
    NSInteger  _page;
    
    NSString * _pageSize;
}



-(void)setDataSource:(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        
        _dataSource = dataSource.mutableCopy;
        
    }else
    {
        [_dataSource addObjectsFromArray:dataSource];
        
    }
    
}



-(void)viewDidLoad

{
    
    [super viewDidLoad];
    
    _page = 1;
    
    _pageSize = @"20";
    
    _likeList = [[UITableView alloc]init];
    [self.view addSubview:_likeList];
    
    _likeList.backgroundColor = MasterBackgroundColer;
    
    [_likeList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.left.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        
    }];

    _likeList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _likeList.delegate = self;
    
    _likeList.dataSource = self;
    
    [_likeList registerClass:[ClickLikeCell class] forCellReuseIdentifier:LikeListCell];
    
//    _likeList.mj_header = [MasterTableHeaderView headerWithRefreshingBlock:^{
//        
//        [self first];
//        
//    }];
    _likeList.mj_header = [MasterTableHeaderView addRefreshGifHeadViewWithRefreshBlock:^{
        
        [self first];
        
    }];
    
    _likeList.mj_footer = [MasterTableFooterView footerWithRefreshingBlock:^{
        
        [self next];
       
        
    }];
    
    [self initRemoteData];
    
}






-(void)first
{
    _page = 1;
    [self.dataSource removeAllObjects];
    
    [_likeList.mj_footer resetNoMoreData];
    
    [self initRemoteData];
    
}

-(void)next
{
    _page++;
    
    [self initRemoteData];
    
}


-(void)initRemoteData
{
    
    [[[HttpManagerCenter sharedHttpManager]clickLike:[NSString stringWithFormat:@"%ld" , _page] pageSize:_pageSize resultClass:[ClickLikeModel class]]subscribeNext:^(BaseModel* model) {
        
        if (model.code == 200) {
            
            
            [self showHUDWithString:@"加载中"];
         
            self.dataSource = model.data;

        }
 
        
    }error:^(NSError *error) {
        
       
    }completed:^{
        
        
        [_likeList reloadData];
        
        [_likeList.mj_header endRefreshing];
        [_likeList.mj_footer endRefreshing];
        
        [self hiddenHUD];
    }];
    
    
    
}





#pragma UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClickLikeCell * cell = [tableView dequeueReusableCellWithIdentifier:LikeListCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.dataSource[indexPath.row];
    
        return cell;
}



#pragma UITableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ClickLikeModel * model = self.dataSource[indexPath.row];
    
    [self pushViewControllerWithUrl:model.pfurl];
    
    
    
}


@end
