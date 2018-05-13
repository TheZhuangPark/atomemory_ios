//
//  UITextField+GFVoiceKeyboard.h
//  gf_testVoice
//
//  Created by gaof on 2017/6/15.
//  Copyright © 2017年 gaof. All rights reserved.
/*
 一个属性
 @property (nonatomic,assign)IBInspectable BOOL enableVoiceKeyboard;

 6个方法
 -(void)setEnableVoiceKeyboard:(BOOL)enableVoiceKeyboard{
 -(BOOL)enableVoiceKeyboard {
 -(void)switchKeyboard:(BOOL)isVoiceKeyboard;
 -(void)voiceToolBarSwitchDidClick:(UIButton *)sender {
 -(void)voiceKeyboardDidDismiss {
 -(void)voiceKeyboardDidRecognitionResult:(NSString *)result {
 */

#import <UIKit/UIKit.h>

@interface UITextField (GFVoiceKeyboard)
/**
 是否开启语音键盘 默认为NO
 */

@property (nonatomic,assign)IBInspectable BOOL enableVoiceKeyboard;

@end
