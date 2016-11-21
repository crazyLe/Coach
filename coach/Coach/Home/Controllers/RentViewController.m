//
//  RentViewController.m
//  Coach
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kCollectionViewInterval 10

#define kSegmentedControlHeight 45

#import <YYKit/YYKit.h>
#import "SegmentedView.h"
#import "CoachCarRentDetailVC.h"
#import "RentCollectionViewCell.h"
#import <HMSegmentedControl.h>
#import "RentViewController.h"
#import "LeftLblRightButtonCell.h"
#import "EditRentInfoVC.h"
#import "UICollectionView+LLPlaceHolder.h"

@interface RentViewController () <UICollectionViewDelegate,UICollectionViewDataSource,LLCollectionViewPlaceHolderDelegate>

@property (nonatomic,strong) NSMutableArray *dataSourceArr;

@property (nonatomic,assign)  long long currentRequestFlag;

@property(nonatomic,assign)NSUInteger pageSize;   //记录一页返回多少条数据

@end

@implementation RentViewController

{
    NSArray *segmentedControlTitleArr;
    
    UISegmentedControl *segmentedControl;
    UICollectionView *bg_CollectionView;
    
    NSInteger _pageCount;
    
    requestBlock tableRequestBlock;
}

- (id)init
{
    if (self = [super init]) {
        segmentedControlTitleArr = @[@"我要承租",@"我要出租"];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self setUI];
    
    [self requestWithData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)setNav
{
//    [self setTitleText:_type == RentViewControllerTypeCoachCarRent ? @"教练车租赁" : @"场地租赁" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    [self setRightText:@"新增" textColor:nil ImgPath:nil];

    segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedControlTitleArr];
    segmentedControl.frame = CGRectMake(0, 0, 150, 30);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff" ],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:kAppThemeColor,NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    segmentedControl.tintColor = [UIColor colorWithHexString:@"ffffff"];
    [self.navigationItem setTitleView:segmentedControl];
    segmentedControl.selectedSegmentIndex = 0;
}

- (void)setUI
{
    [self setCollectionView];
}

- (void)setCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(((kScreenWidth-3*kCollectionViewInterval)/2), (kScreenWidth-70)/2+10+40+20+20);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    bg_CollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:bg_CollectionView];
    [bg_CollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(kTopBarTotalHeight, 0, 0, 0));
    }];
    bg_CollectionView.delegate = self;
    bg_CollectionView.dataSource = self;
    bg_CollectionView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [bg_CollectionView registerClass:[RentCollectionViewCell class] forCellWithReuseIdentifier:@"RentCollectionViewCell"];
    
    WeakObj(bg_CollectionView)
    WeakObj(self)
    [self setTableRefreshHandle:^(NSInteger page) {
        
        NSDictionary *paraDic = nil;
        NSString *relativeAddStr = nil;
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"deviceInfo":kDeviceInfo,@"sign":kSignWithIdentify(_type==RentViewControllerTypeCoachCarRent?@"/carHire":@"/venue"),@"cityId":kCityID,@"address":kAddress,@"pageId":integerToStr(page)};
            relativeAddStr = _type==RentViewControllerTypeCoachCarRent?@"/carHire":@"/venue";
        }
        else
        {
            paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"deviceInfo":kDeviceInfo,@"sign":kSignWithIdentify(_type==RentViewControllerTypeCoachCarRent?@"/myCarHire":@"/myVenue"),@"pageId":integerToStr(page)};
            relativeAddStr = _type==RentViewControllerTypeCoachCarRent?@"/myCarHire":@"/myVenue";
        }
        
         __block long long requestFlag = ++selfWeak.currentRequestFlag;
        
        [NetworkEngine postRequestWithRelativeAdd:relativeAddStr paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
            if (isSuccess) {
                if (requestFlag != selfWeak.currentRequestFlag) {
                    return ;
                }
                if (page==1) {
                    //Drop down
                    if (!isNull(jsonObj)) {
                        if (!isNull(jsonObj[@"info"])) {
                            selfWeak.dataSourceArr = jsonObj[@"info"][_type==RentViewControllerTypeCoachCarRent?@"carList":@"venueList"];
                            selfWeak.pageSize = selfWeak.dataSourceArr.count;
                            [bg_CollectionViewWeak ll_reloadData];
                            [bg_CollectionViewWeak.mj_header endRefreshing];
                        }
                        else
                        {
                            [bg_CollectionViewWeak ll_reloadData];
                        }
                    }
                    else
                    {
                        [bg_CollectionViewWeak ll_reloadData];
                    }
                }
                else
                {
                    if (!isNull(jsonObj[@"info"])) {
                        if (!isEmptyArr(jsonObj[@"info"])) {
                            NSArray *appendArr = jsonObj[@"info"][_type==RentViewControllerTypeCoachCarRent?@"carList":@"venueList"];
                            if (appendArr.count) {
                                [selfWeak.dataSourceArr appendObjects:appendArr];
                                [bg_CollectionViewWeak ll_reloadData];
                            }
                            else
                            {
                                //No more data
                            }
                        }
                        else
                        {
                            
                        }
                    }
                    [bg_CollectionViewWeak.mj_footer endRefreshing];
                }
            }
            else
            {
                // failed!
            }
            [bg_CollectionViewWeak.mj_header endRefreshing];
            [bg_CollectionViewWeak.mj_footer endRefreshing];
        }];
    }];
    [bg_CollectionView.mj_header beginRefreshing];
}

