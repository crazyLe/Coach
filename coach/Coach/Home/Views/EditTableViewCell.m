//
//  EditTableViewCell.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EditTableViewCell.h"

@implementation EditTableViewCell

//+ (instancetype)cellWithTableView:(UITableView *)tableView{
//    
//    NSString *ID = @"EditTableViewCell";
////    EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (!cell) {
//        cell = [[EditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    return cell;
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        [self setNeedsLayout];
//        
//        [self layoutIfNeeded];
        
//        CGFloat padding = 5;
        
//        _iconView = [[UIImageView alloc] init];
//        _iconView.userInteractionEnabled = YES;
//        _iconView.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:_iconView];
//        _iconView.frame = CGRectMake(14, padding + 3+2, 28-4, 28-4);
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = Font15;
        _messageLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_messageLabel];
        _messageLabel.frame = CGRectMake(15, 21, 100, 15);
        
        
        _contentLabel = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth-150-15, 21, 150-24-10, 15)];
        _contentLabel.font = Font15;;
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = [UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_contentLabel];
        
        _unitLbl = [UILabel new];
        [self.contentView addSubview:_unitLbl];
        WeakObj(_contentLabel)
        [_unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_contentLabelWeak);
            make.right.equalTo(_contentLabelWeak).offset(15);
            make.width.offset(15);
        }];
        _unitLbl.userInteractionEnabled = YES;
        _unitLbl.textAlignment = NSTextAlignmentRight;
        _unitLbl.textColor = _contentLabel.textColor;
        _unitLbl.font = _contentLabel.font;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [_contentLabel becomeFirstResponder];
        }];
        [_unitLbl addGestureRecognizer:tap];
        
        _accessoryImageView = [[UIImageView alloc] init];
        _accessoryImageView.frame = CGRectMake(kScreenWidth - 24, 21, 12, 15);
        _accessoryImageView.image = [UIImage imageNamed:@"card_arrow"];
        _accessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_accessoryImageView];
        
        [_contentLabel addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, self.frame.size.height-0.5, kScreenWidth-12*2, 0.5)];
    _lineLabel.backgroundColor = kLineWhiteColor;
    [self.contentView addSubview:_lineLabel];
    
}

- (void)setCoachModel:(CardCoachModel *)coachModel
{
    _coachModel = coachModel;
    _contentLabel.tag = _index +1;
    switch (_index) {
        case 0:
            _contentLabel.text = coachModel.trueName;
            break;
        case 2:
            if([coachModel.sex isEqualToString:@"1"]){
                _contentLabel.text = @"男";
            }else if ([coachModel.sex isEqualToString:@"0"]){
                _contentLabel.text = @"女";
            }
            break;
        case 3:
            _contentLabel.text = coachModel.phone;
            break;
        case 4:
//            _contentLabel.text = @"请选择";
            _contentLabel.text = coachModel.selectedSchool;
            break;
        case 5:
//            _contentLabel.text = [NSString stringWithFormat:@"%@年",coachModel.age];
            _contentLabel.text = coachModel.age;
            _unitLbl.text = @"岁";
            break;
        case 6:
//            _contentLabel.text = [NSString stringWithFormat:@"%@%@",coachModel.dage,[coachModel.dage rangeOfString:@"年"].location != NSNotFound?@"":@"年"];
            _contentLabel.text = coachModel.dage;
            _unitLbl.text = @"年";
            break;
        case 7:
//            _contentLabel.text = [NSString stringWithFormat:@"%@%@",coachModel.tage,[coachModel.tage rangeOfString:@"年"].location != NSNotFound?@"":@"年"];
            _contentLabel.text = coachModel.tage;
            _unitLbl.text = @"年";
            break;
        case 8:
//            _contentLabel.text = [NSString stringWithFormat:@"%@%@",coachModel.students,[coachModel.students rangeOfString:@"人"].location != NSNotFound?@"":@"人"];
            _contentLabel.text = coachModel.students;
            _unitLbl.text = @"人";
            break;
        case 9:
//            _contentLabel.text = [NSString stringWithFormat:@"%@%@",coachModel.average,[coachModel.average rangeOfString:@"天"].location != NSNotFound?@"":@"天"];
            _contentLabel.text = coachModel.average;
            _unitLbl.text = @"天";
            break;
        case 10:
//            _contentLabel.text = [NSString stringWithFormat:@"%@%@",coachModel.percent2,[coachModel.percent2 rangeOfString:@"%"].location != NSNotFound?@"":@"%"];
            _contentLabel.text = coachModel.percent2;
            _unitLbl.text = @"%";
            break;
        case 11:
//            _contentLabel.text = [NSString stringWithFormat:@"%@%@",coachModel.percent3,[coachModel.percent3 rangeOfString:@"%"].location != NSNotFound?@"":@"%"];
            _contentLabel.text = coachModel.percent3;
            _unitLbl.text = @"%";
            break;
        default:
            break;
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

- (void)textFieldDidChanged:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(EditTableViewCell:textFieldDidChanged:)]) {
        [_delegate EditTableViewCell:self textFieldDidChanged:textField];
    }
}

@end
