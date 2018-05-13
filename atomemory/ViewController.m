//
//  ViewController.m
//  podtext
//
//  Created by apple on 2017/6/13.
//  Copyright © 2017年 apple. All rights reserved.
/*
 有5个属性
YQCalendarView *cview; 日历本身
UIImageView* BG; 背景图片
UIVisualEffectView* BGE; 背景模糊镜
NSString *today; 今天
MainView *mv; viewController所托付的渲染任务
 UITableView* table;
 (CGRect) navRect

 有5个函数
1 viewDidLoad 初始化函数
2 YQCalendarViewTouchedOneDay 日历点触函数
3 setupNav 设置导航栏函数
4 profileCenter 弹出个人中心的函数
5 viewWillAppear 画面即将显示函数
 */

#import "ViewController.h"
#import "ObjectFunction.h"


@interface ViewController ()<YQCalendarViewDelegate>
//#define SCREENW [UIScreen mainScreen].bounds.size.width
//#define SCREENH [UIScreen mainScreen].bounds.size.height

@end

@implementation ViewController

- (void)viewDidLoad {

    // Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];

   
   
//---------------------------业务逻辑------------------------------------
    
    //1.日历的点击事件代理-日记业务逻辑
    //double gapLen=SCREENH/4;
    double gapLen=0;
    double CanlanderLen=SCREENH/2;
    _cview=[[YQCalendarView alloc]initWithFrame:CGRectMake(SCREENW/20,gapLen+SCREENW/20,SCREENW-SCREENW/10,
                                                                        CanlanderLen-SCREENW/10)];
    _cview.delegate=self;
    
    //初始化背景图片
    _BG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    //2.导航栏左侧按钮及其点击事件的页面跳转逻辑
    [self setupNav];
    
    //3.初始化app-stat数据。存入realm数据库
    RLMResults<appStat *>* temp2=[appStat objectsWhere:@"appstatId = %@",@"systembgAlpha"];
    if (temp2.count == 0) {
        appStat* systembgalpha=[[appStat alloc]init];
        systembgalpha.appstatId=@"systembgAlpha";
        systembgalpha.stat=0.0;
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [[RLMRealm defaultRealm] addObject:systembgalpha];
        }];
    } else {
    }
    
    RLMResults<appStat *>* temp3=[appStat objectsWhere:@"appstatId = %@",@"_systembgAlpha"];
    if (temp3.count == 0) {
        appStat* _systembgalpha=[[appStat alloc]init];
        _systembgalpha.appstatId=@"_systembgAlpha";
        _systembgalpha.stat=1.0;
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [[RLMRealm defaultRealm] addObject:_systembgalpha];
        }];
    } else {
    }
    
    //表格data
    //_storeData=[NSMutableArray alloc];
     [self setupData];
    
    
    
//--------------------------UI逻辑-----------------------------------
  
    
    //view的工作交给mainmv-把ui逻辑交给mainview
    _mv=[[MainView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    
    _mv.background=_BG;

    [_mv setupBG];
    
    _mv.clview=_cview;
    //[_mv setCalendar];//1.让mainmv渲染calendar
    
    _mv.Navbar=self.navigationController.navigationBar;
    [_mv setupNavbar]; //2.让mianmv渲染导航栏
    
    //初始化表格
    // _navRect = self.navigationController.navigationBar.frame;
    _mainTable=[[UITableView alloc]initWithFrame:CGRectMake(0, /*_navRect.size.height*/0, SCREENW, SCREENH) style:UITableViewStyleGrouped];
    //   _storeTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _mainTable.delegate = self;//这里会出循环引用！！！
    _mainTable.dataSource = self;
    _mainTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _mainTable.separatorColor = [UIColor clearColor];
 //   _mainTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    _mv.mtable=_mainTable;
    _mainTable.tableHeaderView=[self setupHead];
    [_mv setupTable];
    
    //---------------ui 逻辑--------------------------

    self.view=_mv;
}


//------------------------业务逻辑具体实现----------------------------------

//日历点击事件---使用String格式，是为了避免因时区可能会导致的不必要的麻烦，点击跳页！
-(void)YQCalendarViewTouchedOneDay:(NSString *)dateString{
    
    //-----写过的日记------------
    NSLog(@"点击了：%@",dateString);
    WritingViewController* second= [[WritingViewController alloc]init];
    second.today= [dateString copy];
    second.view.backgroundColor=[UIColor whiteColor];
    second.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    WritingLayoutViewController* wlayoutVC=[[WritingLayoutViewController alloc]init];
    wlayoutVC.today=[dateString copy];
    wlayoutVC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController: wlayoutVC animated:YES completion:nil];
   // [self presentViewController: second animated:YES completion:nil];
    
}

