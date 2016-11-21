//
//  VoucherTableCell.m
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "VoucherTableCell.h"

@implementation VoucherTableCell

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
    CGFloat padding = 5;
    
//    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(14, padding +5, 24, 24)];
//    _iconView.userInteractionEnabled = YES;
//    _iconView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_iconView];
    
//    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(14 + 34, 2 * padding, 100, 24)];
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(14 , 2 * padding, 100, 24)];
    _messageLabel.font = kFont15;
    _messageLabel.textColor = [UIColor colorWithHexString:@"#646464"];
    [self.contentView addSubview:_messageLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120-14-8-34, 3*padding, 120-14+34, 14)];
    _contentLabel.font = kFont15;;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    [self.contentView addSubview:_contentLabel];
    
    _accessoryImageView = [[UIImageView alloc] init];
    _accessoryImageView.frame = CGRectMake(kScreenWidth-13-18, 12, 20, 18);
    _accessoryImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_accessoryImageView];
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
