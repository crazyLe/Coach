//
//  EditFourthTableCell.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EditFourthTableCell.h"

@implementation EditFourthTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView IDstr:(NSString *)str{
    
    NSString *ID = str;
    EditFourthTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EditFourthTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 11)];
    lineLabel.backgroundColor = rgb(239, 238, 239);
    [self.contentView addSubview:lineLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineLabel.frame)+21, 60, 15)];
    _messageLabel.font = Font15;
    _messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_messageLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(lineLabel.frame)+21, kScreenWidth-80-24-10, 15)];
    _contentLabel.font = Font15;;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_contentLabel];
    
    _accessoryImageView = [[UIImageView alloc] init];
    _accessoryImageView.frame = CGRectMake(kScreenWidth - 24,  CGRectGetMaxY(lineLabel.frame)+21, 12, 15);
    _accessoryImageView.image = [UIImage imageNamed:@"card_arrow"];
    _accessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_accessoryImageView];
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, self.frame.size.height-0.5, kScreenWidth-12*2, 0.5)];
    lineLabel.backgroundColor = kLineWhiteColor;
    [self.contentView addSubview:lineLabel];
    
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
