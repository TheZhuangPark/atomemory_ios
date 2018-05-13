//
//  StoreTableViewCell.m
//  atomemory
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
/*
 属性有7个
 StoreCommenItem*) item 用来打包存其他6个控件的
 uibutton* ) item1 一个商品按钮
 uibutton* ) item2  第二个商品按钮
 uilabel* ) namelabel1 商品名字1
 uilabel* ) namelabel2 商品名字2
 uilabel* ) pricelabel1 价格1
 uilabel* ) pricelabel2 价格2
 
 函数有8个
 awakeFromNib 不知道干嘛的
 cellWithTableView 好像是cell 初始化函数
 initWithStyle: reuseIdentifier: 不清楚，根据cell的id来规定其风格？
 setupSubviews 初始化并添加6个控件
 layoutSubviews 设置好6个控件的位置
 buy 绑定在商品按钮上的函数，用来写storeKit的代码实现内购
 setItem 就是当属性item被赋值时启动的，会把对方的item 内的6控件属性移植到此对象的6控件里。
 */

#import "StoreTableViewCell.h"

@interface StoreTableViewCell ()
/** 1.按钮1 */
@property (nonatomic, strong) UIButton *item1;
/** 2.名标1 */
@property (nonatomic, strong) UILabel *namelabel1;
/** 3.名称2 */
@property (nonatomic, strong) UILabel *namelabel2;
/** 4.按钮2 */
@property (nonatomic, strong) UIButton *item2;

@property (nonatomic, strong) UILabel *pricelabel1;
@property (nonatomic, strong) UILabel *pricelabel2;
@property (nonatomic, strong) NSString* targetProduct;
@property(strong,nonatomic)SKPaymentTransaction *tran;


@end

