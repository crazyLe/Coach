//
//  WithfallView.m
//  Coach
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "WithfallView.h"
#import "WFDateCollectCell.h"
#import "WFCenterView.h"

#define kAppThemeColor   [UIColor colorWithHexString:@"0X2e82ff"] //APP 主题色

static NSString *cellReuseID = @"WFDateCollectCellReuseID";
@interface WithfallView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _wfDateCollectView;
    
    NSIndexPath *_indexPath;
    NSInteger _defaultIndex ;
    UICollectionViewFlowLayout * layOut;
    
    CGFloat _itemWidth;
    WFCenterView * _centerView;
}

@end

@implementation WithfallView

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
    _defaultIndex = 2;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 70)];
    backView.backgroundColor = [UIColor colorWithHexString:@"38424c"];
    [self addSubview:backView];
    
    _leftScrollBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 34, 70)];
    _leftScrollBtn.backgroundColor = [UIColor colorWithHexString:@"#38424c"];
    [_leftScrollBtn setImage:[UIImage imageNamed:@"earn_leftMark"] forState:UIControlStateNormal];
    [_leftScrollBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftScrollBtn];
    
    _rightSrcollBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-34, 5, 34, 70)];
    _rightSrcollBtn.backgroundColor = [UIColor colorWithHexString:@"#38424c"];
    [_rightSrcollBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightSrcollBtn setImage:[UIImage imageNamed:@"earn_rightMark"] forState:UIControlStateNormal];
    
    [self addSubview:_rightSrcollBtn];
    
    _itemWidth = (kScreenWidth-34*2)/5;
    layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layOut.itemSize = CGSizeMake(_itemWidth, 85);
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumLineSpacing = -0.5;
//    layOut.minimumInteritemSpacing = 0;
    
    _wfDateCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(34, 0, kScreenWidth-34*2, 85) collectionViewLayout:layOut];
    _wfDateCollectView.delegate = self;
    _wfDateCollectView.dataSource = self;
    _wfDateCollectView.backgroundColor = [UIColor whiteColor];
    _wfDateCollectView.showsHorizontalScrollIndicator = NO;
    _wfDateCollectView.bounces = NO;
    [self addSubview:_wfDateCollectView];
    
    [_wfDateCollectView registerNib:[UINib nibWithNibName:@"WFDateCollectCell" bundle:nil] forCellWithReuseIdentifier:cellReuseID];
    
    _centerView = [[WFCenterView alloc]initWithFrame:CGRectMake((kScreenWidth-_itemWidth)/2, 0, _itemWidth, 73)];
    _centerView.userInteractionEnabled = NO;
    [self addSubview:_centerView];
    
    
}


