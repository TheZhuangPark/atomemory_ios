//
//  diary.h
//  podtext
//
//  Created by apple on 2017/7/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Realm/Realm.h>

@interface diary : RLMObject


@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *diarydate;
//RLM_ARRAY_TYPE(diary)
//RLM_ARRAY_TYPE(diary)

@end
