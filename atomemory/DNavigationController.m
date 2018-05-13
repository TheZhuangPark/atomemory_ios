//
//  DNavigationController.m
//  atomemory
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DNavigationController.h"
#import "ViewController.h"
#import "UIImage+Extension.h"


@interface DNavigationController ()

@end

@implementation DNavigationController


//-----------------------------ui逻辑----------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    
    //    // 这句话很重要，可以到单独的控制器里去设置
    //    self.navigationBar.translucent = YES;
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.delegate = self;
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
+ (void)initialize {
    // 初始化navigationbar
    UINavigationBar *appearance = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    
}


//-----------------------------业务逻辑-----------------------------------
//跳转到导航栏下一个界面
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  
  
    
    if (self.viewControllers.count > 0) {// 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -15;
        
        UIButton *button = [[UIButton alloc] init];
        // 设置按钮的背景图片
        UIImage* buttonimage=[UIImage imageNamed:@"back1.png"];
        [button setImage:[buttonimage TransformtoSize:CGSizeMake(SCREENW/13, SCREENW/13)] forState:UIControlStateNormal];
        
    
        // 设置按钮的尺寸为背景图片的尺寸
      //  button.frame = CGRectMake(0, 0, 33, 33);
        
        //监听按钮的点击
        [button addTarget:self action:@selector(backButtonTapClick) forControlEvents:UIControlEventTouchUpInside];
        
        //设置导航栏的按钮
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
        //        viewController.navigationItem.leftBarButtonItem = backButton;
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
        
    }
    [super pushViewController:viewController animated:animated];
}
//回到上一个界面


- (void)backButtonTapClick {
 //   [self viewWillAppear:YES];
  //  [self viecon]
 //    [JDLAlertView showAlertViewWithMessage:@"hey" backgroundStyle:JDLBackgroundStyleNone duration:3 viewController:self];
    [self popViewControllerAnimated:YES];
  
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
