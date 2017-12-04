/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXFaceView.h"

@interface DXFaceView ()<UIScrollViewDelegate>
{
    FacialView *_facialView;
    UIPageControl *pageControl;
}
@property (nonatomic,strong)UIScrollView* faceScrollView;
@end

@implementation DXFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray* facesArray  = [FaceUtil getFaceArray];
        int pageCount = FaceMaxCol*FaceMaxRow;
        int facePage = (int)facesArray.count/pageCount;
        if (facesArray.count/pageCount!=0) {
            facePage++;
        }
        self.faceScrollView.frame =CGRectMake(0, 0, frame.size.width, frame.size.height-55);
        self.faceScrollView.contentSize = CGSizeMake(self.faceScrollView.frame.size.width*facePage, self.faceScrollView.frame.size.height) ;
        self.faceScrollView.delegate = self;
        self.faceScrollView.showsHorizontalScrollIndicator = FALSE;
        self.faceScrollView.showsVerticalScrollIndicator = FALSE;
        self.faceScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.faceScrollView];
        
        pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        pageControl.numberOfPages = facePage;
        pageControl.frame = CGRectMake(0, frame.size.height-45-30, frame.size.width, 30);
        pageControl.backgroundColor = [UIColor clearColor];
        [self addSubview:pageControl];

        CGSize faceSize = CGSizeMake(40, 40);
       
        for (int i=0; i<facePage; i++) {
            _facialView = [[FacialView alloc] initWithFrame: CGRectMake(i*self.faceScrollView.frame.size.width+5, 10, self.faceScrollView.frame.size.width-10, self.faceScrollView.frame.size.height-20)];
            if (facesArray.count>(i+1)*pageCount) {
                _facialView.faces = [facesArray subarrayWithRange:NSMakeRange(i*pageCount, pageCount)];
            }else{
                _facialView.faces = [facesArray subarrayWithRange:NSMakeRange(i*pageCount, facesArray.count-i*pageCount)];
            }
            [_facialView loadFacialView:i size:faceSize];
            _facialView.delegate = self;
            [self.faceScrollView addSubview:_facialView];
        }
//        CGFloat itemWidth = _facialView.frame.size.width / _facialView.maxCol;
//        CGFloat itemHeight = _facialView.frame.size.height / _facialView.maxRow;
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundColor:[UIColor clearColor]];
        [deleteButton setFrame:CGRectMake(frame.size.width-26-15, frame.size.height-28-10, 26, 22)];
        [deleteButton setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
        deleteButton.tag = 10000;
        [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendButton setFrame:CGRectMake(deleteButton.frame.origin.x-71-10, frame.size.height-35-10, 71, 35)];
        sendButton.layer.masksToBounds = YES;
        sendButton.layer.cornerRadius = 4;

//        [sendButton setFrame:CGRectMake((_facialView.maxCol - 2) * itemWidth - 10, (_facialView.maxRow - 1) * itemHeight + 5, itemWidth + 10, itemHeight - 10)];
        [sendButton addTarget:self action:@selector(sendFace) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:227/255.0f blue:38/255.0f alpha:1]];
        [self addSubview:sendButton];
        
    }
    return self;
}

#pragma mark - FacialViewDelegate

-(void)selectedFacialView:(NSString*)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:NO];
    }
}

-(void)deleteSelected:(NSString *)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFace
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

- (UIScrollView*)faceScrollView{
    if (_faceScrollView==nil) {
        _faceScrollView = [[UIScrollView alloc] init];
        _faceScrollView.pagingEnabled = TRUE;
        _faceScrollView.showsHorizontalScrollIndicator = FALSE;
        _faceScrollView.showsVerticalScrollIndicator =FALSE;
        //        _faceScrollView.delegate = self;
    }
    return  _faceScrollView;
}
-(void)selected:(UIButton*)bt
{
    [self deleteSelected:nil];
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    CGFloat pageWidth = scrollView.frame.size.width;
    //    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //    self.pageControl.currentPage = page;
    pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    
}

#pragma mark - public

- (BOOL)stringIsFace:(NSString *)string
{
    NSDictionary* faceDict = [FaceUtil getFaceDictionary];
    NSUInteger index = [faceDict.allValues indexOfObject:string];
    if (index != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
