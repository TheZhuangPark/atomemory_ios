//
//  TakePhotoTool.h
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//选取相册图片工具

typedef void (^sendPictureBlock)(UIImage *image);
@interface TakePhotoTool : NSObject
@property (nonatomic,copy)sendPictureBlock sPictureBlock;

+ (TakePhotoTool *)sharedModel;
+(void)sharePictureWith:(UIViewController *)controller andWith:(sendPictureBlock)block;

@end
