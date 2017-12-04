//
//  InterestCollectionViewCell.h
//  MasterKA
//
//  Created by jinghao on 16/1/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestCollectionViewCell : UICollectionViewCell
@property (nonatomic,weak)IBOutlet UIImageView *interestImageView;
@property (nonatomic,weak)IBOutlet UIView *maskView;
@property (nonatomic,weak)IBOutlet UIImageView *interestSelectImageView;
@property (nonatomic)BOOL choiced;
@end
