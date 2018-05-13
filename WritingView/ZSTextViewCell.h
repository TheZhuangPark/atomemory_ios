//
//  TextViewCell.h
//  cell输入刷新高度
//
//  Created by 张帅 on 17/3/1.
//  Copyright © 2017年 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZSTextViewCellDelegate <UITableViewDelegate>

@required
- (void)updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZSTextViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic,assign) CGFloat CellHeight;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) NSString * contentStr;
@property (nonatomic,strong) NSString * placeholder;
@property (nonatomic,assign)id<ZSTextViewCellDelegate> delegate;
@end
