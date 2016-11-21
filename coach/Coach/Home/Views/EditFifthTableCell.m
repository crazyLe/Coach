//
//  EditFifthTableCell.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EditFifthTableCell.h"

#define HCoachWidth  kScreenWidth/375.0

@implementation EditFifthTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView IDstr:(NSString *)str{
    
    NSString *ID = str;
    EditFifthTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EditFifthTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
//    CGFloat padding = 5;
    
//    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(14, padding +5, 24, 24)];
//    _iconView.userInteractionEnabled = YES;
//    _iconView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_iconView];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 21, 100, 15)];
    _messageLabel.font = Font14;
    _messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_messageLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, 21, 120-14, 15)];
    _contentLabel.font = Font14;;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = [UIColor colorWithHexString:@"#626262"];
    [self.contentView addSubview:_contentLabel];
    
    _accessoryImageView = [[UIImageView alloc] init];
    _accessoryImageView.frame = CGRectMake(kScreenWidth - 24, 21, 12, 15);
    _accessoryImageView.image = [UIImage imageNamed:@"card_arrow"];
    _accessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_accessoryImageView];
    
//    NSArray * imageArr = @[@"MCoach_click",@"MCoach_click",@"MCoach_click"];
    
    _photoImageArr = [NSMutableArray array];
    
//    for (int i=0; i<3; i++) {
    for (int i=0; i<3; i++) {
        UIImageView * photoImage = [[UIImageView alloc]initWithFrame:CGRectMake((11+(113+6)*i)*HCoachWidth, CGRectGetMaxY(_messageLabel.frame)+19, 113*HCoachWidth, 113*HCoachWidth)];
//        photoImage.image = [UIImage imageNamed:_photoImageArr[i]];
//        [photoImage sd_setImageWithURL:[NSURL URLWithString:_photoImageArr[i]] placeholderImage:[UIImage imageNamed:imageArr[i]]];
        [self.contentView addSubview:photoImage];
        photoImage.tag = 10 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoImg:)];
        [photoImage addGestureRecognizer:tap];
        photoImage.userInteractionEnabled = YES;
        [_photoImageArr addObject:photoImage];
    }
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake((kScreenWidth-180)/2, CGRectGetMaxY(_messageLabel.frame)+19+113*HCoachWidth+32, 180, 40);
//    [saveBtn setBackgroundImage:[UIImage imageNamed:@"card_BlueRectangle"] forState:UIControlStateNormal];
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"#2e83ff"];
    saveBtn.layer.cornerRadius = 20.0;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(clickPressBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:saveBtn];
    
}

- (void)tapPhotoImg:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(EditFifthTableCell:clickPhotoImg:)]) {
        [_delegate EditFifthTableCell:self clickPhotoImg:tap.view];
    }
}

- (void)clickPressBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickEditFifthTableCellSaveBtn)])
    {
        [self.delegate clickEditFifthTableCellSaveBtn];
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
