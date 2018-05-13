//
//  GFVoiceToolBar.h
//  gf_testVoice
//
//  Created by gaof on 2017/6/15.
//  Copyright © 2017年 gaof. All rights reserved.
/*
 一个属性
 @property (nonatomic,weak) id<GFVoiceToolBarDelegate> delegate;
 
 
 两个方法
 - (void)voiceToolBarSwitchDidClick:(UIButton *)sender;
 - (void)switchClick:(void(^)(UIButton *sender))block;

 */

#import <UIKit/UIKit.h>

@protocol GFVoiceToolBarDelegate <NSObject>
@optional
- (void)voiceToolBarSwitchDidClick:(UIButton *)sender;

@end
@interface GFVoiceToolBar : UIView
@property (nonatomic,weak) id<GFVoiceToolBarDelegate> delegate;
@property (nonatomic,strong) UITextView* tmp;
//+(instancetype)share;
- (void)switchClick:(void(^)(UIButton *sender))block;


@end
