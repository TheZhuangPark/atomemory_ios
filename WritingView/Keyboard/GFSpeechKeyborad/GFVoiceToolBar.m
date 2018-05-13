//
//  GFVoiceToolBar.m
//  gf_testVoice
//
//  Created by gaof on 2017/6/15.
//  Copyright © 2017年 gaof. All rights reserved.
/*
 一个属性
 @property (nonatomic,copy) void(^block)(UIButton *sender);

 
 三个方法
 -(instancetype)init
 - (void)switchDidClick:(UIButton *)sender
 - (void)switchClick:(void(^)(UIButton *sender))block
 
 */




#import "GFVoiceToolBar.h"

@interface GFVoiceToolBar() <UITextViewDelegate>
@property (nonatomic,copy) void(^block)(UIButton *sender);

@end

@implementation GFVoiceToolBar
-(instancetype)init {
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        self.backgroundColor=[UIColor whiteColor];
        UIButton *voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 0, 50, 50)];
        UIButton *doneBtn =[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100, 0, 50, 50)];
        
        [voiceBtn setImage:[UIImage imageNamed:@"btn_xnd_yuyinshuru.png"] forState:UIControlStateNormal];
        [voiceBtn setImage:[UIImage imageNamed:@"btn_xnd_jianpanshufru.png"]forState:UIControlStateSelected];
        [voiceBtn addTarget:self action:@selector(switchDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:voiceBtn];
        
        
        [doneBtn setTitle:@"↓   " forState: UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(clickDone:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneBtn];
        
  //      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
 //       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
  //      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextdidChange) name:UITextViewTextDidChangeNotification object:nil];
        
        
    }
    return self;
}
- (void)switchDidClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(voiceToolBarSwitchDidClick:)]) {
        [self.delegate voiceToolBarSwitchDidClick:sender];
    }
    
    if (self.block) {
        self.block(sender);
    }
}
- (void)switchClick:(void(^)(UIButton *sender))block {
    if (block) {
        self.block = block;
    }
}

- (void)clickDone:(UIButton *)button {
    UITextView* currentTextview= self.delegate;
    [currentTextview resignFirstResponder];

}
/*
//键盘出现
- (void)keyboardDidShow:(NSNotification *)notification{
    //获取键盘高度
    NSDictionary *dict = notification.userInfo;
    _kbRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UITextView* currentTextview =self.delegate;
    [self autoAdjustTo: currentTextview];
}
//键盘消失
- (void)keyboardDidHidden:(NSNotification *)notification{
   UITextView* currentTextview= self.delegate;
    currentTextview.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
}
*/




/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
   //  id currentTextview=self.delegate;
    [self autoAdjustTo:textView];
    return YES;
}*///代替这个textView 协议。使用通知模式。

/*
- (void)TextdidChange{
 //   NSLog(@"noti -- didChange");
    UITextView* currentTextview=self.delegate;
    [self performSelector:@selector(autoAdjustTo:) withObject:currentTextview afterDelay:0.5f];
    [self autoAdjustTo:currentTextview];
}


- (void)autoAdjustTo:(UITextView *)textView{
     UITextView* currentTextview=self.delegate;
    sleep(0.1);
    //1.计算键盘的位置 Y 坐标
    CGFloat kbY = CGRectGetMinY(_kbRect);
    
    //2.计算textView的 MAXY 和 MINY
    CGRect textRect = [textView convertRect:textView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat MAXY = CGRectGetMaxY(textRect);
    CGFloat MINY = CGRectGetMinY(textRect);
    
    //3.计算textView 内容的高度
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    
    //4.获取光标的位置
    NSRange _range=textView.selectedRange;
    float _rangeY=(float)_range.location;
    CGPoint _rangeXY=CGPointMake(0, _rangeY);
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    CGPoint point = [textView convertPoint:cursorPosition toView:[UIApplication sharedApplication].keyWindow];
    CGPoint point2= [textView convertPoint:_rangeXY toView:[UIApplication sharedApplication].keyWindow];
    
    NSLog(@"+++++++++++++++++光标坐标：%f   键盘坐标:%f  光标位置2 %f++++++++++++++",point.y+15,kbY, point2.y+15);
    
    //5.判断
    //当textView 的frame比较大，上移后还会被键盘遮挡的话
    if (MAXY > kbY) {
        //当输入光标在键盘下方,15是字体的大小
        if (point.y+15>kbY) {
            //计算textView上内边距需要移动的高度
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat move = point.y + 15 - kbY - textView.textContainerInset.top;
                NSLog(@"=======================%f==============================",move);
                NSLog(@"---------------%f-----------------",textView.textContainerInset.top);
                //这里move-10是为了光标与键盘边界有点距离，更美观
                textView.textContainerInset = UIEdgeInsetsMake(-move-10-5, 5, 5, 5);
            }];
        }
    }
}
*/
//注销通知
- (void)dealloc{
 //   [[NSNotificationCenter defaultCenter]removeObserver:self];
   
}



//============单例================
//static id _instance;
//+(instancetype)allocWithZone:(struct _NSZone *)zone {
//    if (_instance == nil){
//        _instance = [super allocWithZone:zone];
//    }
//    return _instance;
//}
//
//
//- (instancetype) init {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        UIView *view = [super init];
//        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
//        UIButton *voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 0, 60, 60)];
//        [voiceBtn setImage:[UIImage imageNamed:@"btn_xnd_yuyinshuru"] forState:UIControlStateNormal];
//        [voiceBtn setImage:[UIImage imageNamed:@"btn_xnd_jianpanshufru"] forState:UIControlStateSelected];
//        [voiceBtn addTarget:self action:@selector(switchDidClick:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:voiceBtn];
//        _instance = view;
//    });
//    return _instance;
//}
//
//+ (instancetype)copyWithZone:(struct _NSZone *)zone{
//    return _instance;
//}
//+(instancetype)mutableCopyWithZone:(struct _NSZone *)zone{
//    return _instance;
//}
//
//
//+ (instancetype)share {
//    return [[self alloc] init];
//}

@end
