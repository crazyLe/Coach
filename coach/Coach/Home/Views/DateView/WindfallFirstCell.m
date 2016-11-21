//
//  WindfallFirstCell.m
//  Coach
//
//  Created by apple on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "WindfallFirstCell.h"
#import "WindfallCollectionCell.h"

static NSString *cellReuseID = @"windfallCollectReuseID";
@interface WindfallFirstCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _windfallCollectView;
}

@end

@implementation WindfallFirstCell

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor whiteColor] ;
//        [self initSubviews];
//    }
//    return self ;
//}

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
    layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layOut.itemSize = CGSizeMake((kScreenWidth-40)/3.0, 65);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 0;
    
    _windfallCollectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layOut];
//    _windfallCollectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _windfallCollectView.delegate = self;
    _windfallCollectView.dataSource = self;
    _windfallCollectView.backgroundColor = [UIColor whiteColor];
    _windfallCollectView.showsHorizontalScrollIndicator = NO;
//    _windfallCollectView.scrollEnabled = NO;
    [self addSubview:_windfallCollectView];
    
    [_windfallCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
    
    [_windfallCollectView registerClass:[WindfallCollectionCell class] forCellWithReuseIdentifier:cellReuseID];
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
//    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WindfallCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];

//    if ([_dataArray[indexPath.item] isEqualToString:@""]) {
//        
//    }else{
        cell.appointModel = _dataArray[indexPath.item];
//    }
//        cell.backgroundColor = [UIColor brownColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
    EarnAppointModel * model = _dataArray[indexPath.item];
    if (_deleagte && [_deleagte respondsToSelector:@selector(windfallFirstCell:withIndex:withState:)]) {
        [_deleagte windfallFirstCell:self withIndex:indexPath.item withState:model.state];
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_windfallCollectView reloadData];
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