- (void)setTableRefreshHandle:(requestBlock)actionHandler
{
    tableRequestBlock = actionHandler;
    NSInteger *pageCountWeak = &_pageCount;
    bg_CollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        actionHandler(*pageCountWeak=1);
    }];
    
    bg_CollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        actionHandler(++*pageCountWeak);
    }];
}

- (void)requestWithData
{
//    //添加新学员
//    NSString *jsonStr = [LLUtils jsonStrWithJSONObject:@[@[isEmptyStr(phoneStr)?@"":phoneStr
//                                                           ,isEmptyStr(nameStr)?@"":nameStr
//                                                           ,[NSString stringWithFormat:@"%ld",subjectInt]
//                                                           ]]];
//    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/myStudent/create" paraNameArr:@[@"uid",@"time",@"student",@"sign"] paraValueArr:@[kUid,kTimeStamp,jsonStr,kSignWithIdentify(@"/main")] completeBlock:^(BOOL isSuccess, id jsonObj) {
//        if (isSuccess) {
//            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
//                //请求成功
//                [LLUtils showAutoHideMsg:jsonObj[@"msg"]];
//            }
//            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
//            {
//                //需要登录
//                [LLUtils showAlertWithTitle:jsonObj[@"msg"] message:nil delegate:self tag:10 type:AlertViewTypeOnlyConfirm];
//            }
//            else
//            {
//                //失败
//                [LLUtils showAutoHideMsg:jsonObj[@"msg"]];
//            }
//        }
//    }];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
//    param[@"cityId"] =
//    param[@"address"] =
//    param[@"deviceInfo"] =
//    param[@"pageId"] =
//    param[@"time"] = kTimeStamp
//    param[@"sign"]
    
//    [NetworkEngine postRequestWithRelativeAdd:@"" paraDic:<#(NSDictionary *)#> completeBlock:<#^(BOOL isSuccess, id jsonObj)block#>]

}

//刷新制定页的数据
-(void)refreshDataWithPage:(NSUInteger)page
{
    NSDictionary *paraDic = nil;
    NSString *relativeAddStr = nil;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"deviceInfo":kDeviceInfo,@"sign":kSignWithIdentify(_type==RentViewControllerTypeCoachCarRent?@"/carHire":@"/venue"),@"cityId":kCityID,@"address":kAddress,@"pageId":integerToStr(page)};
        relativeAddStr = _type==RentViewControllerTypeCoachCarRent?@"/carHire":@"/venue";
    }
    else
    {
        paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"deviceInfo":kDeviceInfo,@"sign":kSignWithIdentify(_type==RentViewControllerTypeCoachCarRent?@"/myCarHire":@"/myVenue"),@"pageId":integerToStr(page)};
        relativeAddStr = _type==RentViewControllerTypeCoachCarRent?@"/myCarHire":@"/myVenue";
    }
    
    __block long long requestFlag = ++self.currentRequestFlag;
    
    WeakObj(bg_CollectionView)
    WeakObj(self)
    
    [NetworkEngine postRequestWithRelativeAdd:relativeAddStr paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (requestFlag != selfWeak.currentRequestFlag) {
                return ;
            }
            if (!isNull(jsonObj[@"info"])) {
                if (!isEmptyArr(jsonObj[@"info"])) {
                    NSArray *appendArr = jsonObj[@"info"][_type==RentViewControllerTypeCoachCarRent?@"carList":@"venueList"];
                    if (appendArr.count) {
                        
                        NSUInteger currentPageStartIndex = (page-1)*_pageSize;
                        
                        if (selfWeak.dataSourceArr.count>=currentPageStartIndex+appendArr.count) {
                            [selfWeak.dataSourceArr replaceObjectsInRange:NSMakeRange(currentPageStartIndex, appendArr.count) withObjectsFromArray:appendArr];
                        }
                        else if (page==1)
                        {
                            selfWeak.dataSourceArr = [appendArr mutableCopy];
                        }
                        
                        [bg_CollectionViewWeak ll_reloadData];
                    }
                    else
                    {
                        //No more data
                    }
                }
                else
                {
                    
                }
            }
        }
        else
        {
            // failed!
        }
    }];
}


