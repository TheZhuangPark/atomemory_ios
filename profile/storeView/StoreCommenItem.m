//
//  StoreCommenItem.m
//  atomemory
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
/*
 6个属性
 uibutton* ) button1 一个商品按钮
 uibutton* ) button2  第二个商品按钮
 uilabel* ) namelabel1 商品名字1
 uilabel* ) namelabel2 商品名字2
 uilabel* ) pricelabel1 价格1
 uilabel* ) pricelabel2 价格2
 
 1个函数
 itemWithIcon seticon2 title1 subtitle1 title2 subtitle2 用来初始化item的，就是表项的控件集合。
 
 */

#import "StoreCommenItem.h"

@implementation StoreCommenItem



+ (instancetype)itemWithIcon:(NSString *)icon1 seticon2:(NSString *)icon2 title1:(NSString *)title subtitle1:(NSString *)subtitle title2:(NSString*)title2 subtitle2:(NSString*)subtitle2
{
    StoreCommenItem *item = [[self alloc] init];
    item.button1 = icon1;
     item.button2 = icon2;
    
    item.namelabel1 = title;
    item.namelabel2 = title2;
    
    item.pricelabel1=subtitle;
    item.pricelabel2=subtitle2;
    
    return item;
}


@end
