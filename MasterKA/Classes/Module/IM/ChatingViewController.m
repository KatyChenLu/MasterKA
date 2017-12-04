//
//  ChatingViewController.m
//  HiGoMaster
//
//  Created by jinghao on 15/3/17.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "ChatingViewController.h"
#import "DXMessageToolBar.h"
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "ChatingViewModel.h"

@interface ChatingViewController ()<UITableViewDataSource,UITableViewDelegate,DXMessageToolBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DXChatBarMoreViewDelegate>
{
    dispatch_queue_t _messageQueue;
}
@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic,strong) ChatingViewModel *viewModel;

@end

@implementation ChatingViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    self.viewModel.title = @"私信";
    self.viewModel.otherUserid = self.params[@"userId"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mTableView];
    //    [self.tableView addSubview:self.slimeView];
    [self.view addSubview:self.chatToolBar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    [self.viewModel bindTableView:self.mTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[IQKeyboardManager sharedManager] setEnable:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- getter

- (void)bindViewModel
{
    [super bindViewModel];
//    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
//        NSLog(@"=====================%@",x);
//    }];
    @weakify(self);
    [self.viewModel.sendMessageCommand.executionSignals.switchToLatest map:^id(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            self.chatToolBar.inputTextView.text = nil;
            [self hiddenHUD];
            [self.viewModel next];
        }else{
//            [self hiddenHUDWithString:model.message error:YES];
            [self showRequestErrorMessage:model];
        }
        return model;
    }];
    
    
}

- (ChatingViewModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[ChatingViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}

- (NSMutableArray*)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView*)mTableView{
    if (_mTableView == nil) {
        NSInteger height = IsPhoneX?34:0;
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - [DXMessageToolBar defaultHeight] - height) style:UITableViewStylePlain];
        _mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.backgroundColor = [UIColor whiteColor];
        _mTableView.tableFooterView = [[UIView alloc] init];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self addRefreshControl:_mTableView];
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_mTableView addGestureRecognizer:lpgr];
    }
    
    return _mTableView;
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        NSInteger height = IsPhoneX?34:0;
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight] - height, self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.styleChangeButtonShow = TRUE;
        _chatToolBar.faceButtonShow = FALSE;
        _chatToolBar.sendButtonShow = TRUE;
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        
        ChatMoreType type = ChatMoreTypeGroupChat;
        DXChatBarMoreView* moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 80) typw:type];
        moreView.delegate = self;
        _chatToolBar.moreView = moreView;
        _chatToolBar.moreView.backgroundColor = [UIColor lightGrayColor];
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _chatToolBar.inputTextView.placeHolder = @"说点什么吧";
    }
    return _chatToolBar;
}
- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

#pragma mark -- 数据请求

-(void)sendTextMessage:(NSString *)textMessage{
    [self.viewModel.sendMessageCommand execute:textMessage];
}
-(void)sendImageMessage:(UIImage *)imageMessage
{
    [self keyBoardHidden];
    [self.viewModel.sendMessageCommand execute:imageMessage];
}
#pragma mark -- 私有方法

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
//    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
//        CGPoint location = [recognizer locationInView:self.mTableView];
//        NSIndexPath * indexPath = [self.mTableView indexPathForRowAtPoint:location];
//        id object = [self.dataSource objectAtIndex:indexPath.row];
//        if ([object isKindOfClass:[MessageModel class]]) {
//            EMChatViewCell *cell = (EMChatViewCell *)[self.mTableView cellForRowAtIndexPath:indexPath];
//            [cell becomeFirstResponder];
//            _longPressIndexPath = indexPath;
//            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
//        }
//    }
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.mTableView.contentSize.height > self.mTableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.mTableView.contentSize.height - self.mTableView.frame.size.height);
        [self.mTableView setContentOffset:offset animated:YES];
    }
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.textLabel.text = (NSString *)obj;
            
            return timeCell;
        }
        else{
            MessageModel *model = (MessageModel *)obj;
            NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
            EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.messageModel = model;
            return cell;
        }
    }else{
      return nil;
    }
   
}

#pragma mark --  UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
        return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
    }
}


#pragma mark - DXMessageToolBarDelegate

- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
//    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.mTableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.mTableView.frame = rect;
    }];
    [self scrollViewToBottom:YES];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        __weak ChatingViewController *weakSelf = self;
        dispatch_async(_messageQueue, ^{
            [weakSelf sendTextMessage:text];
        });
        [self keyBoardHidden];
    }
}
#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
//    [self showTostBottom:@"模拟器不支持拍照"];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
//        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        __weak ChatingViewController *weakSelf = self;
         dispatch_async(_messageQueue, ^{
             [weakSelf sendImageMessage:orgImage];
         });
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
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