- (void)leftBtnClick
{
    if (_defaultIndex>16) {
        _defaultIndex = 16;
    }
    if (_defaultIndex >2) {
        _defaultIndex--;
    }
    _indexPath = [NSIndexPath indexPathForItem:_defaultIndex inSection:0];
    [_wfDateCollectView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    if (_defaultIndex>1 && _defaultIndex < 17) {
        EarnCalendarModel * model = _dataArray[_defaultIndex];
        _centerView.dateLabel.text = model.date;
        _centerView.weekLabel.text = model.week;
        if ([model.state isEqualToString:@"0"]) {
            _centerView.publishLabel.text = @"未发布";
        }else{
            _centerView.publishLabel.text = @"已发布";
        }
    }
    
    [self judgeTodyIndex:_defaultIndex];
    [_wfDateCollectView reloadData];
    
    
    
}

- (void)rightBtnClick
{
    if (_defaultIndex<2) {
        _defaultIndex = 2;
    }
    if (_defaultIndex <16) {
        _defaultIndex++;
    }
    _indexPath = [NSIndexPath indexPathForItem:_defaultIndex inSection:0];
    [_wfDateCollectView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    if (_defaultIndex>1 && _defaultIndex < 17) {
        EarnCalendarModel * model = _dataArray[_defaultIndex];
        _centerView.dateLabel.text = model.date;
        _centerView.weekLabel.text = model.week;
        if ([model.state isEqualToString:@"0"]) {
            _centerView.publishLabel.text = @"未发布";
        }else{
            _centerView.publishLabel.text = @"已发布";
        }
    }
    
    [self judgeTodyIndex:_defaultIndex];
    [_wfDateCollectView reloadData];
}

#pragma mark -- collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
//        return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WFDateCollectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    cell.index = _defaultIndex;
//    if (_dataArray.count>0) {
        if (indexPath.item ==0 || indexPath.item == 1 || indexPath.item == _dataArray.count-1 || indexPath.item == _dataArray.count-2) {
            cell.publishLabel.text = @"";
            cell.dateLabel.text = @"";
            cell.weekLabel.text = @"";
        }else{
            cell.calendarModel = _dataArray[indexPath.item];
            
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.bgImageView.hidden = YES;
        cell.publishLabel.font = [UIFont systemFontOfSize:13];
        cell.dateLabel.textColor = [UIColor colorWithHexString:@"858F94"];
        cell.weekLabel.textColor = [UIColor colorWithHexString:@"858F94"];
        cell.bgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"38424c"];
//    }else{
//        cell.backgroundColor = [UIColor orangeColor];
//    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _defaultIndex = indexPath.item;

    if (_defaultIndex >1 && _defaultIndex<17) {
        _indexPath = [NSIndexPath indexPathForItem:_defaultIndex inSection:0];
        [_wfDateCollectView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        if (_defaultIndex>1 && _defaultIndex < 17) {
            EarnCalendarModel * model = _dataArray[_defaultIndex];
            _centerView.dateLabel.text = model.date;
            _centerView.weekLabel.text = model.week;
            if ([model.state isEqualToString:@"0"]) {
                _centerView.publishLabel.text = @"未发布";
            }else{
                _centerView.publishLabel.text = @"已发布";
            }
        }
        
        [self judgeTodyIndex:_defaultIndex];
        [_wfDateCollectView reloadData];
    }
    
}

- (void)judgeTodyIndex:(NSInteger)index
{

    if (index < _dataArray.count - 2 && index>1) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(withfallViewDidSelectedIndex:)])
        {
            [self.delegate withfallViewDidSelectedIndex:index-2];
        }
    }
    
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if (_dataArray.count>0) {
        [_dataArray insertObject:@"" atIndex:0];
        [_dataArray insertObject:@"" atIndex:0];
        [_dataArray addObject:@""];
        [_dataArray addObject:@""];
    }
    if (_dataArray.count > 0) {
        EarnCalendarModel * model = _dataArray[_defaultIndex];
        _centerView.dateLabel.text = model.date;
        _centerView.weekLabel.text = model.week;
        if ([model.state isEqualToString:@"0"]) {
            _centerView.publishLabel.text = @"未发布";
        }else if([model.state isEqualToString:@"1"]){
            _centerView.publishLabel.text = @"已发布";
        }
    }
    [_wfDateCollectView reloadData];
}

#pragma mark - UIScrollViewDelegate

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / _itemWidth + 0.5;
    
    if (index >= _dataArray.count) {
        index = _dataArray.count -1;
    }
    _defaultIndex = index+2;
    if (_defaultIndex>1 && _defaultIndex < 17) {
        NSLog(@"下标++%ld++",_defaultIndex);
        EarnCalendarModel * model = _dataArray[index+2];
        _centerView.dateLabel.text = model.date;
        _centerView.weekLabel.text = model.week;
        if ([model.state isEqualToString:@"0"]) {
            _centerView.publishLabel.text = @"未发布";
        }else{
            _centerView.publishLabel.text = @"已发布";
        }
        [self judgeTodyIndex:_defaultIndex];
        [_wfDateCollectView reloadData];
    }
    
}
 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(WithfallView:collectionViewScrollBeginOrEnd:)]) {
        [_delegate WithfallView:self collectionViewScrollBeginOrEnd:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(WithfallView:collectionViewScrollBeginOrEnd:)]) {
        [_delegate WithfallView:self collectionViewScrollBeginOrEnd:YES];
    }
    
    NSUInteger index = scrollView.contentOffset.x / _itemWidth + 0.5;
    
    if (index >= _dataArray.count) {
        index = _dataArray.count -1;
    }
    _defaultIndex = index+2;
    if (_defaultIndex>1 && _defaultIndex < 17) {
        NSLog(@"下标++%ld++",_defaultIndex);
        EarnCalendarModel * model = _dataArray[index+2];
        _centerView.dateLabel.text = model.date;
        _centerView.weekLabel.text = model.week;
        if ([model.state isEqualToString:@"0"]) {
            _centerView.publishLabel.text = @"未发布";
        }else{
            _centerView.publishLabel.text = @"已发布";
        }
        [self judgeTodyIndex:_defaultIndex];
        [_wfDateCollectView reloadData];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat targetX = targetContentOffset->x;
    NSUInteger i = targetX / _itemWidth+0.5;
    *targetContentOffset = CGPointMake(i * _itemWidth, 0);
}



@end
