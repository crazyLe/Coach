//
//  ExamStudyHourVC.m
//  Coach
//
//  Created by gaobin on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ExamStudyHourVC.h"
#import "ExanStudyHourCell.h"
#import "ExamHeaderView.h"
#import "ZHPickView.h"
#import "NSObject+HJGeneral.h"
//临时添加,回头删除
#import "OrderInfomationVC.h"
#import "ExamAreaDetailVC.h"

@interface ExamStudyHourVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderReusableViewDelegate,ZHPickViewDelegate>

@property (nonatomic, strong) UISegmentedControl * segment;
@property (nonatomic, strong) UIScrollView * bgScrollView;
@property (nonatomic, strong) UICollectionView * subTwoCollectionView;
@property (nonatomic, strong) UICollectionView * subThreeCollectionView;

@property (nonatomic, strong) UIButton * fromTimeBtn;
@property (nonatomic, strong) UIButton * toTimeBtn;
@property(nonatomic,strong)UIButton * carTypeBtn;
@property(nonatomic,assign)NSInteger startMin;
@property(nonatomic,assign)NSInteger toMin;
@property (nonatomic, strong) ZHPickView * fromPickerView;
@property (nonatomic, strong) ZHPickView * toPickerView;
@property (nonatomic, strong) ZHPickView * carTypePickView;


@end

@implementation ExamStudyHourVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [_fromPickerView remove];
    [_toPickerView remove];
    [_carTypePickView remove];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self createNavigation];
    
    [self createSegment];
    
    [self createUI];
    
    
    
}
#pragma mark -- 创建segment
- (void)createSegment {
    
    NSArray * segmentArray = @[@"科目二",@"科目三"];
    _segment = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segment.selectedSegmentIndex = 0;
    _segment.tintColor = [UIColor whiteColor];
    _segment.frame = CGRectMake(100, 0, kScreenWidth - 200, 30);
    [_segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segment;
    
}
- (void)segmentValueChanged:(UISegmentedControl *)segment {
    
    
    
    
    
    
    
}
- (void)createUI {
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight -64)];
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight -64);
    _bgScrollView.alwaysBounceVertical = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.delegate = self;
    //_bgScrollView.bounces = NO;
    _bgScrollView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_bgScrollView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(9, 12, 9, 12);
    layout.minimumLineSpacing = 11;
    layout.minimumInteritemSpacing = 11;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _subTwoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64) collectionViewLayout:layout];
    _subTwoCollectionView.delegate = self;
    _subTwoCollectionView.dataSource = self;
    _subTwoCollectionView.backgroundColor = [UIColor colorWithHexString:@"f2f7f6"];
    [_bgScrollView addSubview:_subTwoCollectionView];
    [_subTwoCollectionView registerNib:[UINib nibWithNibName:@"ExanStudyHourCell" bundle:nil] forCellWithReuseIdentifier:@"ExanStudyHourCell"];
    [_subTwoCollectionView registerClass:[ExamHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ExamHeaderView"];
    
    
}
-(void)headerReusableView:(ExamHeaderView *)headerView didClickBtnWithType:(HeaderViewButtonType)type
{
    [_fromPickerView remove];
    [_toPickerView remove];
    [_carTypePickView remove];
    switch (type) {
        case HeaderButtonTypeFrom:
        {
            
            NSMutableArray *arr1 = [NSMutableArray array];
            for (int i = 0; i<24; i++) {
                [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
            }
            NSMutableArray *arr2 = [NSMutableArray array];
            for (int i = 0; i<60; i++) {
                [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
            }
            NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
            ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
            pickView.tag = 405;
            _fromPickerView = pickView;
            [pickView setPickViewColer:[UIColor groupTableViewBackgroundColor]];
            pickView.delegate = self;
            [pickView show];
            
            
        }
            break;
        case HeaderButtonTypeTo:
        {
            
            NSMutableArray *arr1 = [NSMutableArray array];
            for (int i = 0; i<24; i++) {
                [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
            }
            NSMutableArray *arr2 = [NSMutableArray array];
            for (int i = 0; i<60; i++) {
                [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
            }
            NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
            ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
            pickView.tag = 406;
            _toPickerView = pickView;
            [pickView setPickViewColer:[UIColor groupTableViewBackgroundColor]];
            pickView.delegate = self;
            [pickView show];
            
        }
            break;
        case HeaderButtonTypeCarType:
        {
            NSArray *arr = [NSArray arrayWithObjects:@"A1",@"A2",@"A3",@"B1",@"B2",@"C1",@"C2", nil];
            ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
            pickView.tag = 407;
            _carTypePickView = pickView;
            [pickView setPickViewColer:[UIColor groupTableViewBackgroundColor]];
            pickView.delegate = self;
            [pickView show];
            
            
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    
}
#pragma mark - ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    if (pickView.tag == 405) {
        
        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        [strArr removeObjectAtIndex:0];
        
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger fromMin = hour *60 + min;
        if (fromMin>=_toMin&&_toMin!= 0) {
            [self.hudManager showErrorSVHudWithTitle:@"不能大于结束时间!" hideAfterDelay:1.0];
            return;
        }
        else
        {
            [self.fromTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            
            self.startMin = hour *60 + min;
        }
        
    }
    if (pickView.tag == 406) {
        
        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        [strArr removeObjectAtIndex:0];
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger toMin = hour *60 + min;
        if (toMin<=_startMin) {
            [self.hudManager showErrorSVHudWithTitle:@"不能小于开始时间!" hideAfterDelay:1.0];
            return;
        }else
        {
            self.toMin = hour *60 + min;
            [self.toTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            
        }
        
    }
    
    if (pickView.tag == 407) {
        
        [self.carTypeBtn setTitle:resultString forState:UIControlStateNormal];
        
    }
    
    
}
#pragma mark -- collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"ExanStudyHourCell";
    ExanStudyHourCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake((kScreenWidth - 35)/2, (kScreenWidth -35)/2 -20+12+90);
    
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
//        OrderInfomationVC * vc = [[OrderInfomationVC alloc] init];
//        
//        [self.navigationController pushViewController:vc animated:YES];
        
        ExamAreaDetailVC * vc = [[ExamAreaDetailVC alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    
}
#pragma mark -- 返回collectionView区头视图的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 90);
    
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ExamHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"ExamHeaderView" forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.delegate = self;
    self.fromTimeBtn = headerView.fromTimeBtn;
    self.toTimeBtn = headerView.toTimeBtn;
    self.carTypeBtn = headerView.carTypeBtn;
    return headerView;
    
    
}
- (void)createNavigation {
    
    [self setTitleText:nil textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
