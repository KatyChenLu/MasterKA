//
//  CommentListViewController.m
//  HiGoMaster
//
//  Created by jinghao on 15/3/9.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "CommentListViewController.h"
#import "DXMessageToolBar.h"
#import <objc/runtime.h>
#import "IQKeyboardManager.h"
#import "CommentListViewModel.h"
@interface CommentListViewController ()<DXMessageToolBarDelegate,UIActionSheetDelegate>
{
    NSString* otherUid;
    NSString* commentId;
    NSIndexPath* selectIndexPath;
}
@property (nonatomic,weak)IBOutlet UITableView* mTableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;
@property (nonatomic,strong)CommentListViewModel *viewModel;

@end

@implementation CommentListViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.title = @"评论列表";
    self.viewModel.isMasterShare = [self.params[@"master"] boolValue];
    self.viewModel.shareId = self.params[@"shareId"];
    self.viewModel.commentId = self.params[@"commentId"];
    
    self.viewModel.indexRow = self.params[@"row"];
   
    self.viewModel.index_article_id = self.index_article_id;
    self.viewModel.params = self.params;
    
    [self.viewModel bindTableView:self.mTableView];
    
    [self.view addSubview:self.chatToolBar];
    if(self.params[@"comeFrom"]){
        UIButton *rightbuton=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightbuton setFrame:CGRectMake(0, 20, 80, 40)];
        [rightbuton setTitle:@"查看原文" forState:UIControlStateNormal];
        [rightbuton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightbuton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        rightbuton.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
        [rightbuton addTarget:self action:@selector(pushToShareInfo) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:rightbuton];
        self.navigationItem.rightBarButtonItem = rightBar;
    }
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = FALSE;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = TRUE;
    
}

- (CommentListViewModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[CommentListViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}
-(void)pushToShareInfo{
    NSString * url ;
    if(self.viewModel.isMasterShare){
        url = [NSString stringWithFormat:@"%@?shareId=%@",URL_MasterShareDetail,self.viewModel.shareId];
    }else{
        url = [NSString stringWithFormat:@"%@?shareId=%@",URL_UserShareDetail,self.viewModel.shareId];
    
    }
    [self pushViewControllerWithUrl:url];
}
- (void)bindViewModel{
    [super bindViewModel];
    @weakify(self)
    [RACObserve(self.viewModel, replyData) subscribeNext:^(id replyData) {
        @strongify(self)
        if (replyData) {
            self.chatToolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复%@",replyData[@"nikename"]];
            [self.chatToolBar.inputTextView becomeFirstResponder];
        }else{
            self.chatToolBar.inputTextView.placeHolder = @"说点什么吧";
            [self.chatToolBar endEditing:YES];
        }
    }];
    
    [self.viewModel.sendCommentCommand.executionSignals.switchToLatest  subscribeNext:^(BaseModel *model) {
        @strongify(self)
        NSLog(@"===xxxxx===== %@",model);
        if (model.code==200) {
            self.viewModel.sendMessageResult = model.data;
            self.chatToolBar.inputTextView.text = nil;
            [self hiddenHUDWithString:@"发布成功" error:NO];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewView" object:nil];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresCommentView" object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:self.viewModel.indexRow,@"indexRow", model.data,@"sendMessageData",nil]];
        }else{
            [self showRequestErrorMessage:model];
        }

    }];
    
    [self.viewModel.sendCommentCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [self.view endEditing:NO];
            [self showHUDWithString:@"加载中..."];
        } else {
            
        }
    }];


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
    
    [self.chatToolBar.inputTextView resignFirstResponder];
    if ([self doLogin]) {
        [self.viewModel.sendCommentCommand execute:text];
    }
}

#pragma mark -- DXMessageToolBarDelegate

- (void)didChangeFrameToHeight:(CGFloat)toHeight{
    [UIView animateWithDuration:0.3 animations:^{
        
    }];
}

- (void)didSendText:(NSString *)text{
    if (text.length>0) {
        [self doRepyComment:text];
    }
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
