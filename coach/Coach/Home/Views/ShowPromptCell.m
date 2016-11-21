//
//  ShowPromptCell.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kSideOffset 25

#import "ShowPromptCell.h"

@implementation ShowPromptCell

- (void)setUI
{
    _contentLbl = [UILabel new];
    [self.contentView addSubview:_contentLbl];
    
//    _smallLblArr = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 4; i++) {
//        UILabel *smallLbl = [UILabel new];
//        [self.contentView addSubview:smallLbl];
//        [_smallLblArr addObject:smallLbl];
//    }
    
    _titleLbl = [UILabel new];
    [self.contentView addSubview:_titleLbl];
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_contentLbl)
//    WeakObj(_smallLblArr)
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(selfWeak);
        make.width.offset(kScreenWidth-kSideOffset*3);
        make.height.equalTo(selfWeak).multipliedBy(0.7);
    }];
    
//    int i = 0;
//    for (UILabel *smallLbl in _smallLblArr) {
//        [smallLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_contentLblWeak.mas_top);
//            if (i==0||i==1) {
//                make.right.equalTo(i==0 ? _contentLblWeak.mas_centerX
//                                   :((UILabel *)_smallLblArrWeak[0]).mas_left).offset(i==0?-2.5:-5);
//            }
//            else
//            {
//                make.left.equalTo(i==2 ? _contentLblWeak.mas_centerX
//                                   :((UILabel *)_smallLblArrWeak[2]).mas_right).offset(i==2?2.5:5);
//            }
//            make.width.height.equalTo(_contentLblWeak.mas_height).multipliedBy(0.3);
//        }];
//        i++;
//    }
//    
//    [_smallLblArr exchangeObjectAtIndex:0 withObjectAtIndex:1];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_contentLblWeak.mas_top);
        make.height.offset(30);
        make.width.centerX.equalTo(_contentLblWeak);
    }];
}

- (void)setAttributes
{
    _contentLbl.textAlignment = NSTextAlignmentCenter;
    _contentLbl.font = Font13;
    _contentLbl.textColor = [UIColor colorWithHexString:@"999999"];
//    _contentLbl.layer.cornerRadius = 5;
//    _contentLbl.layer.masksToBounds = YES;
    _contentLbl.numberOfLines = 0;
//    _contentLbl.backgroundColor = [UIColor colorWithHexString:@"0Xfefdf4"];
//    _contentLbl.layer.borderWidth = 1;
//    _contentLbl.layer.borderColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:240/255.0 alpha:1].CGColor;
    
    
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.textColor = kAppThemeColor;
    _titleLbl.font = kFont15;
//    for (UILabel *smallLbl in _smallLblArr) {
//        smallLbl.textAlignment = NSTextAlignmentCenter;
//        smallLbl.font = Font16;
//        smallLbl.textColor = [UIColor colorWithHexString:@"2e83ff"];
//        smallLbl.backgroundColor = [UIColor colorWithHexString:@"0Xfefdf4"];
//        smallLbl.layer.borderColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:240/255.0 alpha:1].CGColor;
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    for (UILabel *smallLbl in _smallLblArr) {
//        smallLbl.layer.cornerRadius = smallLbl.frame.size.width/2;
//        smallLbl.layer.masksToBounds = YES;
//    }
}

@end
