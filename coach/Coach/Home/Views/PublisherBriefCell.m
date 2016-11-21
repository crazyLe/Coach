//
//  PublisherBriefCell.m
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kSideOffset 10

#import "PublisherBriefCell.h"

@implementation PublisherBriefCell

- (void)setUI
{
    _leftImgView = [UIImageView new];
    [self.contentView addSubview:_leftImgView];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _rightLbl = [UILabel new];
    [self.contentView addSubview:_rightLbl];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rightBtn];
    
    _lineView = [UIView new];
    [self.contentView addSubview:_lineView];
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_leftImgView)
    WeakObj(_leftLbl)
    WeakObj(_rightBtn)
    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kSideOffset);
        make.centerY.equalTo(selfWeak);
        make.width.height.equalTo(selfWeak.mas_height).multipliedBy(0.3);
    }];
    
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImgViewWeak.mas_right).offset(5);
        make.centerY.equalTo(_leftImgViewWeak);
        make.height.equalTo(selfWeak);
        make.width.offset(50);
    }];
    
    [_rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.centerY.equalTo(_leftImgViewWeak);
        make.width.offset(kScreenWidth/1.5);
        make.height.equalTo(_leftLblWeak);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kSideOffset);
//        make.width.height.equalTo(selfWeak).multipliedBy(0.4);
        make.width.height.offset(30);
        make.centerY.equalTo(_leftImgViewWeak);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.equalTo(_leftImgViewWeak);
        make.right.equalTo(_rightBtnWeak);
        make.height.offset(kLineWidth);
    }];
}

- (void)setAttributes
{
    _leftLbl.textColor = [UIColor colorWithHexString:@"0X999999"];
    _leftLbl.font = Font14;
    
    _rightLbl.textColor = [UIColor colorWithHexString:@"0X646464"];
    _rightLbl.font = Font14;
    
    _lineView.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
}

@end
