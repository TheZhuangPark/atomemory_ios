//
//  SliderTool.h
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "DAnimateViewController.h"
#import "DNavigationController.h"

@interface SliderTool : NSObject
// 侧滑界面开启工具

+ (void)showWithRootViewController:(UIViewController *)rootViewController;
+ (void)hide;

@end
