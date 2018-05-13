//
//  MainView.h
//  atomemory
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "diary.h"
#import <Realm/Realm.h>
#import "YQCalendarView.h"


@interface MainView : UIView
//初始界面及其导航栏的渲染帮手

@property (nonatomic, copy)NSString *today;
@property(atomic,strong)YQCalendarView *clview;
@property(atomic,strong)UINavigationBar *Navbar;
@property (atomic, strong)UIImageView* background;
@property (nonatomic, strong)UITableView* mtable;

-(void)setCalendar; //设置日历
-(void)setupNavbar; //设置导航栏
-(void)setupTable;
-(void)setupBG;

@end
