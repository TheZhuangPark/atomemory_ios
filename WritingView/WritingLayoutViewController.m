//
//  WritingLayoutViewController.m
//  atomemory
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
/*
 目前需要做的是，设置好空白table.
 11个属性
 @property(nonatomic, strong)UIButton* bn; 返回按钮
 @property(nonatomic, strong)UIButton* pbn; 添加图片按钮
 @property(nonatomic, strong)UIButton* mbn; 删除图片按钮
 @property (nonatomic, strong) WJTextView *textView; 文字框
 @property (nonatomic, strong)NSMutableArray* storeData; 表格数据源
 @property (nonatomic, strong)UITableView* storeTable; 表格
 @property (nonatomic,strong)UICollectionView *colletionView; 图片瀑布
 @property (nonatomic,copy)NSMutableArray* New; 图片瀑布数据源 - 添加
 @property (nonatomic,copy)NSMutableArray *imgArray; 图片瀑布数据源 - 初始
 @property (nonatomic, assign)float ideal_height;//记录高度
 @property (nonatomic,copy)NSString * content; 这个是文字

 20个函数 难怪会晕
 
 - (void)viewDidLoad 初始化1个表格  三个按钮 背景 以及表格所需数据源
 
 -(void)setupData 本来是用来给表格准备数据的 现在作废
 - (void)createTextView
 -(UICollectionView *)creatCollectionView
 
 - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
 
 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
 
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 
 - (void)updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
 
 - (NSMutableArray *)storeData
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 
 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
 
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
 
 -(void)BackToMain
 -(void)plusphoto
 -(void)viewWillAppear:(BOOL)animated
 -(void)deletephoto
 
 
 
 */

#import "WritingLayoutViewController.h"
#import "ObjectFunction.h"
#define ChangePageDalay 8
#define Distance 2 //cell之间的缝隙
#define NN 1 //一行最多几个cell

//图片算法
static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    size.width *= height / size.height;
    size.height = height;
    return size;
}

@interface WritingLayoutViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate, ZSTextViewCellDelegate,UITextViewDelegate>

//@property(nonatomic,strong) NSMutableArray *selectionPhotoArray;
@property (nonatomic,strong)UICollectionView *colletionView;
@property (nonatomic,copy)NSMutableArray* New;
@property (nonatomic,copy)NSMutableArray *imgArray;

@property (nonatomic, assign)float ideal_height;//记录高度
@property (nonatomic,copy)NSString * content;

//信号量 时间量
@property (nonatomic, retain) dispatch_semaphore_t signal;
@property (nonatomic, assign) dispatch_time_t overTime;
@property (nonatomic, assign)dispatch_queue_t quene;
@property (nonatomic, assign)dispatch_queue_t mquene;

@property (nonatomic, assign)float tmp_x;
@property (nonatomic, assign)float tmp_y;
@property (nonatomic, assign)float h1;

@property (nonatomic,strong)UIScrollView* sv;

@property (nonatomic,assign) CGRect kbRect;
@property(nonatomic,strong)diary* target;

@end

@implementation WritingLayoutViewController



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    _sv=[[UIScrollView alloc]initWithFrame:self.view.frame];
    _sv.showsVerticalScrollIndicator=YES; //
    _sv.scrollEnabled=YES;
    _sv.userInteractionEnabled=YES;
    _sv.contentSize=CGSizeMake(SCREENW, SCREENH);
    _sv.backgroundColor=[UIColor clearColor];
  //  _sv.
    
    
   //声明一个UIViewController+VoiceKeyboard 帮忙注册通知
    self.enableVoiceKeyboard=YES;
    

    
    
    //声明一个信号量和时间量，以图后面线程安全用, 一个主线程更新reload 一个线程持续进入delete 模式！
    
     _signal = dispatch_semaphore_create(1);
    _overTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    _quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _mquene = dispatch_get_main_queue();
    
    //设置背景
    _BG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_BG];
  //     [_sv addSubview:_BG];

    
 //[self createTextView];
 //[self setupData];
    
    