#pragma mark - UICollectionViewDelegate && DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RentCollectionViewCell" forIndexPath:indexPath];
//    cell.imgView.image = [UIImage imageNamed:@"changdi-two"];
//    cell.symbolImgView.image = [UIImage imageNamed:@"CoachTools_Coupon"];
    NSDictionary *dic = _dataSourceArr[indexPath.row];
    NSString *picUrl = nil;
    if (segmentedControl.selectedSegmentIndex==0) {
        if ([dic[@"pic"] isKindOfClass:[NSString class]]) {
            picUrl = kHandleEmptyStr(dic[@"pic"]);
        }
        else
        {
            picUrl = @"";
        }
    }
    else
    {
        if ([dic[@"pic"] isKindOfClass:[NSDictionary class]]) {
            picUrl = kHandleEmptyStr(dic[@"pic"][@"pic1"]);
        }
        else
        {
            picUrl = @"";
        }
    }
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"iconfont-default-1-1-image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            cell.imgView.image = [UIImage imageNamed:@"iconfont-defaultloadfailed"];
        }
    }];
//    cell.priceLbl.text = _type == RentViewControllerTypeCoachCarRent ? @"¥100/天" : @"¥100/天";
//    cell.infoLbl.text = _type == RentViewControllerTypeCoachCarRent ? @"捷达 5年 8万公里": @"合肥市经开区莲花路与石门路交口";
//    cell.remainLbl.text = _type == RentViewControllerTypeCoachCarRent ? @"剩余:20辆": @"";
    
    NSString *remainStr = _type == RentViewControllerTypeCoachCarRent? [NSString stringWithFormat:@"剩余:%@辆",dic[@"carNum"]]:@"";
    CGSize size = [remainStr sizeWithFont:cell.remainLbl.font maxSize:CGSizeMake(MAXFLOAT, 20)];
    [cell.remainLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(size.width+20);
    }];
    cell.remainLbl.text = remainStr;
    
    cell.priceLbl.text = [NSString stringWithFormat:@"¥%.0f/天",[dic[@"priceDay"] floatValue]] ;
    cell.infoLbl.text = _type == RentViewControllerTypeCoachCarRent ?@"": dic[@"address"];
    NSMutableAttributedString *areaAtt = [NSMutableAttributedString attributeStringWithText:_type == RentViewControllerTypeCoachCarRent ?@"":[NSString stringWithFormat:@"%.0f",[dic[@"size"] floatValue]] attributes:@[[UIColor colorWithHexString:@"4c4c4c"],kFont15]];
    [areaAtt appendText:@"亩" withAttributesArr:@[kLightGreyColor,kFont12]];
    cell.areaLbl.attributedText = _type == RentViewControllerTypeCoachCarRent?[NSMutableAttributedString attributeStringWithText:nil attributes:nil]:areaAtt;
    if (_type == RentViewControllerTypeCoachCarRent) {
        NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:dic[@"carType"] attributes:@[[UIColor colorWithHexString:@"4c4c4c"],kFont14]];
//        UIImage *sepImg = [UIImage imageWithColor:kLineColor size:CGSizeMake(1.0f, 15)];
//        [attStr appendImg:sepImg bounds:CGRectMake(5, -3, 1.0f, 15)];
        [attStr appendText:[NSString stringWithFormat:@" %@",dic[@"carAge"]] withAttributesArr:@[[UIColor colorWithHexString:@"4c4c4c"],kFont14]];
        [attStr appendText:@"年" withAttributesArr:@[kLightGreyColor,kFont12]];
//        [attStr appendImg:sepImg bounds:CGRectMake(5, -3, 1.0f, 15)];
        [attStr appendText:[NSString stringWithFormat:@" %@",dic[@"carKm"]] withAttributesArr:@[[UIColor colorWithHexString:@"4c4c4c"],kFont14]];
        [attStr appendText:@"万" withAttributesArr:@[[UIColor colorWithHexString:@"4c4c4c"],kFont14]];
        cell.infoLbl.attributedText = attStr;
    }
    else
    {
        
    }
    [cell setContentWithType:_type == RentViewControllerTypeCoachCarRent?RentCollectionViewCellTypeCoachRent:RentCollectionViewCellTypePlaceRent];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentedControl.selectedSegmentIndex==0) {
        CoachCarRentDetailVC *coachCarRentDetailVC = [[CoachCarRentDetailVC alloc] init];
        if (_type == RentViewControllerTypeCoachCarRent) {
            //教练车租赁
            coachCarRentDetailVC.type = RentDetailVCTypeCoachCarDetail;
        }
        else
        {
            //场地租赁
            coachCarRentDetailVC.type = RentDetailVCTypePlaceRent;
        }
        coachCarRentDetailVC.infoDic = _dataSourceArr[indexPath.item];
        [self.navigationController pushViewController:coachCarRentDetailVC animated:YES];
    }
    else
    {
        WeakObj(self)
        EditRentInfoVC *editRentInfoVC = [[EditRentInfoVC alloc] init];
        editRentInfoVC.type = _type;
        editRentInfoVC.infoDic = _dataSourceArr[indexPath.item];
        editRentInfoVC.isEditInfo = YES;
        editRentInfoVC.indexPath = indexPath;
        editRentInfoVC.needRefreshBlock = ^(NSIndexPath *indexPath){
            //计算当前Cell所在页码
            NSUInteger currentPageIndex = indexPath.row/_pageSize+1;
            
            //请求并刷新UI
            [selfWeak refreshDataWithPage:currentPageIndex];
        };
        [self.navigationController pushViewController:editRentInfoVC animated:YES];
    }
}

