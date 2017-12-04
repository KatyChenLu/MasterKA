//
//  CourseReplyCommentViewController.m
//  HiGoMaster
//
//  Created by jinghao on 15/10/25.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "CourseReplyCommentViewController.h"
#import "CourseV3CommentTableViewCell.h"
#import "DXMessageToolBar.h"
#import "IQKeyboardManager.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CourseReplyCommentViewModel.h"


@interface CourseReplyCommentViewController ()<UITableViewDataSource,UITableViewDelegate,DXMessageToolBarDelegate>
@property (nonatomic,weak)IBOutlet UITableView* mTableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;
@property (nonatomic,strong)NSMutableArray* commentDataSource;
@property (nonatomic,strong)CourseReplyCommentViewModel *viewModel;

@end

@implementation CourseReplyCommentViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mTableView clearDefaultStyle];
    //消息cell注册
    UINib *cellNib = [UINib nibWithNibName:@"CourseV3CommentTableViewCell" bundle:nil];
    [self.mTableView registerNib:cellNib forCellReuseIdentifier:@"CourseV3CommentTableViewCell"];
    if (self.commentData) {
        [self.commentDataSource addObject:self.commentData];
    }
    [self.view addSubview:self.chatToolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = FALSE;
    [self showChatToolBar];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = TRUE;
}

- (CourseReplyCommentViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[CourseReplyCommentViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (NSMutableArray*)commentDataSource{
    if (_commentDataSource==nil) {
        _commentDataSource = [NSMutableArray array];
    }
    return _commentDataSource;
}
- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
         NSInteger height = IsPhoneX?34:0;
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight] - height, ScreenWidth, [DXMessageToolBar defaultHeight])];
        _chatToolBar.styleChangeButtonShow = TRUE;
        _chatToolBar.faceButtonShow = FALSE;
        _chatToolBar.imageButtonShow = TRUE;
        _chatToolBar.sendButtonShow = TRUE;
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        
        ChatMoreType type = ChatMoreTypeGroupChat;
        DXChatBarMoreView* moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 80) typw:type];
        //        moreView.delegate = self;
        _chatToolBar.moreView = moreView;
        _chatToolBar.moreView.backgroundColor = [UIColor lightGrayColor];
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _chatToolBar.inputTextView.placeHolder = @"说点什么吧";
    }
    return _chatToolBar;
}

- (void)doRepyComment:(NSString*)text{
    [self showHUDWithString:nil];
    
//    NSString* userId = self.commentData[@"superUserList"][@"uid"];
//    if (self.replyCommentData) {
//        userId = self.replyCommentData[@"myUid"];
//    }
    
//    [self.masterHttpManager doCourseReply:userId
//                                  content:text
//                                commentId:self.commentData[@"id"]
//                          webServiceBlock:^(id data, NSString *errorMsg, NSError *error) {
//                              if (errorMsg) {
//                                  [self dismissLoadingView:errorMsg error:TRUE];
//                              }else{
//                                  [self dismissLoadingView];
//                                  id replyList=self.commentData[@"replyList"];
//                                  if ([data isKindOfClass:[NSArray class]]) {
//                                      [replyList addObjectsFromArray:data];
//                                  }else{
//                                      [replyList addObject:data];
//                                  }
//                                  [self.mTableView reloadData];
//                                  //                                  [self.mTableView headerBeginRefreshing];
//                              }
//                          }];
}
// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)showChatToolBar{
    if (self.replyCommentData) {
        self.chatToolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复%@",self.replyCommentData[@"nickName"]];
    }else{
        self.chatToolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复%@",self.commentData[@"superUserList"][@"nickName"]];

    }
    self.chatToolBar.hidden = FALSE;
    [self.chatToolBar.inputTextView becomeFirstResponder];
}

#pragma mark -- CourseV3Page2ViewDelegate

- (void)courseV3Page2ViewCommentItem:(id)commentItem replyItem:(id)replyItem{
    if (replyItem) {
        if ([replyItem[@"myUid"] isEqual:[UserClient sharedUserClient].userId]) {
//            [self showTostCenter:@"自己不能对自己的回复进行回复哦"];
            return;
        }
    }else if(commentItem){
        if ([commentItem[@"superUserList"][@"uid"] isEqual:[UserClient sharedUserClient].userId]) {
//            [self showTostCenter:@"自己不能对自己的评论回复哦"];
            return;
        }
    }
    self.replyCommentData=replyItem;
    [self showChatToolBar];

}

#pragma mark -- DXMessageToolBarDelegate

- (void)didChangeFrameToHeight:(CGFloat)toHeight{
    [UIView animateWithDuration:0.3 animations:^{
        
    }];
}

- (void)didSendText:(NSString *)text{
    if (text.length>0) {
        [self doRepyComment:text];
        [self keyBoardHidden];
    }
}
#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"CourseV3CommentTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        CourseV3CommentTableViewCell* viewCell = cell;
        viewCell.itemData=self.commentDataSource[indexPath.row];
    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseV3CommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CourseV3CommentTableViewCell"];
    cell.itemData=self.commentDataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.commentDataSource[indexPath.row][@"superUserList"][@"uid"] isEqual:[UserClient sharedUserClient].userId]) {
//        [self showTostCenter:@"自己不能最自己的评论回复哦"];
        return;
    }
    self.replyCommentData=nil;
    [self showChatToolBar];
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
