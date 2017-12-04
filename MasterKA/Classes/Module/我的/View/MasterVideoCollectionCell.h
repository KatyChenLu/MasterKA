//
//  MasterVideoCollectionCell.h
//  MasterKA
//
//  Created by hyu on 16/5/24.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface MasterVideoCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *videoImg;
@property (weak, nonatomic) IBOutlet UILabel *videoIntro;
@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;
@property (strong, nonatomic) MPMoviePlayerController *player;
-(void)showVideo:(NSDictionary *) dic;
@end
