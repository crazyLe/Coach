//
//  WindfallSecondCell.m
//  Coach
//
//  Created by apple on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "WindfallSecondCell.h"

#import "WFCustomCollectCell.h"

static NSString *cellReuseID = @"WFCustomCollectReuseID";
@interface WindfallSecondCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _customCollectView;
    
}

@end

@implementation WindfallSecondCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake((kScreenWidth-40)/3.0, 65);
    layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 0;
    
    _customCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layOut];
    _customCollectView.delegate = self;
    _customCollectView.dataSource = self;
    _customCollectView.backgroundColor = [UIColor whiteColor];
    _customCollectView.showsHorizontalScrollIndicator = NO;
    _customCollectView.scrollEnabled = NO;
    [self addSubview:_customCollectView];
    
    [_customCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
    [_customCollectView registerClass:[WFCustomCollectCell class] forCellWithReuseIdentifier:cellReuseID];
    //    [_windfallCollectView registerNib:[UINib nibWithNibName:@"EarnOrdinaryCell" bundle:nil] forCellWithReuseIdentifier:cellReuseID];
    
    
}

#pragma mark -- collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
//    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WFCustomCollectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor brownColor];
//    cell.layer.cornerRadius = 5.0;
//    cell.layer.borderWidth = 1;
//    cell.layer.borderColor = [[UIColor colorWithHexString:@"#5cb6ff"] CGColor];
    cell.appointModel = _dataArray[indexPath.item];
    cell.clipsToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
    EarnAppointModel * model = _dataArray[indexPath.item];
    if (_delegate && [_delegate respondsToSelector:@selector(windfallSecondCell:withIndex:withState:)]) {
        [_delegate windfallSecondCell:self withIndex:indexPath.item withState:model.state];
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_customCollectView reloadData];
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
