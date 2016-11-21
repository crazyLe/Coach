//
//  RentCollectionViewCell.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kImgViewleftOffset 10

#import "RentCollectionViewCell.h"

@implementation RentCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self setConstrants];
        [self setAttributes];
    }
    return self;
}
 
- (void)setUI
{
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    
    _imgView = [UIImageView new];
    [self.contentView addSubview:_imgView];
    
    _symbolImgView = [UIImageView new];
    [self.contentView addSubview:_symbolImgView];
    
    _priceLbl = [UILabel new];
    [self.contentView addSubview:_priceLbl];
    
    _areaLbl = [UILabel new];
    [self.contentView addSubview:_areaLbl];
    
    _infoLbl = [UILabel new];
    [self.contentView addSubview:_infoLbl];
    
    _remainLbl = [UILabel new];
    [self.contentView addSubview:_remainLbl];
}

- (void)setConstrants
{
    WeakObj(_imgView)
    WeakObj(_priceLbl)
    WeakObj(_infoLbl)
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(kImgViewleftOffset);
        make.right.offset(-kImgViewleftOffset);
        make.width.equalTo(_imgViewWeak.mas_height);
    }];
    
    [_symbolImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_imgViewWeak).offset(10);
        make.width.height.offset(30);
    }];
    
    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgViewWeak.mas_bottom);
        make.left.equalTo(_imgViewWeak);
        make.height.offset(40);
        make.width.equalTo(_imgViewWeak).multipliedBy(0.55);
    }];
    
    [_areaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLblWeak.mas_right);
        make.top.height.equalTo(_priceLblWeak);
        make.right.offset(-kImgViewleftOffset);
    }];
    
    [_infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLblWeak.mas_bottom).offset(-10);
        make.left.equalTo(_priceLblWeak);
        make.right.offset(-kImgViewleftOffset);
        make.height.offset(25);
    }];
    
    [_remainLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgViewWeak.mas_right);
        make.height.offset(20);
        make.top.equalTo(_infoLblWeak.mas_bottom);
        make.width.offset(65);
    }];
}

- (void)setAttributes
{
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _priceLbl.textColor = [UIColor colorWithHexString:@"4c4c4c"];
    _priceLbl.font = [UIFont boldSystemFontOfSize:15];
    
    _infoLbl.textColor = _priceLbl.textColor;
    _infoLbl.font = Font12;
    _infoLbl.numberOfLines = 0;
    
    _areaLbl.font = _infoLbl.font;
    _areaLbl.textColor = _infoLbl.textColor;
    _areaLbl.textAlignment = NSTextAlignmentRight;
    
    _remainLbl.font = _infoLbl.font;
    _remainLbl.textColor = [UIColor colorWithHexString:@"2e82ff"];
    _remainLbl.textAlignment = NSTextAlignmentCenter ;
    _remainLbl.layer.masksToBounds = YES;
    _remainLbl.layer.cornerRadius = 10;
    _remainLbl.backgroundColor = rgb(220, 233, 243);
}

- (void)setContentWithType:(RentCollectionViewCellType)type
{
    _type = type;
    
    if (_type == RentCollectionViewCellTypeCoachRent) {
        //教练车租赁
//        WeakObj(_imgView)
//        [_infoLbl mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_imgViewWeak).offset(-55);
//        }];
         _remainLbl.hidden = NO;
        _areaLbl.hidden = YES;
    }
    else
    {
        _remainLbl.hidden = YES;
        _areaLbl.hidden = NO;
        [_infoLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
        }];
    }
}

@end
