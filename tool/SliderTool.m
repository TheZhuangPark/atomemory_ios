//
//  SliderTool.m
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SliderTool.h"

static UIWindow *window_;
@implementation SliderTool


/**
 * 根据底部控制器展示
 */
+ (void)showWithRootViewController:(UIViewController *)rootViewController {
    window_ = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window_.backgroundColor = [UIColor clearColor];
    window_.hidden = NO;
    
    DAnimateViewController *vc = [[DAnimateViewController alloc] init];
    vc.view.backgroundColor = [UIColor clearColor];
    vc.rootViewController = rootViewController;

   
    DNavigationController *nav = [[DNavigationController alloc] initWithRootViewController:vc];
    // JYJBaseNavigationController *nav = [[JYJBaseNavigationController alloc]init];
    nav.view.backgroundColor = [UIColor clearColor];
    window_.rootViewController = nav;
    [window_ addSubview:nav.view];
}

/**
 * 隐藏
 */
+ (void)hide {
    window_.hidden = YES;
    window_.rootViewController = nil;
    window_ = nil;
}



@end
