//
//  BindPhoneModel.m
//  MasterKA
//
//  Created by 余伟 on 16/7/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BindPhoneModel.h"


@interface BindPhoneModel ()


//从服务器获取的验证码
@property (nonatomic,copy)NSString *realPhoneCode;
@property (nonatomic,strong)NSNumber *littleTime ;
@property (nonatomic,strong)NSTimer *codeTimer ;
@property (nonatomic, strong, readwrite) RACSignal *validRegisterSignal;
@property (nonatomic, strong, readwrite) RACSignal *validCodeSignal;
@property (nonatomic, strong, readwrite) RACCommand *phoneCodeCommand;
@property (nonatomic, strong, readwrite) RACCommand *determineCommand;
@property (nonatomic, strong, readwrite) NSString *phoneCodeText;


@end


@implementation BindPhoneModel


- (void)initialize{
    [super initialize];

    
    self.phoneCodeText = @"发送验证码";
    
    self.littleTime = [NSNumber numberWithInt:0];
    @weakify(self)
    //注册按钮是否可用
        self.validRegisterSignal = [[RACSignal
                                     combineLatest:@[ RACObserve(self, phone),RACObserve(self, phoneCode),RACObserve(self, realPhoneCode) ]
                                     reduce:^(NSString *phone,NSString *phoneCode,NSString *realPhoneCode) {
                                         return @(phone.length == 11 && phoneCode.length>0);
                                     }]
                                    distinctUntilChanged];
    
    //验证码按钮是否可用
    self.validCodeSignal = [[RACSignal
                             combineLatest:@[RACObserve(self, phone), RACObserve(self, littleTime) ]
                             reduce:^(NSString *phone, NSNumber *littleTime) {
                                 return @(phone.length == 11 && littleTime.intValue <= 0);
                             }]
                            distinctUntilChanged];
    
    self.phoneCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        [[self.httpService sendPhoneCode:self.phone codeType:@"1" resultClass:nil] subscribeNext:^(BaseModel *model) {
            @strongify(self);
            
            if (model.code==200) {
                [self startTimer];
            }else{
                [self showRequestErrorMessage:model];
            }
            
        } error:^(NSError *error) {
            
        } completed:^{
            
        }];
        
        return [RACSignal empty];
    }];
    
    
    self.determineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [[self.httpService bindUserPhone:self.phone code:self.phoneCode resultClass:nil ]subscribeNext:^(BaseModel *model) {
            @strongify(self);
            if (model.code==200) {
                [self.viewController hiddenHUDWithString:@"绑定成功" error:NO];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"bindPhone" object:self.phone];
                
                [self.viewController.navigationController popViewControllerAnimated:YES];
                
     
                //                [self.viewController gotoBack];
            }else{
                //                [self.viewController hiddenHUDWithString:model.message error:YES];
                [self showRequestErrorMessage:model];
            }
        } error:^(NSError *error) {
            
        } completed:^{
            
        }];
       
        return [RACSignal empty];
    }];
}

- (NSTimer*)startTimer{
    if (!_codeTimer) {
        self.littleTime = [NSNumber numberWithInt:60];
        _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeAtTimedisplay) userInfo:nil repeats:YES];
    }
    return _codeTimer;
}

- (void)changeTimeAtTimedisplay{
    self.littleTime = [NSNumber numberWithInt:self.littleTime.intValue-1];
    if (self.littleTime.intValue==0) {
        self.phoneCodeText = @"发送验证码";
        [self stopTimer];
    }else{
        self.phoneCodeText = [NSString stringWithFormat:@"发送验证码(%@)",self.littleTime];
    }
}

- (void)stopTimer{
    if (_codeTimer) {
        [_codeTimer invalidate];
    }
    _codeTimer = nil;
}

- (void)dealloc{
    [self stopTimer];
}







@end
