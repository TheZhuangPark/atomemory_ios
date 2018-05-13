//
//  ViewController.h
//  podtext
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "diary.h"
#import "picture.h"
#import "appStat.h"
#import <Realm/Realm.h>
#import "WritingViewController.h"
#import "YQCalendarView.h"
#import "JDLAlertView.h"
#import "SliderTool.h"
#import "MainView.h"
#import "UIImage+Extension.h"
#import "NSArray+HSSafeAccess.h"
#import "WritingLayoutViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
//控制初始界面

@property(atomic,strong)YQCalendarView *cview;
@property (nonatomic, copy)UIImageView* BG;

@property (nonatomic, copy)NSString *today;
@property (nonatomic, copy)MainView *mv;
@property (nonatomic, copy)UITableView* mainTable;
@property (nonatomic, strong)NSMutableArray* storeData;


@end

