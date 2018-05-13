//
//  appStat.m
//  atomemory
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "appStat.h"

@implementation appStat
/**
 设置主键
 */
+ (NSString *)primaryKey{
    return @"appstatId";
}

-(NSString*)returnPrimaryKey{
    return _appstatId;
}







/**
 添加索引的属性
 */
+ (NSArray *)indexedProperties{
    return @[@"appstatId"];
}
/**
 添加默认值
 */

@end
