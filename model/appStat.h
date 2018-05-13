//
//  appStat.h
//  atomemory
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RLMObject.h"

@interface appStat : RLMObject
@property (nonatomic, copy) NSString* appstatId;
@property (nonatomic, assign) double stat;


@end
