//
//  WritingViewController.h
//  podtext
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "diary.h"
#import <Realm/Realm.h>


@interface WritingViewController : UIViewController
@property(atomic,strong)UITextView* textView;
@property(atomic,strong)UIButton* bn;
@property(nonatomic,copy)NSString* today;
@property(atomic,strong)UILabel* chosenday;

@end
