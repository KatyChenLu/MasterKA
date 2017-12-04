//
//  CourseV3ComentTableViewCell.m
//  HiGoMaster
//
//  Created by jinghao on 15/10/22.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "CourseV3CommentTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CourseV3CommentImagesTableViewCell.h"
#import "CourseV3CommentReplyTableViewCell.h"

@interface CourseV3CommentTableViewCell ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak)IBOutlet UIImageView* userHeadImageView;
@property (nonatomic,weak)IBOutlet UILabel* userNameView;
@property (nonatomic,weak)IBOutlet UILabel* floorView;
@property (nonatomic,weak)IBOutlet UILabel* commentView;
@property (nonatomic,weak)IBOutlet UITableView* mTableView;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint* mTableViewHeight;

@property (nonatomic,strong) NSMutableArray* imageDataSource;
@property (nonatomic,strong) NSMutableArray* replyDataSource;



@end

@implementation CourseV3CommentTableViewCell

- (void)awakeFromNib {
    [self.userHeadImageView setCornerRadius:self.userHeadImageView.width*0.5];
    self.mTableView.scrollEnabled = NO;
    //消息cell注册
    UINib *cellNib = [UINib nibWithNibName:@"CourseV3CommentImagesTableViewCell" bundle:nil];
    [self.mTableView registerNib:cellNib forCellReuseIdentifier:@"CourseV3CommentImagesTableViewCell"];
    
    cellNib = [UINib nibWithNibName:@"CourseV3CommentReplyTableViewCell" bundle:nil];
    [self.mTableView registerNib:cellNib forCellReuseIdentifier:@"CourseV3CommentReplyTableViewCell"];
    [self.mTableView clearDefaultStyle];
    if ([self.mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemData:(id)itemData{
    _itemData = itemData;
    if (itemData) {
        [self.imageDataSource removeAllObjects];
        [self.replyDataSource removeAllObjects];

        id superUserList = itemData[@"superUserList"];
        self.userNameView.text = superUserList[@"nickName"];
        [self.userHeadImageView setImageWithURLString:superUserList[@"imgTop"] placeholderImage:nil];
        self.floorView.text = itemData[@"sort"];
        [self.commentView setEmojiText:itemData[@"content"]];
        
        
        NSArray* replyList = itemData[@"replyList"];
        if (replyList && [replyList isKindOfClass:[NSArray class]]) {
            [self.replyDataSource addObjectsFromArray:replyList];
            
        }
        
        
        NSArray* imageList = itemData[@"images"];
        if (imageList && [imageList isKindOfClass:[NSArray class]]) {
            [self.imageDataSource addObjectsFromArray:imageList];
        }
        
        
        [self.mTableView reloadData];
        float replyHeight = 0;
        int row = 0;
        if(self.imageDataSource.count>0){
            row = 1;
            NSUInteger indices[2] = {0, 0};
            NSIndexPath* indexPath = [[NSIndexPath alloc] initWithIndexes:indices length:2];
            replyHeight += [self tableView:self.mTableView heightForRowAtIndexPath:indexPath];
        }

        for (int i=0;i<self.replyDataSource.count;i++,row++) {
            NSUInteger indices[2] = {0, row};
            NSIndexPath* indexPath = [[NSIndexPath alloc] initWithIndexes:indices length:2];
            replyHeight += [self tableView:self.mTableView heightForRowAtIndexPath:indexPath];
        }
        self.mTableViewHeight.constant = replyHeight;
    }
}

- (NSMutableArray*)imageDataSource{
    if (_imageDataSource==nil) {
        _imageDataSource = [NSMutableArray array];
    }
    return _imageDataSource;
}

- (NSMutableArray*)replyDataSource{
    if (_replyDataSource==nil) {
        _replyDataSource = [NSMutableArray array];
    }
    return _replyDataSource;
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.imageDataSource.count>0) {
        return self.replyDataSource.count+1;
    }else{
        return self.replyDataSource.count;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // To "clear" the footer view
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0 && self.imageDataSource.count>0) {
        return [tableView fd_heightForCellWithIdentifier:@"CourseV3CommentImagesTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            CourseV3CommentImagesTableViewCell* viewCell = cell;
            viewCell.imageUrls=self.imageDataSource;
        }];
    }else{
//        float height = [tableView fd_heightForCellWithIdentifier:@"CourseV3CommentReplyTableViewCell" cacheByIndexPath:indexPath configuration:^(id cell) {
//            CourseV3CommentReplyTableViewCell* viewCell = cell;
//            viewCell.itemData=self.replyDataSource[row];
//        }];
        float height = [tableView fd_heightForCellWithIdentifier:@"CourseV3CommentReplyTableViewCell" configuration:^(id cell) {
            NSInteger row = self.imageDataSource.count>0?(indexPath.row-1):indexPath.row;
            CourseV3CommentReplyTableViewCell* viewCell = cell;
            viewCell.itemData=self.replyDataSource[row];
        }];
        return height;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0 && self.imageDataSource.count>0) {
        CourseV3CommentImagesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CourseV3CommentImagesTableViewCell"];
        cell.imageUrls = self.imageDataSource;
        return cell;
    }else{
        NSInteger row = self.imageDataSource.count>0?(indexPath.row-1):indexPath.row;
        CourseV3CommentReplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CourseV3CommentReplyTableViewCell"];
        cell.itemData=self.replyDataSource[row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
