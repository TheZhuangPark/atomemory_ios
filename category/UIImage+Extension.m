//
//  UIImage+Extension.m
//  atomemory
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
-(UIImage*)TransformtoSize:(CGSize)Newsize
{
    
    // 创建一个bitmap的context
    
    UIGraphicsBeginImageContext(Newsize);
    
    // 绘制改变大小的图片
    
    [self drawInRect:CGRectMake(0,0, Newsize.width, Newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage*TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return TransformedImg;
    
}



@end
