//
//  MyStuTableCell.m
//  Coach
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "MyStuTableCell.h"
#define spacingSize (kScreenWidth-10-60-10-40-60-25-25-10-45-15)/3

@implementation MyStuTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithUI];
    }
    
    return self;
}

- (void)initWithUI
{
//    NSLog(@"%f",spacingSize);
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
//    _imageV.backgroundColor = [UIColor brownColor];
//    _imageV.image = [UIImage imageNamed:@"myStudents_avator"];
    _imageV.image = [UIImage imageNamed:@"myStudents_icon"];
    [self.contentView addSubview:_imageV];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageV.frame)+10, 30, 40, 20)];
    _nameLabel.text = @"钱辰";
    _nameLabel.font = Font18;
    _nameLabel.textColor = [UIColor colorWithHexString:@"#646464"];
//    _nameLabel.backgroundColor = [UIColor magentaColor];
    [self.contentView addSubview:_nameLabel];
    
    _unUseLabel =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame)+1, 40, 20)];
    _unUseLabel.text = @"未使用";
    _unUseLabel.font = Font12;
    _unUseLabel.textColor = RGBCOLOR(189, 189, 189);
//    _unUseLabel.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:_unUseLabel];
    
    _subjectsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame)+spacingSize, 40-10, 60, 20)];
    _subjectsLabel.text = @"科目二";
    _subjectsLabel.font = Font18;
    _subjectsLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    [self.contentView addSubview:_subjectsLabel];
    
    _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneBtn.frame = CGRectMake(CGRectGetMaxX(_subjectsLabel.frame)+spacingSize, 40-12.5, 25, 25);
//    _phoneBtn.backgroundColor = [UIColor yellowColor];
    [_phoneBtn setImage:[UIImage imageNamed:@"myStudents_dianhua"] forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(pressPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_phoneBtn];
    
    _optionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _optionsBtn.frame = CGRectMake(CGRectGetMaxX(_phoneBtn.frame)+spacingSize, 40-12.5, 25, 25);
//    _optionsBtn.backgroundColor = [UIColor redColor];
    [_optionsBtn setImage:[UIImage imageNamed:@"myStudents_shezhi"] forState:UIControlStateNormal];
    [_optionsBtn addTarget:self action:@selector(pressOptionsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_optionsBtn];
    
    _invitationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _invitationBtn.frame = CGRectMake(CGRectGetMaxX(_optionsBtn.frame)+10, 40-15, 45, 30);
    [_invitationBtn setTitle:@"邀请" forState:UIControlStateNormal];
    [_invitationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _invitationBtn.backgroundColor = [UIColor colorWithHexString:@"#6cc13d"];
    _invitationBtn.layer.cornerRadius = 5.0;
    _invitationBtn.titleLabel.font = Font14;
    [_invitationBtn addTarget:self action:@selector(pressInvitationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_invitationBtn];
    
}

- (void)pressPhoneBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneBtnClick:)])
    {
        [self.delegate phoneBtnClick:_index];
    }
}

- (void)pressOptionsBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(optionsBtnClick:)])
    {
        [self.delegate optionsBtnClick:_index];
    }
}

- (void)pressInvitationBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(invitationBtnClick:)])
    {
        [self.delegate invitationBtnClick:_index];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
