//
//  personalizationViewController.h
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DPushViewController.h"
#import "DNavigationController.h"
#import "UIImage+Extension.h"
#import "personalizationView.h"
#import <Realm/Realm.h>
#import "picture.h"
#import "appStat.h"
#import "JDLAlertView.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Extension.h"
#import "ObjectFunction.h"



@interface personalizationViewController : DPushViewController  

//@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)UIButton *selectImage;

@property (nonatomic, strong)UISlider *slider0;
@property (nonatomic, strong)UISlider *slider1;
@property (nonatomic, strong)UIVisualEffectView *visualEfView;
@property (nonatomic, strong)personalizationView* pView;

@property(nonatomic,strong)picture* bg;
@property (nonatomic, copy)UIImageView* BG;
@property (nonatomic, strong)UIVisualEffectView *BG_visualEfView;

@property (nonatomic, strong)UIImage* tempImage;

@property (nonatomic, strong) UIButton *SetWhite;


@end
