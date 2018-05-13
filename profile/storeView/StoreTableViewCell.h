//
//  StoreTableViewCell.h
//  atomemory
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "JDLAlertView.h"
#import "UIImage+Extension.h"
#import "StoreCommenItem.h"

@interface StoreTableViewCell : UITableViewCell <SKPaymentTransactionObserver,SKProductsRequestDelegate>

#define picH SCREENW/4
#define labelH 10
#define gap 10

@property (nonatomic,strong) StoreCommenItem* item;
@property (nonatomic, strong) NSMutableArray* productID;
@property (nonatomic, strong) UIViewController* rootViewController;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
