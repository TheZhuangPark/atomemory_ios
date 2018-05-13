//
//  personalizationView.m
//  atomemory
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "personalizationView.h"

@implementation personalizationView



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
//[self addAllViews];
}
return self;
}

-(void)setBG
{

    [self addSubview:_BG1];
    
    _BGeffect1.frame=CGRectMake(0, 0, SCREENW, SCREENH);
   // _BGeffect1.alpha=0;
    [self addSubview:_BGeffect1];
}
-(void)setupBGColor //设置背景颜色
{
self.backgroundColor=[UIColor whiteColor];
    
}


-(void)setIcon//设置icon
{
 //   _icon = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENW)/4, SCREENH/6, SCREENW/2, SCREENH/2)];
    _icon.layer.masksToBounds = YES;
    [self addSubview:_icon];
}
-(void)setVisualEffect//设置毛玻璃
{
  //  _visualeffect = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _visualeffect.frame = CGRectMake((SCREENW)/4, SCREENH/6, SCREENW/2, SCREENH/2);
    _visualeffect.alpha = 0.5;
    [self addSubview:_visualeffect];
    
}
-(void)setSelectbtn//设置选择按钮
{
  //  _selectbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _selectbtn.frame = CGRectMake(SCREENW/2-SCREENW/6, 3*(SCREENH)/4 , SCREENW/3, 30);
    _selectbtn.backgroundColor=[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.35];
    
    _selectbtn.layer.cornerRadius = SCREENW/36;//2.0是圆角的弧度，根据需求自己更改
    [_selectbtn.layer setBorderColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1].CGColor];
    [_selectbtn.layer setBorderWidth:1.0];//设置边框颜色
    [_selectbtn setTitle:@"选择背景图片" forState:UIControlStateNormal];
    _selectbtn.titleLabel.font=[UIFont systemFontOfSize: 15.0];
   // [_selectbtn setTitleColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
    [_selectbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_selectbtn];
    
    //------------------
    
    _SetWhitebtn.frame = CGRectMake(SCREENW/2-SCREENW/6, SCREENH-35 , SCREENW/3, 30);
    _SetWhitebtn.backgroundColor=[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.35];
    
    _SetWhitebtn.layer.cornerRadius = SCREENW/36;//2.0是圆角的弧度，根据需求自己更改
    [_SetWhitebtn.layer setBorderColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1].CGColor];
    [_SetWhitebtn.layer setBorderWidth:1.0];//设置边框颜色
    [_SetWhitebtn setTitle:@"选择默认白色背景" forState:UIControlStateNormal];
    _SetWhitebtn.titleLabel.font=[UIFont systemFontOfSize: 15.0];
    [_SetWhitebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_SetWhitebtn];
    
}
-(void)setSlider{//设置slider
    
 //   _slider1 = [[UISlider alloc] initWithFrame:CGRectMake(SCREENW/6, 3*(SCREENH)/4+40, SCREENW*2/3, 20)];
    UILabel *slabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 3*(SCREENH)/4+40,55, 30)];
    slabel.text=@"模糊度";
    slabel.layer.masksToBounds=YES;
    slabel.textAlignment = UITextAlignmentCenter;
    [slabel setTextColor:[UIColor blackColor]];
    [slabel setFont:[UIFont systemFontOfSize: 15.0]];
    [slabel setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.35]];
    slabel.layer.cornerRadius = SCREENW/36;//2.0是圆角的弧度，根据需求自己更改
   
    UILabel *tlabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 3*(SCREENH)/4+40+40 ,55, 30)];
    tlabel.text=@"透明度";
    tlabel.layer.masksToBounds=YES;
    tlabel.textAlignment = UITextAlignmentCenter;
    [tlabel setTextColor:[UIColor blackColor]];
    [tlabel setFont:[UIFont systemFontOfSize: 15.0]];
    [tlabel setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.35]];
    tlabel.layer.cornerRadius = SCREENW/36;//2.0是圆角的弧度，根据需求自己更改
    
    
    
 //   slabel.layer.BackgroundColor=[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.6];
   // [slabel.layer setBorderWidth:1.0];//设置边框颜色
    
    [self addSubview:slabel];
    [self addSubview:tlabel];
    
    _slider1.minimumValue = 0.0;
    _slider1.maximumValue =1.0;
    _slider1.value = 0.0;
   
    _slider2.minimumValue = 0.0;
    _slider2.maximumValue = 0.75 ;
    _slider2.value = 1-_icon.alpha;
    
    [self addSubview:_slider1];
    [self addSubview:_slider2];

}
-(void)setNavigationBar
{
    [_Navbar setBackgroundImage:[UIImage createImageWithColor:
                                 [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.35]] forBarMetrics:UIBarMetricsDefault];
    
    // 设置文字
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    att[NSForegroundColorAttributeName] = [UIColor blackColor];
    [_Navbar setTitleTextAttributes:att];

}

@end
