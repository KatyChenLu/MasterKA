//
//  SequenceView.m
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "SequenceView.h"
#import "SequenceCell.h"

@interface SequenceView ()<UITableViewDataSource , UITableViewDelegate,UIGestureRecognizerDelegate>;

@end

@implementation SequenceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _sequenceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
        _sequenceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sequenceTableView.delegate = self;
        _sequenceTableView.dataSource = self;
        
        
        _sequenceTableView.estimatedRowHeight = 0;
        _sequenceTableView.estimatedSectionFooterHeight = 0;
        _sequenceTableView.estimatedSectionHeaderHeight = 0;
        
        [_sequenceTableView registerNib:[UINib nibWithNibName:@"SequenceCell" bundle:nil] forCellReuseIdentifier:@"sequence"];
        
        _sequenceTableView.tableFooterView = [UIView new];
        
        [self addSubview:_sequenceTableView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        tap.delegate = self;
        
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    SequenceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sequence" forIndexPath:indexPath];
        
    
    cell.str = self.source[indexPath.row];
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.sequenceBtn setTitle:self.source[indexPath.row] forState:UIControlStateNormal];
    
    
    self.dismiss([NSString stringWithFormat:@"%ld",indexPath.row+1]);
}


#pragma UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    
    if ([NSStringFromClass([touch.view class])isEqualToString:NSStringFromClass([self class])]) {
        
        self.sequenceBtn.selected = NO;
        _sequenceTableView = nil;
        
        [self removeFromSuperview];
        
        
        return YES;
    }
    return NO;
}

-(void)tap:(UITapGestureRecognizer *)recognizer
{
    if ([recognizer.view isKindOfClass:[self class]]) {
        
        
    }
    
    
    
}

@end