@implementation StoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//------------------------创建cell的方法1
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"StoreTableViewCell";
    StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell  == nil) {
        cell = [[StoreTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//------------------------创建cell的方法2
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化操作
        [self setupSubviews];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
- (void)setupSubviews {

    NSString* product1=@"com.codery.automemory.001";
    NSString* product2=@"com.codery.automemory.002";
    _productID=[[NSMutableArray alloc]initWithObjects:product1,product2,nil];

    //添加两个个button
    _item1 = [[UIButton alloc] init];
    //UIImage* item1Image=[UIImage imageNamed:@"TEA.png"];
    //[_item1 setImage:[item1Image TransformtoSize:CGSizeMake(SCREENW*2/5, SCREENW*2/5)] forState:UIControlStateNormal];
    [_item1 addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    _item1.tag=1;
    [self addSubview:_item1];
    
    _item2 = [[UIButton alloc] init];
  //  UIImage* item2Image=[UIImage imageNamed:@"CAKE.png"];
   // [_item2 setImage:[item2Image TransformtoSize:CGSizeMake(SCREENW*2/5, SCREENW*2/5)] forState:UIControlStateNormal];
    [_item2 addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
      _item2.tag=2;
    [self addSubview:_item2];
    
    //添加两个商品名称label
    _namelabel1=[[UILabel alloc]init];
 //   _namelabel1.text=@"请开发者喝杯茶";
    [_namelabel1 setTextColor:[UIColor blackColor]];
    _namelabel1.textAlignment = UITextAlignmentCenter;
    [_namelabel1 setFont:[UIFont systemFontOfSize: 14.0]];
    [self addSubview:_namelabel1];
    
    _namelabel2=[[UILabel alloc]init];
 //   _namelabel2.text=@"请开发者吃蛋糕";
    [_namelabel2 setTextColor:[UIColor blackColor]];
     _namelabel2.textAlignment = UITextAlignmentCenter;
    [_namelabel2 setFont:[UIFont systemFontOfSize: 14.0]];
    [self addSubview:_namelabel2];
    
    
    //添加两个商品价格label
    _pricelabel1=[[UILabel alloc]init];
//    _pricelabel1.text=@"￥6";
    [_pricelabel1 setTextColor:[UIColor blackColor]];
     _pricelabel1.textAlignment = UITextAlignmentCenter;
    [_pricelabel1 setFont:[UIFont systemFontOfSize: 12.0]];
    [_pricelabel1 setTextColor:[UIColor redColor]];
    [self addSubview:_pricelabel1];
    
    _pricelabel2=[[UILabel alloc]init];
   // _pricelabel2.text=@"￥12";
    [_pricelabel2 setTextColor:[UIColor blackColor]];
    _pricelabel2.textAlignment = UITextAlignmentCenter;
    [_pricelabel2 setFont:[UIFont systemFontOfSize: 12.0]];
     [_pricelabel2 setTextColor:[UIColor redColor]];
    [self addSubview:_pricelabel2];
}

/**
 * 设置子控件的frame
 */
- (void)layoutSubviews {
    [super layoutSubviews];
   
    /** 1.商品按钮 */
     CGFloat iconViewW = picH;
    CGFloat iconViewX = (SCREENW/2-iconViewW)/2;
    CGFloat iconViewY = gap;
    //  CGFloat iconViewW = 44;
    CGFloat iconViewH = iconViewW;
    //    CGFloat iconViewH = contentH;
    self.item1.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    self.item2.frame =CGRectMake(SCREENW/2+iconViewX, iconViewY, iconViewW, iconViewH);
    
    /** 2. nameLabel */
    CGFloat nameLabelX = 0;
    CGFloat nameLabelY = iconViewH+gap;
    CGFloat nameLabelW = SCREENW/2;
    CGFloat nameLabelH = labelH;
    self.namelabel1.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
     self.namelabel2.frame = CGRectMake(SCREENW/2+nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    /** 2. priceLabel */
    CGFloat priceLabelX = 0;
    CGFloat priceLabelY = nameLabelY+gap+labelH;
    CGFloat priceLabelW = SCREENW/2;
    CGFloat priceLabelH = labelH;
    self.pricelabel1.frame = CGRectMake(priceLabelX, priceLabelY, priceLabelW, priceLabelH);
    self.pricelabel2.frame = CGRectMake(SCREENW/2+priceLabelX, priceLabelY, priceLabelW, priceLabelH);
    
  
}

- (void)setItem:(StoreCommenItem *)item {
    _item = item;
    UIImage* item1image=[UIImage imageNamed:item.button1];
    UIImage* item2image=[UIImage imageNamed:item.button2];
    [self.item1 setImage:[item1image TransformtoSize:CGSizeMake(SCREENW*2/5, (SCREENW*2/10))] forState:UIControlStateNormal];
     [self.item2 setImage:[item2image TransformtoSize:CGSizeMake(SCREENW*2/5, (SCREENW*2/10))] forState:UIControlStateNormal];
    
    self.namelabel1.text = item.namelabel1;
    self.namelabel2.text = item.namelabel2;
    self.pricelabel1.text = item.pricelabel1;
     self.pricelabel2.text = item.pricelabel2;

}

//------------------内购功能------------------------
-(void)buy:(UIButton*)sender
{
    
  //  NSLog(@"收钱咯！tag=%ld,productid=%@",(long)sender.tag,[_productID objectAtIndex:sender.tag-1]);
    if([SKPaymentQueue canMakePayments]){
        
        _targetProduct=[_productID objectAtIndex:sender.tag-1];
        [self requestProductData:_targetProduct];
        
    }else{
        
        NSLog(@"不允许程序内付费");
        
    }
    
}
//------请求商品
- (void)requestProductData:(NSString *)type{
    NSLog(@"-------------请求对应的产品信息----------------");
    NSArray *product = [[NSArray alloc] initWithObjects:type,nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}
//-----请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
    [JDLAlertView showAlertViewWithMessage:@"请求失败" backgroundStyle:JDLBackgroundStyleNone duration:2 viewController:_rootViewController];
}
//-----收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%ld",[product count]);
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_targetProduct]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
//-----信息结束
- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}
//------购买事务
-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}
//-----监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        NSString *product = tran.payment.productIdentifier;
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                             NSLog(@"购买成功");
                self.tran = tran;
                NSLog(@"========%@",_productID );
                [self restoreTransaction:tran];
                break;
                
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"正在购买！");
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                [self failedTransaction:tran];
                break;
                
            default:
                break;
        }
    }
}
//-----记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}
//-----处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}
//-----恢复设置
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    
}
//-----交易失败处理
- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
     [JDLAlertView showAlertViewWithMessage:@"交易失败" backgroundStyle:JDLBackgroundStyleNone duration:2 viewController:_rootViewController];
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransaction{}
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//-----解除监听
- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    // [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
