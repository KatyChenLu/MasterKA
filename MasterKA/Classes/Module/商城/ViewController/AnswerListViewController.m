//
//  QuestionDetailViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/8/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "AnswerListViewController.h"
#import "AnswerListViewModel.h"
#import "DXMessageToolBar.h"

@interface AnswerListViewController ()<DXMessageToolBarDelegate>

@property (nonatomic, strong)AnswerListViewModel *viewModel;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;
@end

@implementation AnswerListViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"问题详情";
    
    [self.viewModel bindTableView:self.mTableView];
    self.viewModel.questionId = self.params[@"question_id"];
    self.mTableView.canCancelContentTouches = NO;
    [self.view addSubview:self.chatToolBar];
    self.chatToolBar.inputTextView.placeHolder = @"回答";
    self.chatToolBar.inputTextView.placeImg =  [UIImage imageNamed:@"提问"];
}


- (AnswerListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[AnswerListViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}
- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [RACObserve(self.viewModel, info) subscribeNext:^(NSDictionary * info) {
        @strongify(self);
        self.titleLabel.text = info[@"course"][@"title"];
        self.askLabel.text = info[@"question"][@"question_content"];
    }];
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], ScreenWidth, [DXMessageToolBar defaultHeight])];
        _chatToolBar.styleChangeButtonShow = TRUE;
        _chatToolBar.faceButtonShow = TRUE;
        _chatToolBar.imageButtonShow = TRUE;
        _chatToolBar.sendButtonShow = false;
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        _chatToolBar.backgroundColor = RGBFromHexadecimal(0xefefef);
        @weakify(self);
        [_chatToolBar setSendClick:^{
            
            [[[HttpManagerCenter sharedHttpManager] sendAnswerAddOfCourse:self.params[@"question_id"] content: _chatToolBar.inputTextView.text resultClass:nil] subscribeNext:^(BaseModel *baseModel) {
                @strongify(self);
                if (baseModel.code==200) {
                    [self hiddenHUDWithString:@"发布成功" error:NO];
                    [self.viewModel first];
                }else{
                     [self hiddenHUDWithString:baseModel.message error:NO];
                }
                
            }];
            
            _chatToolBar.inputTextView.text = nil;
            [_chatToolBar endEditing:YES];
       
            
        }];
        
        _chatToolBar.inputTextView.backgroundColor = [UIColor redColor];
        _chatToolBar.inputTextView.placeHolder = @"回答";
        
        
    }
    return _chatToolBar;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self keyBoardHidden];
}

#pragma mark -- DXMessageToolBarDelegate

- (void)didChangeFrameToHeight:(CGFloat)toHeight{
    [UIView animateWithDuration:0.3 animations:^{
        
    }];
}

- (void)didSendText:(NSString *)text{
    if (text.length>0) {
        
        [self keyBoardHidden];
    }
}
// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