// 初始化表格
    _storeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, /*_navRect.size.height*/SCREENW/10+15, SCREENW, SCREENH) style:UITableViewStyleGrouped];
    _storeTable.delegate = self;//这里会出循环引用！！！
    _storeTable.dataSource = self;
    _storeTable.tableHeaderView=[self creatCollectionView];
    _storeTable.backgroundColor=[UIColor redColor];
    _storeTable.bounces=NO;
 // [self.view addSubview:_storeTable];
    [_sv addSubview:_storeTable];
   
    
    
//初始化返回按钮
     UIImage* buttonimage=[UIImage imageNamed:@"back1.png"];
    _bn=[UIButton buttonWithType:UIButtonTypeCustom];
    _bn.frame=CGRectMake(10,
                                                  10,
                                                  SCREENW/10,
                                                  SCREENW/10);
    [_bn setImage:[buttonimage TransformtoSize:CGSizeMake(SCREENW/16, SCREENW/16)] forState:UIControlStateNormal];
    [_bn setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.35]];
    _bn.layer.masksToBounds=YES;
    _bn.layer.cornerRadius=SCREENW/32;
    [_bn addTarget:self action:@selector(BackToMain) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addSubview:_bn];
   //   [_sv addSubview:_bn];
  
//初始化添加按钮
    UIImage* pbuttonimage=[UIImage imageNamed:@"+.png"];
    _pbn=[UIButton buttonWithType:UIButtonTypeCustom];
    _pbn.frame=CGRectMake(SCREENW-10-SCREENW/10-SCREENW/10,
                         10,
                         SCREENW/10,
                         SCREENW/10);
    [_pbn setImage:[pbuttonimage TransformtoSize:CGSizeMake(SCREENW/16, SCREENW/16)] forState:UIControlStateNormal];
    [_pbn setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.35]];
    _pbn.layer.masksToBounds=YES;
    _pbn.layer.cornerRadius=SCREENW/32;
    [_pbn addTarget:self action:@selector(plusphoto) forControlEvents:UIControlEventTouchUpInside];
 //   [self.view addSubview:_pbn];
  //    [_sv addSubview:_pbn];
    
    
//中间的标题
    UILabel* todayLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENW/3,
                                                                 10,
                                                                 SCREENW/3,
                                                                 SCREENW/10)];
    todayLabel.text=_today;
    todayLabel.textColor=[UIColor blackColor];
    todayLabel.layer.masksToBounds=YES;
    todayLabel.layer.cornerRadius=SCREENW/32;
    
//初始化删除按钮
    UIImage* mbuttonimage=[UIImage imageNamed:@"-.png"];
    _mbn=[UIButton buttonWithType:UIButtonTypeCustom];
    _mbn.frame=CGRectMake(SCREENW-10-SCREENW/10,
                         10,
                         SCREENW/10,
                         SCREENW/10);
    _mbn.tag=0;
    [_mbn setImage:[mbuttonimage TransformtoSize:CGSizeMake(SCREENW/16, SCREENW/16)] forState:UIControlStateNormal];
     [_mbn setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.35]];
    _mbn.layer.masksToBounds=YES;
    _mbn.layer.cornerRadius=SCREENW/32;
    [_mbn addTarget:self action:@selector(begindelete) forControlEvents:UIControlEventTouchUpInside];
 //   [self.view addSubview:_mbn];
  //    [_sv addSubview:_mbn];
    

//初始化图片数据源，但是为空。
    _imgArray = [[NSMutableArray alloc]init];
 /*   for (int i = 0; i < 20; i ++) {
    [_imgArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1]]];
    }*/
    
