//
//  photoCollectionViewCell.m
//  atomemory
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "photoCollectionViewCell.h"

@implementation photoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height)];
        _image.layer.masksToBounds=YES;
        _image.layer.cornerRadius=self.bounds.size.width/16;
        
        [self.contentView addSubview:_image];
        
        
        CGFloat totalWidth = self.frame.size.width;
       // CGFloat totalHeight = self.frame.size.height;
        //btn
        _btnDelete = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnDelete.frame = CGRectMake(totalWidth-20, 0, 20, 20);
        _btnDelete.backgroundColor = [UIColor redColor];
        [_btnDelete setTitle:@"X" forState:UIControlStateNormal];
        [self addSubview:_btnDelete];
        
    }
    return self;
    
}

-(void)setNeedsDisplay
{
    CGFloat totalWidth = self.frame.size.width;
    _btnDelete.frame = CGRectMake(totalWidth-20, 0, 20, 20);
    
}
-(void)drawRect:(CGRect)rect
{
    
}
@end
