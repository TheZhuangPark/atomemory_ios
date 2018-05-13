//
//  DPersonalViewController.h
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCommenItem.h"
#import "DPushViewController.h"
#import "storeViewController.h"

@interface DPersonalViewController : UIViewController
/** rootVc */
@property (nonatomic, strong) UIViewController *rootViewController;

/** hideStatusBar */
@property (nonatomic, assign) BOOL hideStatusBar;
@end
