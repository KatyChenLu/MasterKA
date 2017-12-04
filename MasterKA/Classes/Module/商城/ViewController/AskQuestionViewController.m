//
//  AskQuestionViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/8/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "AskQuestionViewController.h"

@interface AskQuestionViewController ()

@end

@implementation AskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        self.title = @"问大家";
    self.titleLabel.text = self.params[@"title"];
    
    self.sendButton.layer.cornerRadius = 10;
    self.sendButton.layer.masksToBounds = YES;
    
    self.questionTextView.placeholderStr = @"提问：";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self.questionTextView becomeFirstResponder];
    });
    
    RAC(self.sendButton,enabled) = [RACSignal combineLatest:@[self.questionTextView.rac_textSignal] reduce:^id(NSString * qusetionContent){
        return @(qusetionContent.length);
    }];
 
    [self.sendButton setBackgroundImage:[UIImage imageWithColor:RGBFromHexadecimal(0xFEDF1F)] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[UIImage imageWithColor:RGBFromHexadecimal(0xC1C1C1)] forState:UIControlStateDisabled];
    @weakify(self);
    [[self.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if ([self doLogin]) {
            [[[HttpManagerCenter sharedHttpManager] sendQuestionAddOfCourse:self.params[@"course_id"] content:self.questionTextView.text resultClass:nil] subscribeNext:^(BaseModel *baseModel) {
                if (baseModel.code == 200) {
                    [self hiddenHUDWithString:@"发布成功" error:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else{
                    [self hiddenHUDWithString:baseModel.message error:NO];
                }
            }];
            
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.questionTextView resignFirstResponder];
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
