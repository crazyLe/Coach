//
//  GroundMapController.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/8/15.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#define UIColorFromRGBA(r, g, b , a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kHeight kScreenHeight

#import "GroundMapController.h"

#import <CoreLocation/CLLocation.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

//设备物理尺寸
#define screen_width kWidth
#define screen_height kHeight
#define Myuser [NSUserDefaults standardUserDefaults]


@interface GroundMapController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    BMKPinAnnotationView *newAnnotation;
    
    BMKGeoCodeSearch *_geoCodeSearch;
    
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
    
    BMKLocationService *_locService;
    
    NSIndexPath *lastIndexPath;
    
    NSInteger lastIndex;
//    当前经纬度
    CLLocationCoordinate2D loc;
    
    NSMutableArray *resultArray;
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (nonatomic,strong) BMKPoiSearch *searcher;

@property (nonatomic,assign) int curPage;

@property (nonatomic,weak) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;

@property (weak, nonatomic) IBOutlet UIButton *mapPin;

@property (weak, nonatomic) IBOutlet UITableView *cityTableview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableH;

@property(nonatomic,strong)NSMutableArray *cityDataArr;


#warning  接口
@property (nonatomic,strong)cityModel *cityModel;

@end

@implementation GroundMapController

-(NSMutableArray *)cityDataArr
{
    if (_cityDataArr==nil)
    {
        _cityDataArr=[NSMutableArray arrayWithCapacity:0];
    }
    
    return _cityDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lastIndex = 0;
    
    self.title = @"位置信息";
    
    [self setRightText:@"发送" textColor:nil ImgPath:nil];
    
    self.tableH.constant = kHeight - 200 - 64;
    
    [self initLocationService]; //初始化定位服务
    [self initBMK_POI_Search];
    [self initSearchBar];
//    [self setupNav:@"注册"];
//    [self createConfirmBtn];
    
    
}
/*
- (void)setupNav:(NSString *)title
{
    UIView *barview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    barview.backgroundColor = NavBackColor;
    [self.view addSubview:barview];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, 44, 44)];
    [back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [barview addSubview:back];
    
    UILabel *bartitle = [[UILabel alloc]initWithFrame:CGRectMake((kWidth-100)/2, 20, 100, 44)];
    bartitle.textColor = [UIColor whiteColor];
    bartitle.text = title;
    bartitle.textAlignment = NSTextAlignmentCenter;
    bartitle.font = Font22;
    [barview addSubview:bartitle];
    
    [self.view bringSubviewToFront:_searchBar];
    
}
 */
#pragma mark - UISearchController

- (void)initSearchBar
{
//    resultArray = [[NSMutableArray alloc] init];
    _searchBar.placeholder = @"搜索地址";
    _searchBar.delegate = self;
    _searchBar.layer.borderColor = [[UIColor colorWithHexString:@"ededed"] CGColor];
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    [self.view addSubview:_searchBar];
}

