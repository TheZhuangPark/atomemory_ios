//
//  TextViewCell.m
//  cell输入刷新高度
//
//  Created by 张帅 on 17/3/1.
//  Copyright © 2017年 张帅. All rights reserved.
//

#import "ZSTextViewCell.h"
#define SCREEN  [UIScreen mainScreen].bounds.size
@implementation ZSTextViewCell {
    UILabel * titleLabel;
    UITextView* _textView;
    UILabel * placeholderLabel;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self uiConfigure];
    }
    return self;
}
- (void)uiConfigure {
/*    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    titleLabel.text=@"内容:";
    titleLabel.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];*/
    
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, 44)];
    _textView.delegate=self;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.font=[UIFont systemFontOfSize:18];
    _textView.scrollEnabled=NO;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.returnKeyType=UIReturnKeyDone;
    _textView.keyboardType=UIKeyboardTypeDefault;
  
    //  _textView.backgroundColor=[UIColor clearColor];
    _textView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0];
    _textView.layer.masksToBounds=YES;
    _textView.layer.cornerRadius=SCREEN.width/16;
    // 设置提示文字
   // _textView.placehoder = @"输入";
    // 设置提示文字颜色
   // _textView.placehoderColor = [UIColor grayColor];
    // 设置textView的字体
    _textView.font = [UIFont systemFontOfSize:18];
    
  /*  UIView *dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.width, 40)];
    dismissView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN.width-50, 0, 40, 40)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [dismissView addSubview:button];
    _textView.inputAccessoryView = dismissView;*/
    [self.contentView addSubview:_textView];

    placeholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    placeholderLabel.text=@"请输入内容";
    placeholderLabel.textColor=[UIColor lightGrayColor];
    placeholderLabel.font=[UIFont systemFontOfSize:18];
    [_textView addSubview:placeholderLabel];
}

/*
- (void)dismissButtonAction {
    [_textView resignFirstResponder];
}*/

- (void)setContentStr:(NSString *)contentStr {
    _contentStr=contentStr;
    _textView.text=_contentStr;
}
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath=indexPath;
}
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder=placeholder;
    placeholderLabel.text=_placeholder;
}
- (CGFloat)CellHeight {
    CGSize size = [_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, MAXFLOAT)];
    return size.height+5;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length==0) {
        placeholderLabel.hidden=NO;
    } else {
        placeholderLabel.hidden=YES;
    }
    if ([self.delegate respondsToSelector:@selector(updatedText:atIndexPath:)]) {
        [self.delegate updatedText:textView.text atIndexPath:_indexPath];
    }
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [_tableView beginUpdates];
    [_tableView endUpdates];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
