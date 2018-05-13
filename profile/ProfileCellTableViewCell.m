//
//  ProfileCellTableViewCell.m
//  atomemory
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProfileCellTableViewCell.h"
#import "UIImage+Extension.h"


@interface ProfileCellTableViewCell ()
/** 1.图片 */
@property (nonatomic, weak) UIImageView *iconView;
/** 2.标题 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 3.subTitle */
@property (nonatomic, weak) UILabel *subtitle;
/** 4.箭头 */
@property (nonatomic, weak) UIImageView *arrowView;
@end

@implementation ProfileCellTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//创建cell的类方法
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 创建cell
    static NSString *ID = @"ProfileCellTableViewCell";
    ProfileCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[ProfileCellTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// cell创建方法2
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化操作
        [self setupSubviews];
    }
    return self;
}


/**
 *  初始化子控件
 */
- (void)setupSubviews {
    /** 1.图片 */
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 2.标题
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 3.描述 */
    UILabel *subtitle = [[UILabel alloc] init];
    subtitle.textColor = [UIColor colorWithRed:151 / 255.0 green:151 / 255.0 blue:151 / 255.0 alpha:1.0];
    subtitle.font = [UIFont systemFontOfSize:12];
    subtitle.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:subtitle];
    self.subtitle = subtitle;
    
    /** 4.箭头 */
    UIImageView *arrowView = [[UIImageView alloc] init];
    arrowView.image = [UIImage imageNamed:@"caret_right"];
    [self.contentView addSubview:arrowView];
    self.arrowView = arrowView;
}

/**
 * 设置子控件的frame
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentW = self.contentView.bounds.size.width;
    CGFloat contentH = self.contentView.bounds.size.height;
    /** 1.图片 */
    CGFloat iconViewX = 15;
    CGFloat iconViewY = 0;
  //  CGFloat iconViewW = 44;
    CGFloat iconViewW = SCREENW/13;
    CGFloat iconViewH = SCREENW/13;
//    CGFloat iconViewH = contentH;
    self.iconView.frame = CGRectMake(iconViewX, (contentH-iconViewH)/2, iconViewW, iconViewH);
    
    /** 2.标题 */
    CGFloat nameLabelX = CGRectGetMaxX(self.iconView.frame) + 10;
    CGFloat nameLabelY = 0;
    CGFloat nameLabelW = contentW - nameLabelX;
    CGFloat nameLabelH = contentH;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    /** 4.箭头 */
    CGFloat arrowViewW = 14;
    CGFloat arrowViewX = contentW - 15 - arrowViewW;
    CGFloat arrowViewH = 14;
    CGFloat arrowViewY = (contentH - arrowViewH) / 2;
    self.arrowView.frame = CGRectMake(arrowViewX, arrowViewY, arrowViewW, arrowViewH);
    
    /** 3.子标题 */
    CGFloat subtitleW = 150;
    CGFloat subtitleX = CGRectGetMinX(self.arrowView.frame) - 10 - subtitleW;
    CGFloat subtitleY = 0;
    CGFloat subtitleH = contentH;
    self.subtitle.frame = CGRectMake(subtitleX, subtitleY, subtitleW, subtitleH);
}

- (void)setItem:(DCommenItem *)item {
    _item = item;
    UIImage* itemimage=[UIImage imageNamed:item.icon];
    self.iconView.image = [itemimage TransformtoSize:CGSizeMake(SCREENW/13, SCREENW/13)];
    self.nameLabel.text = item.title;
    self.subtitle.text = item.subtitle;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
