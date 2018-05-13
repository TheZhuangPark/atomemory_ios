//
//  DAnimateViewController.h
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
//控制测滑界面

@interface DAnimateViewController : UIViewController
/** rootVc */
@property (nonatomic, strong) UIViewController *rootViewController;

/** hideStatusBar */
@property (nonatomic, assign) BOOL hideStatusBar;
@end
