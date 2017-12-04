//
//  CourseProgressCell.m
//  MasterKA
//
//  Created by 余伟 on 16/12/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CourseProgressCell.h"
#import "ProgressView.h"
#import "CourseProgressHeadView.h"

@implementation CourseProgressCell
{
    CourseProgressHeadView * _headView;
    ProgressView * _next;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
       
            
            _headView = [CourseProgressHeadView head];
            

            
            [self.contentView addSubview:_headView];
            
            [self layout];
        
        
    }
    return self;
}

-(void)layout{
    
    @weakify(self)
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@40);
    }];
    
}


-(void)setProgress:(NSArray *)progress
{
    _progress = progress;
    
    
    
    for (int i = 0; i<progress.count; i++) {
        
        ProgressView * progressView = [ProgressView progress];
        
        progressView.dic = progress[i];
        
        [self.contentView addSubview:progressView];
        
        
        if (i == 0) {
            @weakify(self)
            [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self)
                make.left.equalTo(self.contentView);
                make.top.equalTo(_headView.mas_bottom);
                make.right.equalTo(self.contentView);
                make.height.mas_equalTo(progressView.height);
                
                if (progress.count == 1) {

                    make.bottom.equalTo(self.contentView);
                }
                
            }];
            
            _next = progressView;
        }else if (i >0)
        {
            @weakify(self)
            [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self)
                make.left.equalTo(self.contentView);
                make.top.equalTo(_next.mas_bottom);
                make.right.equalTo(self.contentView);
                make.height.mas_equalTo(progressView.height);
            }];
            _next = progressView;
            
            if (i == self.progress.count-1) {
                
                @weakify(self)
                [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                    @strongify(self)
                    make.left.equalTo(self.contentView);
                    make.top.equalTo(_next.mas_bottom);
                    make.right.equalTo(self.contentView);
                    make.height.mas_equalTo(progressView.height);
                    make.bottom.equalTo(self.contentView);
                }];
                
            }
        }
        
        
      
        
        
    }
    
}





@end
