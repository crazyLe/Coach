//
//  ExamHeaderView.m
//  Coach
//
//  Created by gaobin on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamHeaderView.h"

@implementation ExamHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    
        UILabel * timeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 30, 15)];
        timeLab.text = @"时段";
        timeLab.font = [UIFont systemFontOfSize:15];
        timeLab.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
        [self addSubview:timeLab];
        
        UILabel * carTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 60, 30, 15)];
        carTypeLab.text = @"车型";
        carTypeLab.font = [UIFont systemFontOfSize:15];
        carTypeLab.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
        [self addSubview:carTypeLab];
        
        _fromTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fromTimeBtn.backgroundColor = [UIColor colorWithHexString:@"#fcfcfc"];
        [_fromTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -65 * AutoSizeScaleX, 0, 0)];
        [_fromTimeBtn setTitle:@"00:00" forState:UIControlStateNormal];
        [_fromTimeBtn setTitleColor:[UIColor colorWithHexString:@"#2f82ff"] forState:UIControlStateNormal];
        _fromTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_fromTimeBtn addTarget:self action:@selector(fromTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_fromTimeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#b0b0b0"].CGColor];
        [_fromTimeBtn.layer setBorderWidth:.5];
        _fromTimeBtn.layer.cornerRadius = 15;
        _fromTimeBtn.clipsToBounds = YES;
        [self addSubview:_fromTimeBtn];
        [_fromTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLab);
            make.left.equalTo(timeLab.mas_right).offset(16);
            make.width.offset((kScreenWidth - 110)/2);
            make.height.offset(30);
        }];
        
        UILabel * zhiLab = [[UILabel alloc] init];
        zhiLab.text = @"至";
        zhiLab.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
        zhiLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:zhiLab];
        [zhiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fromTimeBtn.mas_right).offset(10);
            make.centerY.equalTo(_fromTimeBtn);
        }];
        
        _toTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _toTimeBtn.backgroundColor = [UIColor colorWithHexString:@"#fcfcfc"];
        [_toTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -65 * AutoSizeScaleX, 0, 0)];
        [_toTimeBtn setTitleColor:[UIColor colorWithHexString:@"#2f82ff"] forState:UIControlStateNormal];
        _toTimeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_toTimeBtn setTitle:@"24:00" forState:UIControlStateNormal];
        [_toTimeBtn addTarget:self action:@selector(toTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _toTimeBtn.layer.cornerRadius = 15;
        _toTimeBtn.clipsToBounds = YES;
        [_toTimeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#b0b0b0"].CGColor];
        [_toTimeBtn.layer setBorderWidth:.5];
        [self addSubview:_toTimeBtn];
        [_toTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(zhiLab.mas_right).offset(10);
            make.centerY.equalTo(zhiLab);
            make.width.offset((kScreenWidth - 110)/2);
            make.height.offset(30);
        }];

        _carTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _carTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#fcfcfc"];
        [_carTypeBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_carTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -245 * AutoSizeScaleX, 0, 0)];
        [_carTypeBtn setTitleColor:[UIColor colorWithHexString:@"#2f82ff"] forState:UIControlStateNormal];
        _carTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _carTypeBtn.layer.cornerRadius = 15;
        _carTypeBtn.clipsToBounds = YES;
        [_carTypeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#b0b0b0"].CGColor];
        [_carTypeBtn.layer setBorderWidth:.5];
        [_carTypeBtn addTarget:self action:@selector(carTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_carTypeBtn];
        [_carTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_fromTimeBtn.mas_left);
            make.centerY.equalTo(carTypeLab);
            make.right.offset(-15);
            make.height.offset(30);
        }];
        
        UIImageView * triangleImgView = [[UIImageView alloc] init];
        triangleImgView.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
        [_carTypeBtn addSubview:triangleImgView];
        [triangleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_carTypeBtn);
            make.right.offset(-15);
        }];
        
    }
    return self;
    
}
- (void)fromTimeBtnClick {
    
    if ([_delegate respondsToSelector:@selector(headerReusableView:didClickBtnWithType:)]) {
        
        [_delegate headerReusableView:self didClickBtnWithType:HeaderButtonTypeFrom];
    }
    
    
}
-(void)toTimeBtnClick
{
    
    if ([self.delegate respondsToSelector:@selector(headerReusableView:didClickBtnWithType:)]) {
        [self.delegate headerReusableView:self didClickBtnWithType:HeaderButtonTypeTo];
    }
    
    
}
-(void)carTypeBtnClick
{
    
    if ([self.delegate respondsToSelector:@selector(headerReusableView:didClickBtnWithType:)]) {
        [self.delegate headerReusableView:self didClickBtnWithType:HeaderButtonTypeCarType];
    }
    
    
}
@end
