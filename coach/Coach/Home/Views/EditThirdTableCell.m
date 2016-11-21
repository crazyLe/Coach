//
//  EditThirdTableCell.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EditThirdTableCell.h"
#import "EditCollectionCell.h"

//#define HCoachWidth  kScreenWidth/375.0

static NSString *identifier = @"EditCollectionCell";

@interface EditThirdTableCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@end

@implementation EditThirdTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView IDstr:(NSString *)str{
    
    NSString *ID = str;
    EditThirdTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EditThirdTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    _topLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 11)];
    _topLineLabel.backgroundColor = rgb(239, 238, 239);
    [self.contentView addSubview:_topLineLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_topLineLabel.frame)+21, 100, 15)];
    _messageLabel.font = Font15;
    _messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_messageLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120, CGRectGetMinY(_messageLabel.frame), 120-24-10, 15)];
    _contentLabel.font = Font15;;
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentLabelTap:)];
    [_contentLabel addGestureRecognizer:tap];
    _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_contentLabel];
    
    _accessoryImageView = [[UIImageView alloc] init];
    _accessoryImageView.frame = CGRectMake(kScreenWidth - 24, CGRectGetMinY(_messageLabel.frame), 12, 15);
    _accessoryImageView.image = [UIImage imageNamed:@"card_arrow"];
    _accessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_accessoryImageView];
    
    _lineLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_topLineLabel.frame)+57-0.5, kScreenWidth-12*2, 0.5)];
    _lineLab.backgroundColor = kLineWhiteColor;
    [self.contentView addSubview:_lineLab];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.itemSize = CGSizeMake((kScreenWidth-40)/3, 49);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _editCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _editCollectionView.dataSource = self;
    _editCollectionView.delegate = self;
    _editCollectionView.scrollEnabled = NO;
    _editCollectionView.backgroundColor = [UIColor whiteColor];
    [_editCollectionView registerClass:[EditCollectionCell class] forCellWithReuseIdentifier:identifier];
    [self.contentView addSubview:_editCollectionView];
    
    WeakObj(self)
    WeakObj(_lineLab)
    [_editCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineLabWeak.mas_bottom).offset(0);
        make.bottom.equalTo(selfWeak.mas_bottom).offset(-1);
        make.left.equalTo(selfWeak.mas_left).offset(0);
        make.right.equalTo(selfWeak.mas_right).offset(0);
    }];
    
    _selectTagArr = [NSMutableArray  array];
}

#pragma  mark --collectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_isCanSelect) {
        return _dataArray.count;
    }
    return ceilf(_dataArray.count/3.0)*3;
//    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.item>=_dataArray.count) {
        cell.tgaModel = nil;
        [cell.chooseBtn setTitle:@"其他标签" forState:UIControlStateNormal];
        [cell.chooseBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"card_white"] forState:UIControlStateNormal];
    }else{
        cell.index = indexPath.item;
        cell.tgaModel = _dataArray[indexPath.item];
    }
    
    if(_isCanSelect)
    {
        cell.chooseBtn.bounds = CGRectMake(0, 0, 80, 30);
        cell.chooseBtn.layer.cornerRadius = 15;
        cell.chooseBtn.layer.masksToBounds = YES;
//        [cell.chooseBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [cell.chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [cell.chooseBtn setTitleColor:kGrayHex99 forState:UIControlStateNormal];
        [cell.chooseBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"55b0fe"]] forState:UIControlStateSelected];
        [cell.chooseBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d4d4d4"]] forState:UIControlStateNormal];
        if ([_selectTagArr containsObject:cell.tgaModel]) {
            cell.chooseBtn.selected = YES;
        }
        else
        {
            cell.chooseBtn.selected = NO;
        }
    }
//    cell.backgroundColor = [UIColor redColor];
    cell.delegate = self;
    
//    cell.contentView.backgroundColor = [UIColor blueColor];
    return cell;
}

#pragma mark - EditCollectionCellDelegate

- (void)EditCollectionCell:(EditCollectionCell *)cell clickChooseBtn:(UIButton *)chooseBtn;
{
    if (_isCanSelect) {
        chooseBtn.selected = !chooseBtn.selected ;
        if (chooseBtn.selected) {
            [_selectTagArr addObject:cell.tgaModel];
        }
        else
        {
            if ([_selectTagArr containsObject:cell.tgaModel]) {
                [_selectTagArr removeObject:cell.tgaModel];
            }
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(EditThirdTableCell:clickChooseBtnWithCell:)]) {
            [_delegate EditThirdTableCell:self clickChooseBtnWithCell:cell];
        }
    }
}

#pragma mark --collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)contentLabelTap:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapEditThirdTableCellContent)])
    {
        [self.delegate tapEditThirdTableCellContent];
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
