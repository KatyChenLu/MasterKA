//
//  MyShareCell.m
//  MasterKA
//
//  Created by hyu on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyShareCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
@implementation MyShareCell
#define IMGVIEW_WIDTH (([UIScreen mainScreen].bounds.size.width-35)/3)
- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showMyShare:(NSDictionary *)dic{
    
    [_img_top setImageWithURLString:dic[@"img_top"] placeholderImage:[UIImage imageNamed:@"xiaotouxiang" ]];
    _nikename.text=dic[@"nikename"];
    _content.text=dic[@"content"];
    _seeLabel.text=[NSString stringWithFormat:@"%@人看过",dic[@"browse_count"]];
    if( ([dic[@"province"] isEqualToString:@""] && [dic[@"city"] isEqualToString:@""])){
        _addressLabel.hidden = YES;
        _addressImg.hidden = YES;
    }else{
        _addressLabel.text=[NSString stringWithFormat:@"%@  %@",dic[@"province"],dic[@"city"]];
    }
    
     NSArray *imgs = dic[@"detail"];
    NSLog(@"%lu",(unsigned long)imgs.count);
    if(imgs.count>1){
        _imgView.hidden=YES;
        _lengthToimg.priority=250;
        _lengthToImglist.priority=750;
        _imageListView.hidden=NO;
        [self setCellHeight:self imgs:imgs];
    }else if(imgs.count==1 &&![[[imgs objectAtIndex:0] objectForKey:@"img_url"]isEqual:@""]){
        _imgView.hidden=NO;
        _lengthToimg.priority=750;
        _lengthToImglist.priority=250;
        _imageListView.hidden=YES;
        _priorty0.priority=750;
        [self setImgWithUrl:[[imgs objectAtIndex:0] objectForKey:@"img_url"] imgView:_imgView];
    }else{
        _imgView.hidden=YES;
        _lengthToimg.priority=750;
        _lengthToImglist.priority=250;
        _imageListView.hidden=YES;
        _imgHeight.constant=0;
          self.priorty0.priority=750;
    }
 }
- (void) setCellHeight:(MyShareCell *)cell imgs:(NSArray*)imgs {
    cell.imgView.image = nil;
    cell.imgView.hidden = YES;
    NSLog(@"IMGVIEW_WIDTH===%f",IMGVIEW_WIDTH);
        if (imgs.count>6) {
            cell.priorty0.priority=100;
            cell.priorty1.priority=100;
            cell.priorty2.priority=100;
            cell.priorty3.priority=750;
        }else if(imgs.count>3){
            cell.priorty0.priority=100;
            cell.priorty1.priority=100;
            cell.priorty2.priority=750;
            cell.priorty3.priority=100;

        }
        else {
            cell.priorty0.priority=100;
            cell.priorty1.priority=750;
            cell.priorty2.priority=100;
            cell.priorty3.priority=100;
        }
    UIImage *placeholder = [UIImage imageNamed:@"jiazanshibaitu"];
    for (int i=0;i<[_imageListView subviews].count;i++) {
        UIImageView* imgView=(UIImageView *)[_imageListView viewWithTag:(i+10)];
        if(i < imgs.count){
            imgView.hidden=false;
            [imgView setImageWithURLString:[[imgs objectAtIndex:i] objectForKey:@"img_url"] placeholderImage:placeholder];
        }else{
            imgView.hidden=YES;
        }
        
    }
//    if(imgs && imgs.count>0){
//        int i = 1;
//        for(NSDictionary *img in imgs){
//            i ++;
//            NSString *imgUrl = img[@"img_url"];
//            switch (i) {
//                case 1:
//                    [cell.img1 setImageWithURLString:imgUrl placeholderImage:placeholder];
//                    break;
//                case 2:
//                    [cell.img2 setImageWithURLString:imgUrl placeholderImage:placeholder];
//                    break;
//                case 3:
//                    [cell.img3 setImageWithURLString:imgUrl placeholderImage:placeholder];
//                    break;
//                case 4:
//                    [cell.img4 setImageWithURLString:imgUrl placeholderImage:placeholder];
//                    break;
//                case 5:
//                    [cell.img5 setImageWithURLString:imgUrl placeholderImage:placeholder];
//                    break;
//                case 6:
//                    [cell.img6 setImageWithURLString:imgUrl placeholderImage:placeholder];
//                    break;
//                case 7:
//                    [cell.img7 setImageWithURLString:imgUrl placeholderImage:placeholder];
//                    break;
//                case 8:
//                    [cell.img8 setImageWithURLString:imgUrl placeholderImage:placeholder];
//                    break;
//                case 9:
//          
//                    [cell.img9 setImageWithURLString:imgUrl placeholderImage:placeholder];
//                    break;
//                default:
//                    break;
//            }
//            
//            
//        }
//    }

}
-(void)setImgWithUrl:(NSString*)url imgView:(UIImageView*)imgView{
   UIImage *placeholder = [UIImage imageNamed:@"jiazanshibaitu"];
    url = [url masterFullImageUrl];
        [imgView sd_setImageWithURL:[NSURL URLWithString:url]  placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat imgHeight = imgView.height;
        if(height > 0 && width > 0){
            CGFloat newWidth =imgHeight *(width/height);
            _imgWidth.constant=newWidth;
        }
    
    }];

}

@end