//设置输入文字框
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREENW, 44)];
    _textView.delegate=self;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.font=[UIFont systemFontOfSize:18];
    _textView.scrollEnabled=YES;
    _textView.showsVerticalScrollIndicator = YES;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.returnKeyType=UIReturnKeyDone;
    _textView.keyboardType=UIKeyboardTypeDefault;
    
    //  _textView.backgroundColor=[UIColor clearColor];
    _textView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:0.65];
    _textView.layer.masksToBounds=YES;
    _textView.layer.cornerRadius=SCREENW/16;
    // 设置提示文字
    // _textView.placehoder = @"输入";
    // 设置提示文字颜色
     // _textView.placehoderColor = [UIColor grayColor];
    // 设置textView的字体
    _textView.font = [UIFont systemFontOfSize:18];
   // [self.view addSubview:_textView];

    //--------------业务逻辑   查找到今天的日记------------------------------------
    RLMResults<diary *> *temp = [diary objectsWhere:@"date = %@",_today];
    NSLog(@"%@",temp);
    if (temp.count == 0) {
        NSString* nullstr=@"";
        _textView.text= [nullstr copy];
    } else {
        
        _target=[[diary objectsWhere:@"date=%@",_today]firstObject];
        
        _textView.text=[_target.content copy];
        
        
    }
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
    _sv.tag=1000;
    
    [self.view addSubview:_sv];
    [self.view addSubview:_bn];
    [self.view addSubview:_mbn];
    [self.view addSubview:_pbn];
    [self.view addSubview:todayLabel];
    [_sv addSubview:_textView];
}
//键盘出现
- (void)keyboardDidShow:(NSNotification *)notification{
    //获取键盘高度
    /*NSDictionary *dict = notification.userInfo;
    _kbRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self autoAdjustTo: _textView];*/
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSLog(@"%@",keyboardObject);
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    //得到键盘的高度
    //CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSLog(@"%f",duration);
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelay:0];
    
    //设置view的frame，往上平移
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, 0, SCREENW, SCREENH-keyboardRect.size.height)];
    
    //提交动画
    [UIView commitAnimations];

}


//注销通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


//键盘消失
- (void)keyboardDidHidden:(NSNotification *)notification{
    //定义动画
    //[UIView beginAnimations:nil context:nil];
    // [UIView setAnimationDuration:0.25];
    
    //设置view的frame，往下平移
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    // [UIView commitAnimations];  
}




-(void)setupData
{
 //   ZSTextViewCell * cell  = [[ZSTextViewCell  alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"WritingTableViewCell"];
 //   NSMutableArray *section0 = [NSMutableArray arrayWithObjects: nil];
  //  NSMutableArray *section1 = [NSMutableArray arrayWithObjects: cell, nil];
 //   [self.storeData addObject:section0];
  //  [self.storeData addObject:section1];
    [_storeTable reloadData];
}

- (void)createTextView{
    // 创建textView
    _textView = [[WJTextView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 50)];
    // 设置颜色
    _textView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
    _textView.layer.masksToBounds=YES;
    _textView.layer.cornerRadius=self.view.frame.size.width/16;
    // 设置提示文字
   // _textView.placehoder = @"输入";
    // 设置提示文字颜色
   // _textView.placehoderColor = [UIColor grayColor];
    // 设置textView的字体
    _textView.font = [UIFont systemFontOfSize:18];
    // 设置内容是否有弹簧效果
    _textView.alwaysBounceVertical = YES;
    // 设置textView的高度根据文字自动适应变宽
   // _textView.isAutoHeight = YES;
    // 添加到视图上
  //  [self.view addSubview:_textView];
 //   self.textView = _textView;
}


