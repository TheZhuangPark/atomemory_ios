//
//  diary.m
//  podtext
//
//  Created by apple on 2017/7/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "diary.h"

@implementation diary

/**
 设置主键
 */
+ (NSString *)primaryKey{
    return @"date";
}

-(NSString*)returnPrimaryKey{
    return _date;
}
 
 
 




/**
 添加索引的属性
 */
+ (NSArray *)indexedProperties{
    return @[@"date"];
}
/**
 添加默认值
 */


@end
