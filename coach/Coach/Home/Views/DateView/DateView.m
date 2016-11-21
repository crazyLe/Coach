//
//  DateView.m
//  wills
//
//  Created by ai_ios on 16/4/18.
//  Copyright © 2016年 ai_ios. All rights reserved.
//

#import "DateView.h"
#import "DateCell.h"

#define ChangeColor [UIColor whiteColor]
#define BeginColor [UIColor blackColor]
#define LineColor [UIColor grayColor]

static NSString *cellReuseID = @"dateCell";
@interface DateView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{

    UICollectionView *_dateCollectionView;
    /// 左侧箭头
    UIButton *_leftArrowButton;
    /// 右侧箭头
    UIButton *_rightArrowButton;
    
    NSIndexPath *_indexPath;
    NSInteger _defaultIndex ;
}

@end
@implementation DateView

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
//    _defaultIndex = 0 ;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(60, self.frame.size.height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    
    _dateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height) collectionViewLayout:layout];
    _dateCollectionView.dataSource = self ;
    _dateCollectionView.delegate = self ;
//    _dateCollectionView.backgroundColor = [UIColor whiteColor];
    _dateCollectionView.backgroundColor = [UIColor colorWithHexString:@"#5cb6ff"];
    _dateCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_dateCollectionView];

    [_dateCollectionView registerClass:[DateCell class] forCellWithReuseIdentifier:cellReuseID];
    
    _leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftArrowButton.frame = CGRectMake(0, 0, self.frame.size.height/2, self.frame.size.height);
    _leftArrowButton.backgroundColor = [UIColor clearColor];
    [_leftArrowButton setImage:[UIImage imageNamed:@"earn_leftArrow"] forState:UIControlStateNormal];
    [_leftArrowButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftArrowButton];

    
    _rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightArrowButton.frame = CGRectMake(self.frame.size.width-self.frame.size.height/2, 0, self.frame.size.height/2, self.frame.size.height);
    _rightArrowButton.backgroundColor = [UIColor clearColor];
    [_rightArrowButton setImage:[UIImage imageNamed:@"earn_rightArrow"] forState:UIControlStateNormal];
    [_rightArrowButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightArrowButton];

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    lineLabel.backgroundColor = LineColor;
    [self addSubview:lineLabel];
}
- (void)buttonClick:(UIButton *)sender
{
    
    [_dateCollectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}



#pragma mark --- collectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    if (indexPath.item == _defaultIndex) {
        cell.textTintColor =  ChangeColor;
    }else{
        cell.textTintColor = BeginColor;
    }
    
    if (_dataArray.count > 0) {
//        cell.week = [(ADGetDateInfo *)_dataArray[indexPath.item] week];
//        cell.date = [(ADGetDateInfo *)_dataArray[indexPath.item] name];
    }
   
    return cell ;
}

#pragma mark --- collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    _indexPath = indexPath;
    _defaultIndex = indexPath.item;
    [_dateCollectionView reloadData];
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(dateViewDidSelectedIndex:)])
    {
        [self.delegate dateViewDidSelectedIndex:indexPath.item];
    }

}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [_dateCollectionView reloadData];

    if (_dataArray.count > 0) {
        
        [self judgeTodyIndex];
        _indexPath = [NSIndexPath indexPathForItem:_defaultIndex inSection:0];
        [_dateCollectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}
- (void)judgeTodyIndex
{
//    NSString *dateStr = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
    _defaultIndex = 0;
//    for (ADGetDateInfo *getDateInfo in _dataArray) {
//        if ([getDateInfo.date isEqualToString:dateStr]) {
//            return;
//        }
//        _defaultIndex++;
//    }
    
  
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