-(UICollectionView *)creatCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.minimumLineSpacing = 3;
    layout.minimumInteritemSpacing = 3;
    _colletionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10+SCREENW/10, SCREENW-20, SCREENH/2) collectionViewLayout:layout];
    _colletionView.backgroundColor = [UIColor blackColor];
    _colletionView.dataSource = self;
    _colletionView.delegate = self;
    _colletionView.scrollEnabled=NO;
    [self.colletionView registerClass:[photoCollectionViewCell class] forCellWithReuseIdentifier:@"picCell"];
    return _colletionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _imgArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    photoCollectionViewCell *cell = (photoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    cell.image.image = _imgArray[indexPath.row];
    cell.btnDelete.hidden = YES;
    cell.btnDelete.tag=indexPath.row;
    NSLog(@"隐藏 %d号 删除按钮!",indexPath.row);
    
    for (UIView *view in cell.contentView.subviews) {
        if (view) {
            view.frame = cell.bounds;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
  /*根据indexPath.row 来获取_imgArray的图片 然后很简单。重定向。按照图片自身的长宽比，把宽度缩小到screenW. 并且计算出他的
   长度！
   */
    UIImage* image=[_imgArray objectAtIndex:indexPath.row];
    float ck_ratio=image.size.height/image.size.width;
    float w=SCREENW;
    float c=(ck_ratio)*w;
    _h1=_h1+c+Distance;
     if(indexPath.row==_imgArray.count-1)_h1=_h1+10;
            _colletionView.frame=CGRectMake(0, 0, SCREENW, _h1);
            _storeTable.frame=CGRectMake(0, SCREENW/10+15, SCREENW, _h1);
            _sv.contentSize=CGSizeMake(SCREENW, _h1+SCREENH);
            _textView.frame=CGRectMake(0, _h1+50, SCREENW, SCREENH-45);

    return CGSizeMake(w, c);
    
    /*
    int N = (int)_imgArray.count; //N是图片的个数
    
    
    CGRect newFrames[N]; //声明了N个cgr 估计是图片的位置
    
    _ideal_height = MAX(_colletionView.frame.size.height, _colletionView.frame.size.width) / NN;
    //得到理想高度？ 比较collectionview的高度 宽度的最大的那个。处以一行拥有cell数目？那就是高度/1 ？
    
    float seq[N];// n个不知道啥？
    
    float total_width = 0;//声明了总宽度
    
    for (int i = 0; i < _imgArray.count; i++) {
        UIImage *image = [_imgArray objectAtIndex:i] ;
        CGSize newSize = CGSizeResizeToHeight(image.size, _ideal_height);
        newFrames[i] = (CGRect) {{0, 0}, newSize};
        seq[i] = newSize.width;
        total_width += seq[i];
    }//循环n个 把每张图的size 重定向处理？ 计算newf seq 总宽
    
    int K = (int)roundf(total_width / _colletionView.frame.size.width);
    //总宽除collectionview 宽度？em...
    
    float M[N][K];
    float D[N][K];
    
    for (int i = 0 ; i < N; i++)
        for (int j = 0; j < K; j++)
            D[i][j] = 0;
    
    for (int i = 0; i < K; i++)
        M[0][i] = seq[0];
    
    for (int i = 0; i < N; i++)
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);
    
    float cost;
    for (int i = 1; i < N; i++) {
        for (int j = 1; j < K; j++) {
            M[i][j] = INT_MAX;
            
            for (int k = 0; k < i; k++) {
                cost = MAX(M[k][j-1], M[i][0]-M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
        }
    }
    
 
    // Ranges & Resizes
 
    int k1 = K-1;
    int n1 = N-1;
    int ranges[N][2];
    while (k1 >= 0) {
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = Distance;
    float heightOffset = cellDistance, widthOffset;
    float frameWidth;
    
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = _colletionView.frame.size.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            rowWidth += newFrames[j].size.width;
        }
        
        float ratio = frameWidth / rowWidth;
        widthOffset = 0;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *= ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) + 1) * cellDistance;
            newFrames[j].origin.y = heightOffset;
            
            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }
    CGRect frame = newFrames[indexPath.row];

  //  _tmp_y=frame.size.height - 1;
     if(_h1==0){
         _h1=frame.origin.y+frame.size.height;
         
     }
    
    if(_tmp_y==0)
    {
        _tmp_y=frame.origin.y+Distance;
        
    }//存下前一个cell的纵坐标
    else{
        if(frame.origin.y>_tmp_y)//cell换行了
        {
            NSLog(@"换行了！");
            _h1=_h1+frame.size.height+3;
            _tmp_y=frame.origin.y+Distance;
            _colletionView.frame=CGRectMake(0, 0, SCREENW, _h1);
            _storeTable.frame=CGRectMake(0, SCREENW/10+15, SCREENW, _h1);
            _sv.contentSize=CGSizeMake(SCREENW, _h1+SCREENH);
            
        }else//cell 没换行
        {
            //啥都不做
        }
    }
    
    return CGSizeMake(frame.size.width - 1, frame.size.height - 1);*/
}



//-----------------uitableview-----------------
- (void)updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath{
    _content=text;
}
- (NSMutableArray *)storeData {
    if (!_storeData) {
        self.storeData = [NSMutableArray array];
    }
    return _storeData;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"%d",self.storeData.count);
    return self.storeData.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *rows = [self.storeData hs_objectWithIndex:section];
    NSAssert([rows isKindOfClass:[NSMutableArray class]], @"此对象必须为一个可变数组,请检查数据源组装方式是否正确!");
  //  NSLog(@"%d",rows.count);
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *ID = @"WritingTableViewCell";
   // UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ZSTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell  == nil) {
        cell = [[ZSTextViewCell  alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray *sections = [self.storeData hs_objectWithIndex:indexPath.section];
    NSAssert([sections isKindOfClass:[NSMutableArray class]], @"此对象必须为一个可变数组,请检查数据源组装方式是否正确!");
    if([sections[indexPath.row] isKindOfClass:[ZSTextViewCell class]])
    {
     //   cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        cell = [sections objectAtIndex:indexPath.row];
        cell.indexPath=indexPath;
        cell.tableView=_storeTable;
        cell.contentStr=_content;
        cell.delegate=self;
       // [cell addSubview:temp ];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // [self dismissViewControllerAnimated:YES completion:nil];

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSMutableArray *sections = [self.hs_dataArry hs_objectWithIndex:indexPath.section];
     NSAssert([sections isKindOfClass:[NSMutableArray class]], @"此对象必须为一个可变数组,请检查数据源组装方式是否正确!");
     HSBaseCellModel *cellModel = (HSBaseCellModel *)[sections hs_objectWithIndex:indexPath.row];
     Class class =  NSClassFromString(cellModel.cellClass);
     return [class getCellHeight:cellModel];*/
   // return SCREENH;
    ZSTextViewCell * cell = (ZSTextViewCell *)[tableView.dataSource tableView:_storeTable cellForRowAtIndexPath:indexPath];
    if ([cell CellHeight]<44) {
        return 60;
    } else {
        return 60;
      //  return [cell CellHeight]+30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //如果是最后一个section
    if(section == self.storeData.count - 1){
        return 10;
    }
    return 5;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //如果是最后一个section
    if(section == self.storeData.count - 1){
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        [view2 setBackgroundColor:[UIColor clearColor]];
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}










//------------------返回按钮 也是保存！-------------------
/*保存图片这个很难的感觉，需要把图片id 弄成今天 弄个循环
把imageArray 的图片 载入 _tmp的内容里。所以很简单，找到id后把这一天的图片都删了
然后这一天就是空，于是再存！如果imageArray没有变，等于就重新存了一遍。没事
如果少了就等于删了。
 https://www.realm.io/docs/objc/latest/api/classes/rlmresults 在这里知道了
 RLMResults 有属性count 方法objectwithIndex 所以可以for 循环访问！
 */
-(void)BackToMain
{
     [self dismissViewControllerAnimated:YES completion:nil];
    //图片操作
    //_tmp=[[picture alloc]init];
    //_tmp.PicId=_today;//今天
    // _tmp.content= UIImageJPEGRepresentation(icon.image, 1.0f);
    // RLMResults<picture *> *temp = [picture objectsWhere:@"PicId = %@",@"systembg"];
    
    //删除之前的这一天的图片
    [self deleteThePhoto];
    //保存现在的图片
    [self saveThePhoto];
    [self saveDiary];
    [self saveTag];
}
//查询前缀是 today 的所有picid 然后删除之。
-(void)deleteThePhoto
{
    RLMResults<picture*> *temp = [picture objectsWhere:@"PicId BEGINSWITH %@ ",_today];
    if(temp.count==0){ NSLog(@"不需要删除，因为数据库没有关于这一天的图片！");  }
    else{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:temp];//删除某条数据
    [realm commitWriteTransaction];
        NSLog(@"删除完毕！");
    }
    
}
//先考虑怎么存 再考虑怎么删除吧。因为删除需要找到他们的id！
-(void)saveThePhoto
{
      
    for(int i=0;i<_imgArray.count;i++)
    {//循环把_imgArray里的对象 -> pic
        NSString* num=[[NSString alloc]initWithFormat:@"%d",i];
     //   NSLog(@"num");
        
        NSString* pid=[_today stringByAppendingString:num];
        
   //     NSLog(@"pid");
        _tmp=[[picture alloc]init];
        _tmp.PicId=pid;
        _tmp.content= UIImageJPEGRepresentation([_imgArray objectAtIndex:i], 1.0f);
       
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [[RLMRealm defaultRealm] addObject:_tmp];
        }];
        NSLog(@"保存了图%@",pid);
    }
    
}
-(void)saveDiary
{
    // NSLog(@"存数据");
    
    _target=[[diary alloc]init];
    _target.content=[_textView.text copy];
    _target.date=[_today copy];
    _target.diarydate=[_today copy];
    
    //-------------------业务逻辑 存改日记数据-----------------------------
    RLMResults<diary *> *temp = [diary objectsWhere:@"date = %@",_today];
    NSLog(@"%@",temp);
    if (temp.count == 0) {//如果不存在此数据则存
        
        if([_target.content isEqualToString:@""]!=1)
        {
            [[RLMRealm defaultRealm] transactionWithBlock:^{
                [[RLMRealm defaultRealm] addObject:_target];
            }];
        }
        
    } else { //存在此数据则改
        
        NSLog(@"数据库已经有该条数据,只需要修改");
        _target=[[diary objectsWhere:@"date=%@",_today]firstObject];
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            _target.content=[_textView.text copy];
            //再存
            [[RLMRealm defaultRealm] addObject:_target];
        }];
        
    }

}
-(void)saveTag
{
    NSString* Today=@"T";
    Today=[Today stringByAppendingString:_today];
    RLMResults<appStat *>* temp1=[appStat objectsWhere:@"appstatId = %@",Today];
    NSLog(@"today = %@",_today);
    NSLog(@"today = %@",Today);
    
    if (temp1.count == 0) {//不存在今天的tag。 但是数据为空则什么都不做。有数据则存。
        
        if(_imgArray.count==0 && _textView.text.length==0)//数据为空
        {
            //doing nothing
        }else{ //有数据
            appStat* tag=[[appStat alloc]init];
            NSString* Today=@"T";
            
             NSLog(@"存1 today = %@",Today);
            Today=[Today stringByAppendingString:_today];
            tag.appstatId=Today;
            tag.stat=1;
            [[RLMRealm defaultRealm] transactionWithBlock:^{
                [[RLMRealm defaultRealm] addObject:tag];
            }];
        }
        
    } else {//存在了。判断数据是否清空了。是则删，不是则什么都不做。
        
        if(_imgArray.count==0 && _textView.text.length==0)//数据为空
        {
            NSLog(@"删除某一条数据");
            NSString* Today=@"T";
            Today=[Today stringByAppendingString:_today];
             NSLog(@"删1 today = %@",Today);
            RLMResults<appStat *> *temp = [appStat objectsWhere:@"appstatId = %@",Today];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm deleteObjects:temp];//删除某条数据
            [realm commitWriteTransaction];
            
        }else
        {
    
            
        }
        
    }
}




