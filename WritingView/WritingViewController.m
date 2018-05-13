//
//  WritingViewController.m
//  podtext
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WritingViewController.h"

@interface WritingViewController ()
@property(nonatomic,strong)diary* target;

@end

@implementation WritingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化返回按钮
    _bn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_bn setTitle:@"完成" forState:UIControlStateNormal];
    _bn.frame = CGRectMake(self.view.frame.size.width/20,
                           self.view.frame.size.height/20,
                           self.view.frame.size.width/10,
                           self.view.frame.size.height/10);
    [_bn setTitleColor:[UIColor colorWithRed:0.208 green:0.643 blue:0.941 alpha:1.000] forState:UIControlStateNormal];
    _bn.backgroundColor = [UIColor whiteColor];
    [_bn addTarget:self action:@selector(savediary:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bn];
    
    _chosenday=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width/8,
                                                        self.view.frame.size.height/20,
                                                        self.view.frame.size.width/4,
                                                        self.view.frame.size.height/10)];
    [_chosenday setTextColor:[UIColor colorWithRed:0.208 green:0.643 blue:0.941 alpha:1.000]];
    _chosenday.text=[_today copy];
    [self.view addSubview:_chosenday];
    
    //初始化输入文字框
    _textView=[[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/20,
                                                           self.view.frame.size.height/20+self.view.frame.size.height/10+5,
                                                           self.view.frame.size.width-self.view.frame.size.width/20,
                                                           self.view.frame.size.height-(self.view.frame.size.height/20+self.view.frame.size.height/10+5))];
    _textView.textColor=[UIColor blackColor];
    _textView.font=[UIFont fontWithName:@"Arial" size:14.0];
    _textView.delegate=self;
    _textView.backgroundColor=[UIColor whiteColor];
    
    

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
    
    [self.view addSubview:_textView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)savediary:(UIButton*)sender{// 保存按钮所触发的函数
    
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

    
    
       [self dismissViewControllerAnimated:YES completion:nil];
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
