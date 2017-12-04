//
//  DBBaseModel.h
//  MasterKA
//
//  Created by jinghao on 15/12/11.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <Realm/Realm.h>

@interface DBBaseModel : RLMObject

@end

// This protocol enables typed collections. i.e.:
// RLMArray<MasterShareModel>
RLM_ARRAY_TYPE(DBBaseModel)
