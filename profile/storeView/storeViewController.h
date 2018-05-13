//
//  storeViewController.h
//  atomemory
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Extension.h"
#import "NSArray+HSSafeAccess.h"
#import "SDCycleScrollView.h"
#import "storeView.h"
#import "StoreTableViewCell.h"
#import "DPushViewController.h"

@interface storeViewController : DPushViewController


@property (nonatomic, copy)storeView* sv;
@property (nonatomic, strong)NSMutableArray* storeData;
@property (nonatomic, strong)UITableView* storeTable;


@end
