//
//  ProfileCellTableViewCell.h
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCommenItem.h"

@interface ProfileCellTableViewCell : UITableViewCell
/** item */
@property (nonatomic, strong) DCommenItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
