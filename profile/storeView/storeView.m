//
//  storeView.m
//  atomemory
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
/*
 属性有1个
 (UITableView*)storeTableView 用来指向表格本身

 函数有两个
 initWithFrame 用来初始化 view
 setupStoreTableView 用来初始化添加表格
 
 */

#import "storeView.h"

@implementation storeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     self.backgroundColor=[UIColor hs_colorWithHexString:@"#EBEDEF"];
        //[self addAllViews];
    }
    return self;
}
-(void) setupStoreTableView
{
    _storeTableView.scrollEnabled = YES;
    _storeTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _storeTableView.showsVerticalScrollIndicator = YES;
    _storeTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    _storeTableView.backgroundColor = [UIColor clearColor];//tableview 属性配置
    [self addSubview:_storeTableView];
    //很简单!
}
//缺一个设置约束的函数，先不管它。
-(void) setupNavbar
{ [_Navbar setBackgroundImage:[UIImage createImageWithColor:
                               [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.6]] forBarMetrics:UIBarMetricsDefault];
    
    // 设置文字
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    att[NSForegroundColorAttributeName] = [UIColor blackColor];
    [_Navbar setTitleTextAttributes:att];
    
}



@end
