
//
//  UIViewController+GFVoiceKeyboard.m
//  gf_testVoice
//
//  Created by gaof on 2017/6/16.
//  Copyright © 2017年 gaof. All rights reserved.
/*
 一个属性
 @property (nonatomic,assign)IBInspectable BOOL enableVoiceKeyboard;

 
 
 9个方法
 -(void)setEnableVoiceKeyboard:(BOOL)enableVoiceKeyboard
 这个是注册通知， 移除通知，和移除键盘工具栏用的。当不使用voiceKB的时候就移除。
 
 -(void)registerNoti 注册通知
 - (void)removeNotiMethod
 这是动态添加了两个方法 gf,viewDidDisapear,用来移除通知
 
 
 - (void)GF_viewDidDisappear:(BOOL)animated
 循环启动 并且移除了通知
 
 -(void)textFieldViewDidBeginEditing:(NSNotification*)notification
 这是当触发到文字输入控件启动该方法
 
 -(void)addToolbarIfRequired:(UIView *)textFieldView
 这个是给文字输入控件 键盘加工具栏
 
 -(void)removeToolbarIfRequired
 这是移除键盘工具栏
 
 - (NSArray*)responderSiblings
 这个也不知道！
 
 
 -(BOOL)_IQcanBecomeFirstResponder:(UIView *)view
 这不知道，成为第一响应？
 
 
 p1 判断是否启用voicekb， 是则启动注册通知，移除通知。-> appdelegate -> viewDid
 p2 点击控件 -> 控件响应函数 -> 反复调用移除通知函数
 
 */

#import "UIViewController+GFVoiceKeyboard.h"
#import "UITextView+GFVoiceKeyboard.h"
#import "UITextField+GFVoiceKeyboard.h"
#import "GFVoiceToolBar.h"
#import <objc/runtime.h>

@implementation UIViewController (GFVoiceKeyboard)
-(void)setEnableVoiceKeyboard:(BOOL)enableVoiceKeyboard{
    if (enableVoiceKeyboard) {
        [self registerNoti];
        [self removeNotiMethod];
    }else{
        [self removeToolbarIfRequired];
    }
}




//不可再分类中重写dealloc 方法  不会调用super dealloc 方法 导致键盘没有被释放 应在子类中重写dealloc 方法释放通知
//https://stackoverflow.com/questions/33541122/ios9-keyboard-crash-on-dismiss
//动态添加方法 用于释放通知
- (void)removeNotiMethod {
    
    Class class = [self class];
    SEL originalSelector = @selector(viewDidDisappear:);
    SEL swizzledSelector = @selector(GF_viewDidDisappear:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}
- (void)GF_viewDidDisappear:(BOOL)animated {
    [self GF_viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
}

//-(void)dealloc
//{
//
//    //Removing notification observers on dealloc.
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
-(void)registerNoti {
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];

    

}
-(void)textFieldViewDidBeginEditing:(NSNotification*)notification{
    //  Getting object
    UIView *textFieldView = notification.object;
    if (textFieldView.inputAccessoryView == nil) {
        [self addToolbarIfRequired:textFieldView];
    }else{
        [textFieldView reloadInputViews];
    }
    
}

-(void)addToolbarIfRequired:(UIView *)textFieldView {
    if ([textFieldView respondsToSelector:@selector(setInputAccessoryView:)]) {
        if ([textFieldView isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)textFieldView;
            textField.enableVoiceKeyboard = YES;
        }
        else if ([textFieldView isKindOfClass:[UITextView class]]){
            UITextView *textView = (UITextView *)textFieldView;
            textView.enableVoiceKeyboard = YES;
        }
        [textFieldView reloadInputViews];
        
    }
}


-(void)removeToolbarIfRequired
{
    
    //	Getting all the sibling textFields.
    NSArray *siblings = [self responderSiblings];
    
    for (UITextField *textField in siblings)
    {
        UIView *toolbar = [textField inputAccessoryView];
        if ([textField respondsToSelector:@selector(setInputAccessoryView:)] &&
            ([toolbar isKindOfClass:[GFVoiceToolBar class]]))
        {
            textField.inputAccessoryView = nil;
        }
    }
}

- (NSArray*)responderSiblings
{
    
    NSArray *siblings = self.view.subviews;

    NSMutableArray *tempTextFields = [[NSMutableArray alloc] init];
    
    for (UIView *textField in siblings)
        if ([self _IQcanBecomeFirstResponder:textField]){
            [tempTextFields addObject:textField];
        }
    
    
    return tempTextFields;
}

-(BOOL)_IQcanBecomeFirstResponder:(UIView *)view
{
    BOOL _IQcanBecomeFirstResponder = NO;
    
    if ([self isKindOfClass:[UITextField class]])
    {
        _IQcanBecomeFirstResponder = [(UITextField*)self isEnabled];
    }
    else if ([self isKindOfClass:[UITextView class]])
    {
        _IQcanBecomeFirstResponder = [(UITextView*)self isEditable];
    }
    
    if (_IQcanBecomeFirstResponder == YES)
    {
        _IQcanBecomeFirstResponder = ([view isUserInteractionEnabled] && ![view isHidden] && [view alpha]!=0.0);
    }
    
    return _IQcanBecomeFirstResponder;
}


@end
