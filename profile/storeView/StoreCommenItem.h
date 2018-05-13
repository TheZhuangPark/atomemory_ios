//
//  StoreCommenItem.h
//  atomemory
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreCommenItem : NSObject

/**
 *  按钮1
 */
@property (nonatomic, copy) NSString *button1;
/**
 *  按钮2
 */
@property (nonatomic, copy) NSString *button2;
/**
 *
 */
@property (nonatomic, copy) NSString *namelabel1;
@property (nonatomic, copy) NSString *namelabel2;
@property (nonatomic, copy) NSString *pricelabel1;
@property (nonatomic, copy) NSString *pricelabel2;
+ (instancetype)itemWithIcon:(NSString *)icon1 seticon2:(NSString *)icon2 title1:(NSString *)title subtitle1:(NSString *)subtitle title2:(NSString*)title2 subtitle2:(NSString*)subtitle2;



@end
