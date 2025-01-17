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

#import <UIKit/UIKit.h>
#import "FaceUtil.h"
#define FaceMaxRow 3
#define FaceMaxCol 7


@protocol FacialViewDelegate

@optional
-(void)selectedFacialView:(NSString*)str;
-(void)deleteSelected:(NSString *)str;
-(void)sendFace;

@end


@interface FacialView : UIView
{
	NSArray *_faces;
}
@property(nonatomic) int maxRow;
@property(nonatomic)int maxCol;
@property(nonatomic) id<FacialViewDelegate> delegate;

@property(strong, nonatomic) NSArray *faces;

-(void)loadFacialView:(int)page size:(CGSize)size;

@end
