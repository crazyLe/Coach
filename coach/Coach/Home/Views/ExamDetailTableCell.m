//
//  ExamDetailTableCell.m
//  Coach
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamDetailTableCell.h"

@implementation ExamDetailTableCell

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
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(14, padding +5, 24, 24)];
    _iconView.userInteractionEnabled = YES;
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconView];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(14 + 34, 2 * padding, 60, 24)];
    _messageLabel.font = Font14;
    _messageLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
//    _messageLabel.backgroundColor = [UIColor brownColor];
    [self.contentView addSubview:_messageLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_messageLabel.frame)+5, 2*padding, 100, 24)];
    _contentLabel.font = Font14;;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = [UIColor colorWithHexString:@"#626262"];
//    _contentLabel.backgroundColor = [UIColor magentaColor];
    [self.contentView addSubview:_contentLabel];
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
