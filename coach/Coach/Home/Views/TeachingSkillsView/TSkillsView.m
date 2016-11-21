//
//  TSkillsView.m
//  Coach
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "TSkillsView.h"
#import "TSkillsCell.h"

#define ChangeColor [UIColor colorWithHexString:@"6da3f4"]
#define BeginColor [UIColor whiteColor]

static NSString *cellReuseID = @"dateCell";
@interface TSkillsView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    UICollectionView *_dateCollectionView;
    /// 左侧箭头
    UIButton *_leftArrowButton;
    /// 右侧箭头
    UIButton *_rightArrowButton;
    
    NSIndexPath *_indexPath;
    NSInteger _defaultIndex ;
}

@property(nonatomic,strong)UIButton * currentSelectBtn;

@end

@implementation TSkillsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor] ;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    
    _defaultIndex = 0 ;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(80, 48);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    layout.minimumInteritemSpacing = (kScreenWidth-35*2-57*4)/2;
    layout.minimumLineSpacing = (kScreenWidth-35*2-80*3)/2;
    
    _dateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(35, 0, kScreenWidth-35*2, 48) collectionViewLayout:layout];
    _dateCollectionView.dataSource = self ;
    _dateCollectionView.delegate = self ;
    _dateCollectionView.backgroundColor = [UIColor whiteColor];
    _dateCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_dateCollectionView];
    
    [_dateCollectionView registerClass:[TSkillsCell class] forCellWithReuseIdentifier:cellReuseID];
    
    _leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftArrowButton.frame = CGRectMake(0, 0, 35, self.frame.size.height);
    _leftArrowButton.backgroundColor = [UIColor clearColor];
    [_leftArrowButton setImage:[UIImage imageNamed:@"TSkills_leftArrow"] forState:UIControlStateNormal];
    _leftArrowButton.tag = 100;
    [_leftArrowButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftArrowButton];
    
    
    _rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightArrowButton.frame = CGRectMake(self.frame.size.width-35, 0, 35, self.frame.size.height);
    _rightArrowButton.backgroundColor = [UIColor clearColor];
    [_rightArrowButton setImage:[UIImage imageNamed:@"TSkills_rightArrow"] forState:UIControlStateNormal];
    _rightArrowButton.tag = 200;
    [_rightArrowButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightArrowButton];
    
//    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
//    lineLabel.backgroundColor = LineColor;
//    [self addSubview:lineLabel];
}
- (void)buttonClick:(UIButton *)sender
{
    NSInteger currentIndex = _defaultIndex;
    switch (sender.tag) {
        case 100:        //左边
        {

            if (_defaultIndex >0) {
                _defaultIndex--;
                [_dateCollectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                [self judgeTodyIndex:_defaultIndex];
                [_dateCollectionView reloadData];
                return;
            }

        }
            break;
        case 200:        //右边
        {
            if (_defaultIndex <[_dataArray count]-1) {
                _defaultIndex ++;
//                [_dateCollectionView reloadData];
//            }
//            
//            if (_defaultIndex < [_dataArray count]-3) {
                
                _indexPath = [NSIndexPath indexPathForItem:_defaultIndex inSection:0];
                [_dateCollectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//                [UIView animateWithDuration:0.05 animations:^{
//                    _dateCollectionView.contentOffset = CGPointMake(_defaultIndex*(57+(kScreenWidth-35*2-57*4)/3), 0);
//                } completion:nil];
                [self judgeTodyIndex:_defaultIndex];
                [_dateCollectionView reloadData];
                return;
            }
        }
            break;
        default:
            break;
    }
    
    
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
    TSkillsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    if (indexPath.item == _defaultIndex) {
        [cell.subjectsBtn setBackgroundColor:ChangeColor];
        [cell.subjectsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [cell.subjectsBtn setBackgroundColor:BeginColor];
        [cell.subjectsBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }
    
    if (_dataArray.count > 0) {
        //        cell.week = [(ADGetDateInfo *)_dataArray[indexPath.item] week];
        //        cell.date = [(ADGetDateInfo *)_dataArray[indexPath.item] name];
        [cell.subjectsBtn setTitle:_dataArray[indexPath.item] forState:UIControlStateNormal];
    }
//    cell.backgroundColor = [UIColor brownColor];
    return cell ;
}

#pragma mark --- collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    _indexPath = indexPath;
    _defaultIndex = indexPath.item;
    [_dateCollectionView reloadData];
    
    [self judgeTodyIndex:indexPath.item];
    
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [_dateCollectionView reloadData];
    
    if (_dataArray.count > 0) {
        
//        [self judgeTodyIndex];
        _indexPath = [NSIndexPath indexPathForItem:_defaultIndex inSection:0];
        [_dateCollectionView scrollToItemAtIndexPath:_indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

- (void)judgeTodyIndex:(NSInteger)index
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(tSkillsViewDidSelectedIndex:)])
    {
        [self.delegate tSkillsViewDidSelectedIndex:index];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
