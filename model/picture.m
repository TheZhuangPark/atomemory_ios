//
//  picture.m
//  atomemory
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "picture.h"

@implementation picture


/**
 设置主键
 */
+ (NSString *)primaryKey{
    return @"PicId";
}

-(NSString*)returnPrimaryKey{
    return _PicId;
}







/**
 添加索引的属性
 */
+ (NSArray *)indexedProperties{
    return @[@"PicId"];
}
/**
 添加默认值
 */



@end
