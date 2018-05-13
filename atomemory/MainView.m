//
//  MainView.m
//  atomemory
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
/*
 五个属性
NSString *today;
YQCalendarView *clview; 日历空间
UINavigationBar *Navbar; 导航栏
UIVisualEffectView *BGeffect; 背景模糊特效
UIImageView* background; 背景
 
 -(void)setCalendar; //设置日历
 -(void)setupNavbar; //设置导航栏
 -(void)setupBG; 设置背景
 

 */



#import "MainView.h"
#import "UIImage+Extension.h"


@implementation MainView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupBGColor];
       // UIImageView* background=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        //[self addAllViews];
    }
    
    return self;
}

-(void)setupBGColor //设置背景颜色
{
    self.backgroundColor=[UIColor whiteColor];
}
-(void)setCalendar//设置日历
{
    
    //1设置日历 （自适应化,让整个日历的大小按照屏幕的尺寸来）
   // double Swidth=self.frame.size.width;
   // double Slength=self.frame.size.height;
    
    //double gapLen=Swidth/20;
   /* double gapLen=Slength/4;
    double CanlanderLen=Slength/2;
    _clview.frame=CGRectMake(0,
                            gapLen,
                            self.frame.size.width,
                            CanlanderLen);*/
    //1-2获取当天
    NSDate *date  = [NSDate date];
    NSDateFormatter *Yearformater = [NSDateFormatter new];
    Yearformater.dateFormat = @"yyyy";
    NSString *yearstr = [Yearformater stringFromDate:date];
    NSDateFormatter *Monthformater = [NSDateFormatter new];
    Monthformater.dateFormat = @"MM";
    NSString *monthstr = [Monthformater stringFromDate:date];
    NSDateFormatter *Dayformater = [NSDateFormatter new];
    Dayformater.dateFormat = @"dd";
    NSString *daystr = [Dayformater stringFromDate:date];
    _today=[NSString stringWithFormat:@"%@-%@-%@",yearstr,monthstr,daystr];
    
    [self addSubview:_clview];
    /*1-3设置选中的日期，格式 yyyy-MM-dd (数组)
     view.selectedArray = @[@"2017-01-23",
     @"2017-01-21",
     @"2017-01-20",
     @"2017-01-15",
     @"2017-01-12",
     @"2017-02-05",
     @"2017-02-26",
     @"2017-02-29",
     @"2017-03-14",
     @"2017-03-20",
     @"2017-03-23",
     ];
     */
    /*1-4单独添加选中个某一天
     [view AddToChooseOneDay:@"2017-02-10"];
     [view AddToChooseOneDay:@"2017-06-01"];
     */
    //1-5自定义显示
    /*
     //整体背景色
     view.backgroundColor   = [UIColor blueColor];
     //选中的日期的背景颜色
     view.selectedBackColor = [UIColor lightGrayColor];
     //选中的日期下方的图标
     view.selectedIcon      = [UIImage imageNamed:@""];
     //下一页按钮的图标
     view.nextBTNIcon       = [UIImage imageNamed:@""];
     //前一页按钮的图标
     view.preBTNIcon        = [UIImage imageNamed:@""];
     //上方日期标题的字体
     view.titleFont         = [UIFont systemFontOfSize:17];
     //上方日期标题的颜色
     view.titleColor        = [UIColor blackColor];
     //下方日历的每一天的字体
     view.dayFont           = [UIFont systemFontOfSize:17];
     //下方日历的每一天的字体颜色
     view.dayColor          = [UIColor redColor];
     */
    //1日历结束（如果需要接收点击后的代理）
    /*2设置输入文字框开始
     _textView=[[UITextView alloc] initWithFrame:CGRectMake(0
     ,gapLen+CanlanderLen+gapLen,
     self.view.frame.size.width,
     self.view.frame.size.height-(gapLen+CanlanderLen+gapLen))] ;
     _textView.textColor=[UIColor blackColor];
     _textView.font=[UIFont fontWithName:@"Arial" size:14.0];
     _textView.delegate=self;
     _textView.backgroundColor=[UIColor whiteColor];
     [self.view addSubview:_textView];
     //2设置输入文字框结束*/
    
    /*3设置按钮开始
     UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
     [btn setTitle:@"保存" forState:UIControlStateNormal];
     btn.frame = CGRectMake(self.view.frame.size.width-70,
     gapLen+CanlanderLen,
     50,
     30);
     [btn setTitleColor:[UIColor colorWithRed:0.208 green:0.643 blue:0.941 alpha:1.000] forState:UIControlStateNormal];
     btn.backgroundColor = [UIColor whiteColor];
     [btn addTarget:self action:@selector(savediary:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:btn];
     //3设置按钮结束*/
}
-(void)setupBG
{
   
    
    [self addSubview:_background];
 
    
}
-(void)setupNavbar//设置导航栏
{
    [_Navbar setBackgroundImage:[UIImage createImageWithColor:
                                    [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.35]] forBarMetrics:UIBarMetricsDefault];
   
  
    
   
    // 设置文字
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    att[NSForegroundColorAttributeName] = [UIColor blackColor];
    [_Navbar setTitleTextAttributes:att];
}
-(void)setupTable
{
    _mtable.scrollEnabled = YES;
    _mtable.separatorStyle = UITableViewCellSelectionStyleNone;
    _mtable.showsVerticalScrollIndicator = YES;
    _mtable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    _mtable.backgroundColor = [UIColor clearColor];//tableview 属性配置
    
    [self addSubview:_mtable];
}

@end