/*!
 @brief  make an empty overlay view when the tableView is empty
 @return an empty overlay view
 */
#pragma mark - LLCollectionViewPlaceHolderDelegate

- (UIView *)makePlaceHolderView;
{
    UIView *bgView = [UIView new];
    
    UILabel *promptLbl = [UILabel new];
    [bgView addSubview:promptLbl];
    NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"CoachCarRent_Cry"] bounds:CGRectMake(0, 0, 100, 100)];
    [attStr appendBreakLineWithInterval:6];
    [attStr appendText:segmentedControl.selectedSegmentIndex==1?@"您暂时未发布":@"" withAttributesArr:@[rgb(249, 117, 43)]];
    [attStr appendBreakLineWithInterval:3];
    [attStr appendText:segmentedControl.selectedSegmentIndex==1?@"可出租的教练车资源":@"暂时未搜索到资源" withAttributesArr:@[rgb(249, 117, 43)]];
    promptLbl.attributedText = attStr;
    promptLbl.textAlignment = NSTextAlignmentCenter;
    promptLbl.numberOfLines = 0;
    
    UIButton *goPublicbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:goPublicbtn];
    [goPublicbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView.mas_centerY);
        make.centerX.equalTo(promptLbl);
        make.width.offset(0.8*kScreenWidth);
        make.height.offset(40);
    }];
    goPublicbtn.layer.cornerRadius = 20;
    goPublicbtn.layer.masksToBounds = YES;
    [goPublicbtn setBackgroundColor:kAppThemeColor];
    [goPublicbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goPublicbtn setTitle:segmentedControl.selectedSegmentIndex==1?@"去发布":@"刷新" forState:UIControlStateNormal];
    [goPublicbtn addTarget:self action:@selector(clickGoPublicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-self.view.bounds.size.height/4);
    }];
    
    return bgView;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing;
{
    return YES;
}

- (void)clickGoPublicBtn:(UIButton *)publicBtn
{
    if (segmentedControl.selectedSegmentIndex==1) {
        [self clickRightBtn:nil];
    }
    else
    {
        [bg_CollectionView.mj_header beginRefreshing];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - LeftLblRightButtonCellDelegate

- (void)LeftLblRightButtonCell:(LeftLblRightButtonCell *)cell clickRightBtn:(LLButton *)rightBtn
{
    
}

#pragma mark - SegmentedViewDelegate

- (void)segmentedControlChangedValue:(UISegmentedControl *)segment
{
//    if (segment.selectedSegmentIndex == 0) {
//        if (self.bg_TableView) {
//            [self.bg_TableView removeFromSuperview] , self.bg_TableView = nil;
//        }
//        [self setCollectionView];
//    }
//    else
//    {
//        if (bg_CollectionView) {
//            [bg_CollectionView removeFromSuperview] , bg_CollectionView = nil;
//        }
//        [self setTableView];
//    }
    _dataSourceArr = nil;
    
    _currentRequestFlag++;
    [bg_CollectionView.mj_header beginRefreshing];
}

#pragma  mark Overwrite

- (void)clickRightBtn:(UIButton *)rightBtn
{
    checkLogin()
    
    WeakObj(self)
    EditRentInfoVC *editRentVC = [[EditRentInfoVC alloc] init];
    editRentVC.type = _type;
    editRentVC.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    editRentVC.needRefreshBlock = ^(NSIndexPath *indexPath){
        //计算当前Cell所在页码
        NSUInteger currentPageIndex = 1;
        if (_pageSize>0) {
            currentPageIndex = indexPath.row/_pageSize+1;
        }
        
        //请求并刷新UI
        [selfWeak refreshDataWithPage:currentPageIndex];
    };
    [self.navigationController pushViewController:editRentVC animated:YES];
}

#pragma mark  - Network



@end
