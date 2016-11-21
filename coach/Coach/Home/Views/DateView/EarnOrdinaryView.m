//
//  EarnOrdinaryView.m
//  Coach
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnOrdinaryView.h"
#import "EarnOrdinaryCell.h"

static NSString *cellReuseID = @"EarnOrdinaryCell";
@interface EarnOrdinaryView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _ordinaryCollectView;
}

@end

@implementation EarnOrdinaryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor] ;
        [self initSubviews];
    }
    return self ;
}

- (void)initSubviews
{
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake((kScreenWidth-40)/3.0, 65);
    layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layOut.minimumLineSpacing = 10;
    
    _ordinaryCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layOut];
    _ordinaryCollectView.delegate = self;
    _ordinaryCollectView.dataSource = self;
    _ordinaryCollectView.backgroundColor = [UIColor cyanColor];
    _ordinaryCollectView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_ordinaryCollectView];
    
//    [_ordinaryCollectView registerClass:[EarnOrdinaryCell class] forCellWithReuseIdentifier:cellReuseID];
    [_ordinaryCollectView registerNib:[UINib nibWithNibName:@"EarnOrdinaryCell" bundle:nil] forCellWithReuseIdentifier:cellReuseID];
    
    
}

#pragma mark -- collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return _dataArray.count;
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EarnOrdinaryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor brownColor];
    cell.contentView.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_ordinaryCollectView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
