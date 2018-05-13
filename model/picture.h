//
//  picture.h
//  atomemory
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RLMObject.h"

@interface picture : RLMObject

@property (nonatomic, copy) NSData *content;
@property (nonatomic, copy) NSString *PicId;

@end
