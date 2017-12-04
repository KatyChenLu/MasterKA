//
//  CardDetailViewController.h
//  MasterKA
//
//  Created by hyu on 16/5/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

@interface CardDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *pic_url;
@property (weak, nonatomic) IBOutlet UITextView *intro;
@property (nonatomic,strong)NSDictionary *cardInfo;
@end
