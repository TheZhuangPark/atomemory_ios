//
//  storeViewController.m
//  atomemory
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
/*
 属性有5个
 (UIView*型)_sv 用来负责渲染
 (NSArray*) 的storeData 用来存表项
 (UITableView*) _storeTable 表格本体
 (double) TableviewH 用来计算表格长度的
 (CGRect) navRect 用来获取导航栏长度的 以便计算其他空间的y值
 
 怎么改？ 首先storeData改成nsmutableArray类的。
 
 函数有5个
  viewDidload 用来初始化_sv, 表格，启动setupData来装好表项
  setupAD 用来初始化轮播插件的
  setupData 用来初始化表项
 
 tableView: numberOfRowsInSection: 用来设置每个表section的行数
 tableView: cellForRowIndexPath 用来初始化设置每个表项的
numberOfSectionsInTableView 决定多少个分区
 tableView: numberOfRowsInSection: 用来设置每个表section的行数
 tableView: cellForRowIndexPath 用来初始化设置每个表项的
 setupAD 设置表头
 tableView: didSelectRowAtIndexPath: 选中行触发函数
 tableView: heightForRowAtIndexPath: 每行高度限制
 tableView: heightForFooterInSection: 设置分区间隔高度
 tableView: viewForFooterInSection: 设置分区间隔view
 初始化函数怎么改？不用怎么改其实。弄好一个自定义表格真的不简单。
 控制表分区的间隔
 */


//   一个viewDidLoad初始化函数

#import "storeViewController.h"

@interface storeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)double TableviewH;
@property (nonatomic,assign)CGRect navRect;

@end

@implementation storeViewController

/*
 初始化
 */
- (void)viewDidLoad {
    [super viewDidLoad];
//--------------ui 逻辑 让sv显示view-------------------------
    _sv=[[storeView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
//--------------业务逻辑------------------------
    //设置好tableView的数据来源
    
    [self setupData];
    //初始化tableView设置代理 并且交给storeTable
     _navRect = self.navigationController.navigationBar.frame;
    _TableviewH=0;
    _storeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, /*_navRect.size.height*/0, SCREENW, SCREENH) style:UITableViewStyleGrouped];
 //   _storeTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _storeTable.delegate = self;//这里会出循环引用！！！
    _storeTable.dataSource = self;
    _sv.storeTableView=_storeTable;
    _sv.Navbar=self.navigationController.navigationBar;
//---------------ui 逻辑--------------------------
    _storeTable.tableHeaderView=[self setupAD];
    
    //让sv渲染 tableView
    [_sv setupStoreTableView];
    [_sv setupNavbar];
    self.view=_sv;
}
- (NSMutableArray *)storeData {
    if (!_storeData) {
        self.storeData = [NSMutableArray array];
    }
    return _storeData;
}
-(void)setupData{
    StoreCommenItem *First=[StoreCommenItem itemWithIcon:@"Tea.png" seticon2:@"Cake.png" title1:@"请开发者喝茶" subtitle1:@"￥6" title2:@"请开发者吃蛋糕" subtitle2:@"￥12"];
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects: nil];
    NSMutableArray *section1 = [NSMutableArray arrayWithObjects: First,nil];
   
    [self.storeData addObject:section0];
    [self.storeData addObject:section1];
    [_storeTable reloadData];
}




/*
 设置分区，表行，表项，表高, 表头轮播插件。
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.storeData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *rows = [self.storeData hs_objectWithIndex:section];
    NSAssert([rows isKindOfClass:[NSMutableArray class]], @"此对象必须为一个可变数组,请检查数据源组装方式是否正确!");
    return rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreTableViewCell* cell=[StoreTableViewCell cellWithTableView:tableView];
    
    NSMutableArray *sections = [self.storeData hs_objectWithIndex:indexPath.section];
     NSAssert([sections isKindOfClass:[NSMutableArray class]], @"此对象必须为一个可变数组,请检查数据源组装方式是否正确!");
    cell.item=sections[indexPath.row];
    cell.rootViewController=self;
    return cell;
}

-(UIView *)setupAD{
    NSArray *images = @[[UIImage imageNamed:@"ad01.png"],
                        [UIImage imageNamed:@"ad01.png"],
                        [UIImage imageNamed:@"ad01.png"],
                        ];
    // 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 60, SCREENW, 180) imagesGroup:images];
    cycleScrollView.delegate = self;
    //cycleScrollView.autoScrollTimeInterval = 2.0;
    //[self.view addSubview:cycleScrollView];
    return cycleScrollView;
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
    return picH+2*labelH+gap*4;
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