//------------------添加图片按钮-------------------
-(void)plusphoto
{
   
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _New=[[NSMutableArray alloc]initWithObjects:nil];
        for(int i=0;i<photos.count;i++)
        {
            [_New addObject: [photos objectAtIndex:i]];
            
        }
        _imgArray=_New;
        _tmp=0;
        _h1=0;
        [_colletionView reloadData];
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //_colletionView.frame=CGRectMake(0, 0, SCREENW, SCREENH/2-5);
   // _textView.frame=CGRectMake(5, SCREENH/2, SCREENW-10, SCREENH/2-10);
    _tmp_y=0;
    _h1=0;
    _colletionView.frame=CGRectMake(0, 0, SCREENW, _h1);
    _storeTable.frame=CGRectMake(0, SCREENW/10+15, SCREENW, _h1);
    _sv.contentSize=CGSizeMake(SCREENW, _h1+SCREENH);
    
    //取背景图像
    RLMResults<picture *>* temp2=[picture objectsWhere:@"PicId = %@",@"systembg"];
    //  NSLog(@"%@",temp2);
    if (temp2.count == 0) {
        
    } else {
        
        picture* p1=[[picture objectsWhere:@"PicId=%@",@"systembg"]firstObject];
        UIImage *_decodedImage = [UIImage imageWithData:p1.content];
        _BG.image=_decodedImage;
    }
    
    //取背景模糊度
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
    
    //查询数据库里 初始化imageArray
  
    RLMResults<picture*> *temp = [picture objectsWhere:@"PicId BEGINSWITH %@ ",_today];
     NSLog(@"selectResults  is  %@",temp);
    [temp sortedResultsUsingKeyPath:@"PicId" ascending:YES];
    NSLog(@"sort  is  %@",temp);
    
    int j;
  if(_imgArray.count==0)
  {
    if(temp.count==0)
    {
        NSLog(@"数据库里没有这一天的图片！");
        
    }else{
        for(int i=0;i<temp.count;i++)
        {
            if(_imgArray==nil){
                NSLog(@"_imageArray 为 nil ！");
              
            }
            else{
                for(j=0;j<temp.count;j++)//把picID=_today+i的遍历出来然后
                {
                    picture* sortItem=[temp objectAtIndex:j];
                    NSString *str= sortItem.PicId;
                    NSString* substr= [str substringFromIndex:10];
                    if(i==[substr intValue]) break;
                    
                }
                picture * ptemp=[temp objectAtIndex: j ];
                UIImage *decodImage = [UIImage imageWithData:ptemp.content];
                [_imgArray addObject: decodImage ];
                
            }
        }
    }
    NSLog(@"完成取数据的图！");
    //  [_colletionView reloadData];
  }else
  {
      NSLog(@"imageArray已经有图片了！");
      [_colletionView reloadData];
  }
    
}
-(void)begindelete
{
    if(_imgArray==nil || _imgArray.count==0)
    {
         [JDLAlertView showAlertViewWithMessage:@"还没有插入图片，无法删除" backgroundStyle:JDLBackgroundStyleNone duration:2 viewController:self];
        return ;
        
    }
    
    if(_mbn.tag==1) _mbn.tag=0;
    else if(_mbn.tag==0) _mbn.tag=1;
    
    if(_mbn.tag==1)
    {
        UIImage* mbuttonimage=[UIImage imageNamed:@"right1.png"];
        [_mbn setImage:[mbuttonimage TransformtoSize:CGSizeMake(SCREENW/16, SCREENW/16)] forState:UIControlStateNormal];
        
        [self deletephoto];
    }
    if(_mbn.tag==0)
    {
        for(photoCollectionViewCell *cell in _colletionView.visibleCells)
        {
            
            // 定义cell的时候btn是隐藏的, 在这里设置为YES
            [cell.btnDelete setHidden:YES];
        }
        UIImage* mbuttonimage=[UIImage imageNamed:@"-.png"];
        [_mbn setImage:[mbuttonimage TransformtoSize:CGSizeMake(SCREENW/16, SCREENW/16)] forState:UIControlStateNormal];
        
    }
}
-(void)deletephoto
{

    for(photoCollectionViewCell *cell in _colletionView.visibleCells)
    {
        
        // 定义cell的时候btn是隐藏的, 在这里设置为NO
        [cell setNeedsDisplay];
        [cell.btnDelete setHidden:NO];
        NSLog(@"显示 %ld号 删除按钮", cell.btnDelete.tag);
        //cell.btnDelete.tag = selectIndexPath.item;
        //添加删除的点击事件
        [cell.btnDelete addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
- (void)btnDelete:(UIButton *)btn{
    
    //取出源item数据
    id objc = [self.imgArray objectAtIndex:btn.tag];
    //从资源数组中移除该数据
    [self.imgArray removeObject:objc];
   
    dispatch_async(_mquene, ^{
    NSLog(@"开始 reloadData");
        dispatch_semaphore_wait(_signal, _overTime);
        _h1=0;
        _tmp_y=0;
          [_colletionView reloadData];
        dispatch_semaphore_signal(_signal);
    NSLog(@"结束 reloadData");
        });
    
  dispatch_async(_quene, ^{
    NSLog(@"开始进入 delete 模式");
        dispatch_semaphore_wait(_signal, _overTime);
         [self deletephoto];
        dispatch_semaphore_signal(_signal);
    NSLog(@"结束 delete 模式");
        });

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