#pragma mark - UISearchBar Delegate
/**
 *  搜索开始回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setBackgroundColor:UIColorFromRGBA(198, 198, 203, 1.0)];
        for (UIView *subview in self.view.subviews){
            if (_searchBar==subview) {
                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height-64);
            }
            
        }
    }];
    return YES;
}

/**
 *  搜索结束回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if (!_searchDisplayController.active) {
        [self RevertView];
    }
    return YES;
}

- (void)RevertView
{
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *subview in self.view.subviews){
            subview.transform = CGAffineTransformMakeTranslation(0, 0);
        }
    } completion:^(BOOL finished) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
//    [resultArray removeAllObjects];
//    for (int i = 0; i < cities.count; i++) {
//        if ([[ChineseToPinyin pinyinFromChiniseString:cities[i]] hasPrefix:[searchString uppercaseString]] || [cities[i] hasPrefix:searchString]) {
//            [resultArray addObject:[cities objectAtIndex:i]];
//        }
//    }
    if (!isEmptyStr(searchString)) {
        [self searchWithKeyword:searchString];
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self searchDisplayController:controller shouldReloadTableForSearchString:_searchBar.text];
    return YES;
}

#pragma mark - BMKPoiSearch

- (void)initBMK_POI_Search
{
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
}

//发起周边检索
- (void)searchWithKeyword:(NSString *)keyword
{
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = _curPage;
    option.pageCapacity = 10;
    cityModel *cityModel = self.cityDataArr.count>0?[self.cityDataArr firstObject]:nil;
    option.location = cityModel==nil?CLLocationCoordinate2DMake(39.915, 116.404):cityModel.pt;
    option.keyword = keyword;
    BOOL flag = [_searcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        resultArray = [[NSMutableArray alloc] init];
        for (BMKPoiInfo *poiInfo in poiResultList.poiInfoList) {
            cityModel *model = [[cityModel alloc] init];
            model.name = poiInfo.name;
            model.pt = poiInfo.pt;
            model.address = poiInfo.address;
            [resultArray addObject:model];
        }
        [_searchDisplayController.searchResultsTableView reloadData];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchDisplayController.active?resultArray.count:self.cityDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cityModel*model= _searchDisplayController.active?resultArray[indexPath.row]:self.cityDataArr[indexPath.row];

    if (lastIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text=model.name;
    
    cell.detailTextLabel.text=model.address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    lastIndex = indexPath.row;
    if (_searchDisplayController.active) {
//        [_searchDisplayController.searchResultsTableView reloadData];
        //设置地图中心为用户经纬度
        
        //    _mapView.centerCoordinate = userLocation.location.coordinate;
        
        [self RevertView];
        [_searchDisplayController setActive:NO animated:YES];
        
        cityModel *model = resultArray[indexPath.row];
        
        BMKCoordinateRegion region ;//表示范围的结构体
        region.center = model.pt;//中心点
        region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
        region.span.longitudeDelta = 0.004;//纬度范围
        [_mapView setRegion:region animated:YES];
        
        _cityModel = model;
    }
    else
    {
        [self.cityTableview reloadData];
        
        cityModel *model = _cityDataArr[lastIndex];
        _cityModel = model;
    }
}

#pragma mark 设置cell分割线做对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([self.cityTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.cityTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.cityTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.cityTableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


#pragma mark 初始化地图，定位
-(void)initLocationService
{
    
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    
    _mapView.zoomLevel=17;
    _mapView.delegate=self;
    _mapView.showsUserLocation = YES;
    
    [_mapView bringSubviewToFront:_mapPin];
    
    
    if (_locService==nil) {
        
        _locService = [[BMKLocationService alloc]init];
        
        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
}

#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    //设置地图中心为用户经纬度
    [_mapView updateLocationData:userLocation];
    
    
    //    _mapView.centerCoordinate = userLocation.location.coordinate;
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.004;//纬度范围
    [_mapView setRegion:region animated:YES];
    
}

#pragma mark BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];
    loc = MapCoordinate;
    if (_geoCodeSearch==nil) {
        //初始化地理编码类
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
        
    }
    if (_reverseGeoCodeOption==nil) {
        
        //初始化反地理编码类
        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    }
    
    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.reverseGeoPoint =MapCoordinate;
    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    
}

#pragma mark BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    [SVProgressHUD showWithStatus:@"加载中..."];
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        
        [self.cityDataArr removeAllObjects];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            cityModel *model=[[cityModel alloc]init];
            model.name=poiInfo.name;
            model.address=poiInfo.address;
            model.pt = poiInfo.pt;
            
            [self.cityDataArr addObject:model];
        }
        
        if (_cityDataArr.count>lastIndex) {
//            _cityModel = [_cityDataArr firstObject];
            _cityModel = _cityDataArr[lastIndex];
        }
        
         [self.cityTableview reloadData];
//         [SVProgressHUD dismiss];
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    
    _searcher.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    //    在不需要时，通过下边的方法使引用计数减1
    //    [BMKRadarManager releaseRadarManagerInstance];
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    
    _searcher.delegate = nil;
}

- (void)clickRightBtn:(UIButton *)rightBtn
{
    [self sendWeizhi];
}

- (void)sendWeizhi
{
//    if ((nil != _cityDataArr) && (_cityDataArr.count>lastIndex)) {
        if ([_delegate respondsToSelector:@selector(getCityModel:andWeizhi:)]) {
//            [_delegate getCityModel:self.cityDataArr[lastIndex] andWeizhi:loc];
            [_delegate getCityModel:_cityModel andWeizhi:_cityModel.pt];
        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)backClick {
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)createConfirmBtn {
//    
//    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#fe9a33"];
//    [confirmBtn setTitle:@"确认地址" forState:UIControlStateNormal];
//    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:confirmBtn];
//    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.offset(0);
//        make.height.offset(44);
//    }];
//}
//- (void)confirmBtnClick {
//    
//    LastStepRegisterVC * vc = [[LastStepRegisterVC alloc] init];
//    vc.cityModel = _cityModel;
//    vc.registerModel = _registerModel;
//    vc.isFromGroupMap = YES;
//    [self presentViewController:vc animated:YES completion:nil];
//    
//}
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
