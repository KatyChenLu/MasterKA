//
//  FSDPickerItemProtocol.h
//  HiGoMaster
//
//  Created by jinghao on 15/6/14.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#ifndef HiGoMaster_FSDPickerItemProtocol_h
#define HiGoMaster_FSDPickerItemProtocol_h

@class UIImage;

/**
 *  Object added to the FSDDropdownPicker must conform to this protocol
 */
@protocol FSDPickerItemProtocol <NSObject>
- (NSString *)name;
- (UIImage *)image;
- (BOOL)selected;
- (id)itemData;
@end

#endif
