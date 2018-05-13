//
//  WritingLayoutViewController.h
//  atomemory
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "appStat.h"
#import "picture.h"
#import "diary.h"
#import "photoCollectionViewCell.h"
#import "DNavigationController.h"
#import "UIImage+Extension.h"
#import "NSArray+HSSafeAccess.h"
#import "TZImagePickerController.h"
#import "WJTextView.h"
#import "ZSTextViewCell.h"
#import "UIViewController+GFVoiceKeyboard.h"
#import "UITextView+GFVoiceKeyboard.h"



@interface WritingLayoutViewController : UIViewController
@property(nonatomic, strong)UIButton* bn;
@property(nonatomic, strong)UIButton* pbn;
@property(nonatomic, strong)UIButton* mbn;
//@property (nonatomic, strong) WJTextView *textView;
@property (nonatomic, strong) UITextView* textView;

@property (nonatomic, copy)UIImageView* BG;

@property (nonatomic, strong)NSMutableArray* storeData;
@property (nonatomic, strong)UITableView* storeTable;

@property(nonatomic,strong)picture* tmp;
@property (nonatomic, copy)NSString* today;

@end
