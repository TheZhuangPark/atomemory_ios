//
//  personalizationView.h
//  atomemory
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Extension.h"

@interface personalizationView : UIView

@property (nonatomic, strong)UIButton *selectbtn;
@property (nonatomic, strong)UIButton *SetWhitebtn;

@property (nonatomic, strong)UISlider *slider1;
@property (nonatomic, strong)UISlider *slider2;
@property (nonatomic, strong)UIVisualEffectView *visualeffect;
@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)personalizationView* pView;
@property(atomic,strong)UINavigationBar *Navbar;
@property (nonatomic, strong)UIImageView *BG1;
@property (atomic, strong)UIVisualEffectView *BGeffect1;

-(void)setBG;
-(void)setIcon;
-(void)setVisualEffect;//设置毛玻璃
-(void)setSelectbtn;
-(void)setNavigationBar;
-(void)setSlider;//设置slider
    


@end
