//
//  DianzanCollectionView.h
//  MasterKA
//
//  Created by lijiachao on 16/10/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DianzanCollectionView : UICollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
@property(nonatomic,strong)NSMutableArray* dzArray;
@property(nonatomic,assign)NSInteger mineIndex;
@property(nonatomic,strong)NSString* shareId;
@property(nonatomic,strong)NSString* isLike;
-(void)getDzData:(NSArray*)imageData width:(CGFloat)width shareID:(NSString*)shareId master:(NSString*)master is_like:(NSString*)is_like;
@end
