//
//  CommentTableViewCell.m
//  HiGoMaster
//
//  Created by jinghao on 15/2/5.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//只包含评论的cell

#import "CommentTableViewCell.h"
//#import "AttributedStyleAction.h"
#import "ReplyTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#define ImageViewHeight ([UIScreen mainScreen].bounds.size.width-70-16)*78/(250.0f-16)

@interface CommentTableViewCell ()<UITableViewDataSource,UITableViewDelegate>

@end

@interface CommentTableViewCell ()

@property (nonatomic,strong)IBOutlet NSLayoutConstraint* images1LayoutViewTop;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* images1LayoutViewHeight;

@property (nonatomic,strong)IBOutlet NSLayoutConstraint* images2LayoutViewTop;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* images2LayoutViewHeight;

@property (nonatomic,strong)IBOutlet NSLayoutConstraint* images3LayoutViewTop;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* images3LayoutViewHeight;

@property (nonatomic,strong)IBOutlet UIImageView* image1View;
@property (nonatomic,strong)IBOutlet UIImageView* image2View;
@property (nonatomic,strong)IBOutlet UIImageView* image3View;
@property (nonatomic,strong)IBOutlet UIImageView* image4View;
@property (nonatomic,strong)IBOutlet UIImageView* image5View;
@property (nonatomic,strong)IBOutlet UIImageView* image6View;
@property (nonatomic,strong)IBOutlet UIImageView* image7View;
@property (nonatomic,strong)IBOutlet UIImageView* image8View;
@property (nonatomic,strong)IBOutlet UIImageView* image9View;
@property (nonatomic,strong)IBOutlet UILabel* replyLabel;

@property (nonatomic,strong)IBOutlet NSLayoutConstraint* images1ViewEqualRatio;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* images2ViewEqualRatio;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* images3ViewEqualRatio;

@property (nonatomic,strong)IBOutlet UITableView* replyTableView;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* replyTableViewHeight;

@property (nonatomic,strong)NSMutableArray* replyDataSource;
@property (nonatomic,strong)UITableViewCell* replyTableViewCell;



@end

static NSString* ReplyCellIdentifier = @"ReplyTableViewCell";

@implementation CommentTableViewCell

- (void)awakeFromNib {
    
    // Initialization code
    [self.headImageView setCornerRadius:3];
    self.headImageView.userInteractionEnabled = TRUE;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewOnClick:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [self.headImageView addGestureRecognizer:tap];
    
    [self.replyLabel addHotspotHandler];
    UIView *view_bg = [[UIView alloc]initWithFrame:self.frame];
    view_bg.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = view_bg;
    self.replyTableView.delegate = self;
    self.replyTableView.dataSource = self;
    self.replyTableView.scrollEnabled=NO;
    //消息cell注册
    UINib *cellNib = [UINib nibWithNibName:@"ReplyTableViewCell" bundle:nil];
    [self.replyTableView registerNib:cellNib forCellReuseIdentifier:ReplyCellIdentifier];
    self.replyTableView.scrollEnabled = FALSE;
    self.replyTableViewCell  = [self.replyTableView dequeueReusableCellWithIdentifier:ReplyCellIdentifier];
    [self.replyTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    self.replyTableView.estimatedRowHeight = 44.0f;
    self.replyTableView.rowHeight = UITableViewAutomaticDimension;
    [self.replyTableView clearDefaultStyle];
    self.replyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,10)];
    [self resetItemData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    NSLog(@"==========================%@",self.contentView);
//
//    for (UIView* view in [self.contentView subviews]) {
//        NSLog(@"==========================%@",view);
//    }
}

- (NSMutableArray*)replyDataSource{
    if (_replyDataSource == nil) {
        _replyDataSource = [NSMutableArray array];
    }
    return _replyDataSource;
}