//添加个人中心按钮 绑定跳转事件
- (void)setupNav {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    //导航栏中的空白部分？
    UIButton *profileButton = [[UIButton alloc] init];
    // 设置按钮的背景图片
    UIImage* buttonimage=[UIImage imageNamed:@"mine.png"];
    [profileButton setImage:[buttonimage TransformtoSize:CGSizeMake(SCREENW/13, SCREENW/13)] forState:UIControlStateNormal];
                         
   
    // 设置按钮的尺寸为背景图片的尺寸
    //profileButton.frame = CGRectMake(0, 0, SCREENW/20, SCREENW/20);
    //监听按钮的点击
    [profileButton addTarget:self action:@selector(profileCenter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profile = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,profile];
   
    
}

//个人中心的跳转事件
- (void)profileCenter {
   
 //    [JDLAlertView showAlertViewWithMessage:@"hey" backgroundStyle:JDLBackgroundStyleNone duration:3 viewController:self];
    
    [SliderTool showWithRootViewController:self];
}

//取日记数据逻辑 ----可以考虑多线程！
- (void)viewWillAppear:(BOOL)animated {
    //取已写日记
 /*   RLMResults<diary *> *temp = [diary allObjects];
    for(int j=0;j<temp.count;j++)
    {
        
        NSString *_chosenday=[ temp[j].diarydate copy];
        
        [_cview AddToChooseOneDay:_chosenday];
    }*/
    RLMResults<appStat *> *temp = [appStat objectsWhere:@"appstatId BEGINSWITH %@",@"T"];
    NSLog(@"%@",temp);
    for(int j=0;j<temp.count;j++)
    {
        
        NSString *_chosenday=[ temp[j].appstatId copy];
        NSString *subChosenday=[_chosenday substringFromIndex:1];
        NSLog(@"chosenday = %@",_chosenday);
        NSLog(@"subChosenday = %@",subChosenday);
        [_cview AddToChooseOneDay:subChosenday];
    }
    
    
    //取背景图像
    RLMResults<picture *>* temp2=[picture objectsWhere:@"PicId = %@",@"systembg"];
  //  NSLog(@"%@",temp2);
    if (temp2.count == 0) {
       
    } else {
        
        picture* p1=[[picture objectsWhere:@"PicId=%@",@"systembg"]firstObject];
        UIImage *_decodedImage = [UIImage imageWithData:p1.content];
        _BG.image=_decodedImage;
    }
    //取背景模糊度 和清晰度
    RLMResults<appStat *>* temp3=[appStat objectsWhere:@"appstatId = %@",@"systembgAlpha"];
    if (temp3.count == 0) {
        
    } else {
        
        appStat* appstat1=[[appStat objectsWhere:@"appstatId=%@",@"systembgAlpha"]firstObject];
        if(_BG.image!=nil)
        {
            [_BG setImage:[ObjectFunction blurryImage: _BG.image withBlurLevel:appstat1.stat]];
        }
        //  _visualEfView.alpha=appstat1.stat;
        //  _BG_visualEfView.alpha=appstat1.stat;
    }
    
    RLMResults<appStat *>* temp4=[appStat objectsWhere:@"appstatId = %@",@"_systembgAlpha"];
    if (temp4.count == 0) {
        
    } else {
        
        appStat* appstat2=[[appStat objectsWhere:@"appstatId=%@",@"_systembgAlpha"]firstObject];
        if(_BG.image!=nil)
        {
            self.view.backgroundColor=[UIColor blackColor];
            _BG.alpha=appstat2.stat;
        }
    }
    
    //刷新日历控件的今日 以及其有记录的日期
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
    
     [_cview AddToChooseOneDay:_today];
     self.navigationItem.title=_today;
}

/*
 表格协议
 */

/*
 设置分区，表行，表项，表高, 表头轮播插件。
 */
- (NSMutableArray *)storeData {
    if (!_storeData) {
        self.storeData = [NSMutableArray array];
    }
    return _storeData;
}
-(void)setupData
{
    
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects: nil];
    NSMutableArray *section1 = [NSMutableArray arrayWithObjects: _cview, nil];
    
    [self.storeData addObject:section0];
    [self.storeData addObject:section1];
    [_mainTable reloadData];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     NSLog(@"%d",self.storeData.count);
    return self.storeData.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *rows = [self.storeData hs_objectWithIndex:section];
    NSAssert([rows isKindOfClass:[NSMutableArray class]], @"此对象必须为一个可变数组,请检查数据源组装方式是否正确!");
    NSLog(@"%d",rows.count);
    return rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"MainTableViewCell";
   UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
   if (cell  == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray *sections = [self.storeData hs_objectWithIndex:indexPath.section];
    NSAssert([sections isKindOfClass:[NSMutableArray class]], @"此对象必须为一个可变数组,请检查数据源组装方式是否正确!");
    if([sections[indexPath.row] isKindOfClass:[YQCalendarView class]])
    {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        YQCalendarView* temp= [sections objectAtIndex:indexPath.row];
        [cell addSubview:temp ];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSMutableArray *sections = [self.hs_dataArry hs_objectWithIndex:indexPath.section];
     NSAssert([sections isKindOfClass:[NSMutableArray class]], @"此对象必须为一个可变数组,请检查数据源组装方式是否正确!");
     HSBaseCellModel *cellModel = (HSBaseCellModel *)[sections hs_objectWithIndex:indexPath.row];
     Class class =  NSClassFromString(cellModel.cellClass);
     return [class getCellHeight:cellModel];*/
    return SCREENH/2;
}

/*
 控制表分区的间隔
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //如果是最后一个section
    if(section == self.storeData.count - 1){
        return 0;
    }
    return 5;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //如果是最后一个section
    if(section == self.storeData.count - 1){
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

-(UIView *)setupHead{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (SCREENH/6))] ;
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
