//
//  DPersonalViewController.m
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DPersonalViewController.h"
#import "personalizationViewController.h"

@interface DPersonalViewController ()
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** headerIcon */
@property (nonatomic, weak) UIImageView *headerIcon;
/** data */
@property (nonatomic, strong) NSArray *data;
@end

@implementation DPersonalViewController

- (NSArray *)data {
    if (!_data) {
        self.data = [NSArray array];
    }
    return _data;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];//左边拉出来的就是一个表格
    [self setupData];
}


- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] init];//tableview 初始化
    
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor whiteColor];//tableview 属性配置
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:247 / 255.0 blue:250 / 255.0 alpha:1.0];
    headerView.frame = CGRectMake(0, 0, 0, 150);//tableview 的头部配置
    self.tableView.tableHeaderView = headerView;
    
    // 头像图片
    UIImageView *headerIcon = [[UIImageView alloc] init];
    headerIcon.image = [UIImage imageNamed:@"head.png"];//头像设置
    headerIcon.frame = CGRectMake(0, 39, 72, 72);
    headerIcon.layer.cornerRadius = 36;
    headerIcon.clipsToBounds = YES;
    [headerView addSubview:headerIcon]; //tableview 头部再配置
    
    self.headerIcon = headerIcon;
    
}

- (void)setupData {//设置tableView数据
    DCommenItem *personalization = [DCommenItem itemWithIcon:@"skin.png" title:@"定制化皮肤" subtitle:@"" destVcClass:[personalizationViewController class]];
    
    DCommenItem *store = [DCommenItem itemWithIcon:@"store.png" title:@"商店" subtitle:@"" destVcClass:[storeViewController class]];
    
  //  DCommenItem *myTrip = [DCommenItem itemWithIcon:@"menu_trips" title:@"我的行程" subtitle:nil destVcClass:[DPushViewController class]];
    
//    DCommenItem *myFriend = [DCommenItem itemWithIcon:@"menu_invite" title:@"邀请好友" subtitle:nil destVcClass:[DPushViewController class]];
    
//    DCommenItem *mySticker = [DCommenItem itemWithIcon:@"menu_sticker" title:@"我的贴纸" subtitle:nil destVcClass:[DPushViewController class]];
//    self.data = @[personalization, myCoupon, myTrip, myFriend, mySticker];
     self.data = @[personalization, store];
}
//--------------------------tableView 的协议----------------------------

#pragma mark - TableView DataSource

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}//将模型数据和表格参数融在一起

//生成定制化tableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    ProfileCellTableViewCell *cell = [ProfileCellTableViewCell cellWithTableView:tableView];//定制化表格项
    cell.item = self.data[indexPath.row];
    return cell;
}

//选中某行后的触发事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置选中表格项后会发生的事情。会发生转换界面的事情呗。
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DCommenItem *item = self.data[indexPath.row];
    if (item.destVcClass == nil) return;
    
    DPushViewController *vc = [[item.destVcClass alloc] init];
    vc.title = item.title;
    vc.animateViewController = (DAnimateViewController *)self.parentViewController;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    self.headerIcon.frame = CGRectMake(self.tableView.frame.size.width / 2 - 36, 39, 72, 72);
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
