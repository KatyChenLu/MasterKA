//
//  MasterVideoCollectionCell.m
//  MasterKA
//
//  Created by hyu on 16/5/24.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterVideoCollectionCell.h"

@implementation MasterVideoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)showVideo:(NSDictionary *) dic{
    NSString *urlStr = [NSString stringWithFormat:@"http://kaifa.gomaster.cn/attms/%@",dic[@"url"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    if (self.player == nil) {
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
        self.player.controlStyle= MPMovieControlStyleDefault;
        [self.player.view setFrame:CGRectMake(self.videoImgView.origin.x, self.videoImgView.origin.y, ScreenWidth-26, self.videoImgView.height)];  // player的尺寸
//        [self.videoImg addSubview: self.player.view];
        [self addNotifications];
    }else {
        [self.player setContentURL:url];
    }
    
    NSMutableArray * allThumbnails = [NSMutableArray  arrayWithObjects:[NSNumber numberWithDouble:1.0],nil];
    [self.player requestThumbnailImagesAtTimes:allThumbnails timeOption:MPMovieTimeOptionExact];
//    [self.player prepareToPlay];
//    self.player.shouldAutoplay=YES;
    self.videoIntro.text=dic[@"desc"];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
    self.videoImgView.userInteractionEnabled=YES;
    [self.videoImgView addGestureRecognizer:singleTap];
}
-(void)handleThumbnailImageRequestFinishNotification:(NSNotification*)notification
{
    NSDictionary *userinfo = [notification userInfo];
    NSError* value = [userinfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    if (value != nil)
    {
        NSLog(@"Error creating video thumbnail image. Details: %@", [value debugDescription]);
    }
    else
    {
        [self.videoImgView setImage:[userinfo valueForKey:MPMoviePlayerThumbnailImageKey]];
    }
}



- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThumbnailImageRequestFinishNotification:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];


}

- (void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playEnterFullscreen:(id)sender
{
    
//    [self.player setFullscreen:NO animated:NO];
//    [self.player setControlStyle:MPMovieControlStyleEmbedded];
    NSLog(@"playEnterFullscreen %@",[self.superViewController.navigationController.navigationBar subviews]);
}

- (void)hiddenFullButtonView:(UIView*)view
{
    for (UIView *subView in [view subviews]) {
        [self hiddenFullButtonView:subView];
        if([subView isKindOfClass:[UIButton class]]){
            if (subView.frame.origin.x>self.player.view.width/2) {
                subView.hidden = YES;
            }
        }
    }
}

- (void)playExitFullscreen:(id)sender
{
    NSLog(@"playExitFullscreen %@",[self.superViewController.navigationController.navigationBar subviews]);
}

-(void)playVideo{
    [self.videoImg addSubview: self.player.view];
//    [self.player setFullscreen:YES animated:YES];
    [self.player prepareToPlay];
    [self.player play];
    self.videoImgView.hidden=YES;
    [self hiddenFullButtonView:self.player.view];
}

- (void)dealloc
{
    [self removeNotifications];
}


@end
