//
//  MasterReactiveView.h
//  MasterKA
//
//  Created by jinghao on 16/3/1.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MasterReactiveView <NSObject>
- (void)bindViewModel:(id)viewModel;
@end
