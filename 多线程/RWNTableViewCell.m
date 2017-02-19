//
//  RWNTableViewCell.m
//  多线程
//
//  Created by RWN on 17/2/18.
//  Copyright © 2017年 RWN. All rights reserved.
//

#import "RWNTableViewCell.h"

@interface RWNTableViewCell ()



@end

@implementation RWNTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imgView];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imgX = 10;
    CGFloat imgY = 10;
    CGFloat imgW = self.contentView.frame.size.width - imgX * 2.0;
    CGFloat imgH = self.contentView.frame.size.height - imgY * 2.0;
    self.imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
}

- (UIImageView *)imgView {
    if (!_imgView) {
        UIImageView *imgView = [UIImageView new];
        [self.contentView addSubview:imgView];
        _imgView = imgView;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
    }
    return _imgView;
}

@end