- (void)resetItemData{
    self.headImageView.image = nil;
    self.nickNameView.text = nil;
    self.commentContentView.text =nil;
    self.floorView.text = nil;
    self.timeView.text = nil;
    self.replyLabel.attributedText=nil;
    self.images1LayoutViewTop.constant = 0;
    self.images1LayoutViewHeight.constant=0;
    self.images2LayoutViewTop.constant = 0;
    self.images2LayoutViewHeight.constant=0;
    self.images3LayoutViewTop.constant = 0;
    self.images3LayoutViewHeight.constant=0;

    self.image1View.image = nil;
    self.image2View.image = nil;
    self.image3View.image = nil;
    self.image4View.image = nil;
    self.image5View.image = nil;
    self.image6View.image = nil;
    self.image7View.image = nil;
    self.image8View.image = nil;
    self.image9View.image = nil;
    
    [self.image1View removeConstraint:self.images1ViewEqualRatio];
    [self.image4View removeConstraint:self.images2ViewEqualRatio];
    [self.image7View removeConstraint:self.images3ViewEqualRatio];
    self.replyTableViewHeight.constant = 0;
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    if(self.images1LayoutViewTop.constant >0){
//        self.images1LayoutViewHeight.constant=self.image1View.width;
//    }
//    if(self.images2LayoutViewTop.constant >0){
//        self.images3LayoutViewHeight.constant=self.image3View.width;
//    }
//    if(self.images3LayoutViewTop.constant >0){
//        self.images3LayoutViewHeight.constant=self.image3View.width;
//    }
//}

- (void)setItemData:(id)data{
    _itemData = data;
    [self resetItemData];
    if (data) {
        self.nickNameView.text = data[@"nikename"];
        [self.headImageView setImageWithURLString:data[@"img_top"] placeholderImage:nil];
        self.floorView.text = data[@"sort"];
        [self.commentContentView setEmojiText:data[@"content"]];
        self.timeView.text = data[@"addTime"];
        NSArray* imageList = data[@"images"];
        if (imageList && imageList.count > 0) {
            for (int i=0; i<imageList.count; i++) {
                NSString* imgUrl = imageList[i];
                if (i==0) {
                    self.images1LayoutViewTop.constant =10;
                    self.images1LayoutViewHeight.constant = ImageViewHeight;

//                    if(IS_LESS_THAN_IOS8){
//                        self.images1LayoutViewHeight.constant=self.image1View.width;
//                    }else{
//                        [self.image1View addConstraint:self.images1ViewEqualRatio];
//                    }
//                    [self.image1View addConstraint:self.images1ViewEqualRatio];

                }
                if (i==3) {
                    self.images2LayoutViewTop.constant =8;
                    self.images2LayoutViewHeight.constant = ImageViewHeight;

//                    if(IS_LESS_THAN_IOS8){
//                        self.images2LayoutViewHeight.constant=self.image4View.width;
//                    }else{
//                        [self.image4View addConstraint:self.images2ViewEqualRatio];
//                    }
//                    [self.image4View addConstraint:self.images2ViewEqualRatio];

                }
                if (i==6) {
                    self.images3LayoutViewTop.constant =8;
                    self.images3LayoutViewHeight.constant = ImageViewHeight;
//                    if(IS_LESS_THAN_IOS8){
//                        self.images3LayoutViewHeight.constant=self.image7View.width;
//                    }else{
//                        [self.image7View addConstraint:self.images3ViewEqualRatio];
//                    }
//                    [self.image7View addConstraint:self.images3ViewEqualRatio];

                }
                if (i==0) {
                    [self.image1View setImageWithURLString:imgUrl placeholderImage:[UIImage imageNamed:@"defaultImage"]];
//                    self.image1View.imageUrls = imageList;
                }else if (i==1) {
                    [self.image2View setImageWithURLString:imgUrl placeholderImage:nil];
//                    self.image2View.imageUrls = imageList;
                }else if (i==2) {
                    [self.image3View setImageWithURLString:imgUrl placeholderImage:nil];
//                    self.image3View.imageUrls = imageList;
                }
                else if (i==3) {
                    [self.image4View setImageWithURLString:imgUrl placeholderImage:nil];
//                    self.image4View.imageUrls = imageList;
                }else if (i==4) {
                    [self.image5View setImageWithURLString:imgUrl placeholderImage:nil];
//                    self.image5View.imageUrls = imageList;
                }else if (i==5) {
                    [self.image6View setImageWithURLString:imgUrl placeholderImage:nil];
//                    self.image6View.imageUrls = imageList;
                }
                else if (i==6) {
                    [self.image7View setImageWithURLString:imgUrl placeholderImage:nil];
//                    self.image7View.imageUrls = imageList;
                }else if (i==7) {
                    [self.image8View setImageWithURLString:imgUrl placeholderImage:nil];
//                    self.image8View.imageUrls = imageList;
                }else if (i==8) {
                    [self.image9View setImageWithURLString:imgUrl placeholderImage:nil];
//                    self.image9View.imageUrls = imageList;
                }
            }
        }
        [self.replyDataSource removeAllObjects];
        
        NSArray* replyList = data[@"reply"];
        [self.replyDataSource addObjectsFromArray:replyList];
        float replyHeight = 0;
        for (int i=0;i<self.replyDataSource.count;i++) {
             NSUInteger indices[2] = {0, i};
            NSIndexPath* indexPath = [[NSIndexPath alloc] initWithIndexes:indices length:2];
            replyHeight += [self tableView:self.replyTableView heightForRowAtIndexPath:indexPath];
        }
        [self.replyTableView reloadData];
        self.replyTableViewHeight.constant = replyHeight;
//        CGRect frame = self.replyTableView.frame;
        if (self.replyDataSource.count==0) {
            self.replyLayoutView.hidden = TRUE;
        }else{
            self.replyLayoutView.hidden = FALSE;
        }
    }
//    [self.contentView setNeedsUpdateConstraints];
//    [self.contentView updateConstraintsIfNeeded];
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
}

- (void)headImageViewOnClick:(id)sender{
    if (self.delegate) {
        [self.delegate commentTableViewCellHeadView:self itemData:self.itemData];
    }
}

#pragma mark -- UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replyDataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ReplyCellIdentifier];
    [cell setItemData:self.replyDataSource[indexPath.row]];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell setItemData:self.replyDataSource[indexPath.row]];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [tableView fd_heightForCellWithIdentifier:ReplyCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        ReplyTableViewCell* replyCell = (ReplyTableViewCell*)cell;
        [replyCell setItemData:self.replyDataSource[indexPath.row]];
    } ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        [self.delegate commentTableViewCell:self replyInfo:self.replyDataSource[indexPath.row]];
    }
}

@end
