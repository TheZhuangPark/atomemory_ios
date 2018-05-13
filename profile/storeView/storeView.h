//
//  storeView.h
//  atomemory
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Extension.h"
#import "UIColor+HSExtension.h"

@interface storeView : UIView

@property (nonatomic, strong)UITableView* storeTableView;
@property (nonatomic, strong)UINavigationBar* Navbar;
-(void) setupStoreTableView;
-(void) setupNavbar;



@end
