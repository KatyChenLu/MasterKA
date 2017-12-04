//
//  FeedbackViewController.m
//  HiGoMaster
//
//  Created by jinghao on 15/3/13.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "FeedbackViewController.h"
#import "IQKeyboardManager.h"

@interface FeedbackViewController ()
@property (nonatomic,weak)IBOutlet UITextView* feedbackView;
@property (nonatomic,weak)IBOutlet UIButton* submitButton;
@property (nonatomic,weak)IBOutlet UIButton* reportButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"意见反馈";
       
   
    [self.feedbackView becomeFirstResponder];
    
    
    [self.navigationItem addRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(doSubmitButton:)] animated:YES];
    
    self.submitButton.hidden = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = FALSE;
//    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:TRUE];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = TRUE;
//    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:TRUE];
}

- (IBAction)doSubmitButton:(id)send{
    if (self.feedbackView.text.length>0) {
        HttpManagerCenter *httpService = [HttpManagerCenter sharedHttpManager];
        [[httpService submitSuggest:self.feedbackView.text resultClass:nil] subscribeNext:^(BaseModel *model) {
            if(model.code == 200){
               [self toastWithString:model.message error:NO];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self gotoBack];
                });
               
            }else{
                [self showRequestErrorMessage:model];
            }
            
        } error:^(NSError *error) {
            
        } completed:^{
            //         [self hiddenHUDWithString:nil error:NO];
        }];
        
        
    }
}

- (IBAction)doShowReportRule:(id)sender{
    NSString *path = @"http://kaifa.gomaster.cn/attms/daren/daren_zhuye.html";
    [self pushViewControllerWithUrl:path];
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
