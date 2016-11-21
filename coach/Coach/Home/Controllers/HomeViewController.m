//
//  HomeViewController.m
//  Coach
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLAddress.h"
#import "MessageDataBase.h"
#import "CircleJSManager.h"
#import "SystemMsgController.h"
#import "MricoCardJSManager.h"
#import "LLWebViewController.h"
#import <BBCyclingLabel.h>
#import "LLWebViewController.h"
#import "ExamStudyHourVC.h"
#import "LLCouponView.h"
#import "Header.h"
#import "LLButton.h"
#import "HomeViewController.h"
#import "WalletViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <SDCycleScrollView.h>
#import "MyStudentVC.h"
#import "AddStudentVC.h"
#import "TeachingSkillsController.h"
#import "EarnExtraMoneyController.h"
#import "MyAdmissionsVC.h"
#import "BusinessCardController.h"
#import "VoucherController.h"
#import "ExamPlacesViewController.h"
#import "RentViewController.h"
#import "NSMutableAttributedString+LLExtension.h"
#import "CitySelectController.h"
#import "ScanningController.h"
#import <JSBadgeView.h>

//考试名额
#import "MEHZController.h"
//代金劵
#import "DJJViewController.h"
//检查版本
#import "CheckVersionManager.h"
//圈子
#import "CircleTopLineController.h"

#define kControlLeftSep 15*kWidthScale
#define kDecorationTopOffset (kControlLeftSep-1.5f)
#define kDecorationHeight    18

#define kCoachToolsBtnNumVertical 2  //教练福利垂直方向上button个数
#define kCoachImprestUrl [WAP_HOST_ADDR stringByAppendingPathComponent:@"/jlbyj"]  //教练备用金url

typedef void(^requestCompletionBlock)(int state);

@interface HomeViewController () <SDCycleScrollViewDelegate,LLCouponViewDelegate>
{
    BMKLocationService *_locService;
    NSArray *tableRowHeightArr;
    
    NSArray *bannersArr;
    NSMutableArray *bannersImgArr;
    NSArray *coachCommunityArr;
    
    NSTimer *rankListTimer;
    NSInteger rankIndex;
}

@property (nonatomic,strong)JSBadgeView *badgeView;

@end

@implementation HomeViewController

- (id)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = NO;
        tableRowHeightArr = @[@(120*kHeightScale),
                              @(200),
                              @(65+12.5),
                              @(kDecorationHeight+kDecorationTopOffset*2+115*kWidthScale+12.5*2),
                              @(125*kCoachToolsBtnNumVertical+(kDecorationTopOffset*2+kDecorationHeight-40)+kSepViewHeight)]; //表的行高定义
        rankListTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(rankListTimerHandle:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:rankListTimer forMode:NSRunLoopCommonModes];
        [rankListTimer setFireDate:[NSDate distantFuture]];
        
        //监听通知
        [NOTIFICATION_CENTER addObserver:self selector:@selector(msgRead) name:kMakeMsgIsReadNotification object:nil];
        [NOTIFICATION_CENTER addObserver:self selector:@selector(msgRead) name:kUpdateMainMsgRedPointNotification object:nil];
    }
    return self;
}

-(void)msgRead
{
    [self setNav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setNav];
    [self setUI];
    
//    if (!isLogin) {
//        [self showLoginRegisterWithLoginSuccessBlock:^{
//            [self requestData]; //请求数据
//        }];
//    }
//    else
//    {
        [self requestData];
//    }
    
    
    //检查版本
//    [[CheckVersionManager sharedCheckVersionManager] checkVersion];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)clickLeftBtn:(UIButton *)leftBtn
{
    /*
    __block BOOL isReturn = NO;
    while (isStartUpdaeDB) {
        //从数据库中读取，验证
        [[SCDBManager shareDatabaseQueue] inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                
                NSString * countryArrCount = [NSString stringWithFormat:@"%@",[kUserDefault objectForKey:@"kCountryArrCount"]];
                 FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"select * from %@ where %@ = ?",kCountyTableName,@"id"],countryArrCount];
                
                if ([result next]) {
                    [kUserDefault setBool:NO forKey:@"AreaStartUpdateFlag"];  //标记地区数据已经更新完毕
                    [kUserDefault synchronize];
                }
                else
                {
                    isReturn = YES;
                }
                
                [db close];
            }
            else
            {
                
            }
        }];
        if (isReturn) {
            [LLUtils showErrorHudWithStatus:@"数据库升级中,请稍等.."];
            return;
        }
    }
     */
    
    CitySelectController *cityVC = [[CitySelectController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:cityVC];
    cityVC.didSelectCityBlock = ^(NSString *city){
        [self setLeftText:city textColor:nil ImgPath:@"TopBar_Left"];
        
        CGSize locationSize = [city sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
        
        self.leftBtn.width = ((float)locationSize.width+10)*4/3;
        
        [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.leftBtn.frame.size.width/1.5+5/2.0, 0, -self.leftBtn.frame.size.width/1.5-5/2.0)];
    };
    [self presentViewController:homeNav animated:YES completion:nil];

}
- (void)setNav
{
    [self setTitleText:@"首页" textColor:nil];
    [self setLeftText:@"合肥" textColor:nil ImgPath:@"TopBar_Left"];
    [self setRightText:nil textColor:nil ImgPath:@"Home_smallBell"];
    
//    [RACObserve(self.locationManager, placeMark) subscribeNext:^(CLPlacemark *x) {
//        
//        NSString *str = self.locationManager.placeMark.locality;
//        
//        if (str.length > 0) {
//            
//            NSString *city = [self.locationManager.placeMark.locality substringToIndex:self.locationManager.placeMark.locality.length];
//            
//            [self.leftBtn setTitle:city forState:UIControlStateNormal];
//            /*
//             CGSize locationSize = [city sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
//             
//             self.leftBtn.width = ((float)locationSize.width+10)*4/3;
//             */
//            
//            [USER_DEFAULT setObject:city forKey:@"locationCity"];
//            
//        }
//        
//    }];
    
//    [self.leftBtn setTitle:kCurrentLocationCity forState:UIControlStateNormal];
    
    
    //1、在父控件（parentView）上显示，显示的位置TopRight
    self.badgeView = [[JSBadgeView alloc]initWithParentView:self.rightBtn alignment:JSBadgeViewAlignmentTopRight];
    //2、如果显示的位置不对，可以自己调整，超爽啊！
    self.badgeView.badgePositionAdjustment = CGPointMake(0, 3);
    //1、背景色
    self.badgeView.badgeBackgroundColor = [UIColor redColor];
    //2、没有反光面
    self.badgeView.badgeOverlayColor = [UIColor clearColor];
    //3、外圈的颜色，默认是白色
    self.badgeView.badgeStrokeColor = [UIColor redColor];
    
    /*****设置数字****/
    //1、用字符
    if ([[MessageDataBase shareInstance] queryAllUnRead].count != 0) {
        self.badgeView.badgeText = [NSString stringWithFormat:@"%ld",[[MessageDataBase shareInstance] queryAllUnRead].count];
    }
    else
    {
        self.badgeView.badgeText = nil;
    }
    //当更新数字时，最好刷新，不然由于frame固定的，数字为2位时，红圈变形
    [self.badgeView setNeedsLayout];
}  
-(void)clickRightBtn:(UIButton *)rightBtn
{
    SystemMsgController *systemMsgVC = [[SystemMsgController alloc] init];
    [self.navigationController pushViewController:systemMsgVC animated:YES];
}
- (void)setUI
{
    [self setBMK];
    [self setBg_TableViewWithConstraints:nil];
}

- (void)setBMK
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
#warning 设置初始值，上线后删除
//    [kUserDefault setObject:floatToStr(31.52) forKey:@"CoachUserLocationLatitude"];
//    [kUserDefault setObject:floatToStr(117.17) forKey:@"CoachUserLocationLongitude"];
    [kUserDefault setObject:floatToStr(32.572815) forKey:@"CoachUserLocationLatitude"];
    [kUserDefault setObject:floatToStr(117.662926) forKey:@"CoachUserLocationLongitude"];
    [kUserDefault setObject:@"合肥" forKey:@"CoachAreaName"];  //全称
    [kUserDefault setObject:@"2" forKey:@"CoachAreaID"]; //地区ID
}

// banner
- (void)setAlbumWithSuperView:(UIView *)superView
{
    NSArray *imagesURLStrings = bannersImgArr;
//    NSArray *imagesURLStrings = @[
//                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf=425,260,50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
//                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf=425,260,50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//                                  @"http://c.hiphotos.baidu.com/image/w=400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
//                                  ];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 320, kScreenWidth, 180)imageURLStringsGroup:imagesURLStrings]; // 模拟网络延时情景
    cycleScrollView.pageControlAliment =SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;
//    cycleScrollView.titlesGroup = titles;
//    cycleScrollView.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.autoScrollTimeInterval = 3.0f;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"iconfont-defaultbanner"];
    [superView addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setFunctionViewWithSuperView:(UIView *)superView
{
    UIView *lineView = [UIView new];
    [superView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(kLineWidth);
    }];
    lineView.backgroundColor = kLineGrayColor;
    
    CGFloat topSep = 10;
    CGFloat leftSep = -5;
    CGFloat btnWidth = 100;
    CGFloat btnHeight = 90;
    CGFloat intelSep = (kScreenWidth - leftSep*2 - btnWidth *4)/3;
    
    NSArray *btnImgNameArr = @[@"iconfont-scanvalidate",@"iconfont-homeaddstudent",@"iconfont-homemystudent",@"iconfont-jiaoxuejiqiao",@"iconfont-homeearnmoney",@"iconfont-examtime"];
    NSArray *btnTitleArr = @[@"扫码验证",@"添加学员",@"我的学员",@"教学技巧",@"赚外快",@"考场学时"];
    for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 4; col++) {
            if ((row==1) && (col==1)) {
                return;
            }
            LLButton *fun_Btn = [LLButton buttonWithType:UIButtonTypeCustom];
            fun_Btn.frame = CGRectMake(leftSep+col*(btnWidth+intelSep), btnHeight*row + topSep, btnWidth, btnHeight);
            [fun_Btn setTitle:btnTitleArr[row*4+col] forState:UIControlStateNormal];
            [fun_Btn setImage:[UIImage imageNamed:btnImgNameArr[row*4+col]] forState:UIControlStateNormal];
            [fun_Btn setTitleColor:kGrayHex33 forState:UIControlStateNormal];
            [superView addSubview:fun_Btn];
            fun_Btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [fun_Btn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextBottom imageTitleSpace:10];
            [fun_Btn addTarget:self action:@selector(clickFuctionBtn:) forControlEvents:UIControlEventTouchUpInside];
            fun_Btn.tag = row*4+col;
        }
    }
    
}

- (void)setRankListWithSuperView:(UIView *)superView
{
    superView.superview.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [tableRowHeightArr[2] floatValue]-12.5)];
    bgView.backgroundColor = [UIColor whiteColor];
    [superView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(12.5, 0, 0, 0));
    }];
    [bgView addTopBorderWithHeight:kLineWidth andColor:kLineGrayColor];
    [bgView addBottomBorderWithHeight:kLineWidth andColor:kLineGrayColor];
    bgView.clipsToBounds = YES;
    
    CGFloat topImgInterval = kControlLeftSep;
    UIImageView *topImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RankList_CoachTop"]];
    [bgView addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(topImgInterval);
        make.bottom.offset(-10);
        make.top.offset(10);
        make.width.equalTo(topImgView.mas_height);
    }];
    
    UIImageView *trumpetImgView = [[UIImageView alloc] init];
    [bgView addSubview:trumpetImgView];
    [trumpetImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImgView.mas_right).offset(18);
        make.width.height.equalTo(topImgView.mas_height).multipliedBy(0.45);
        make.centerY.equalTo(trumpetImgView.superview.mas_centerY);
    }];
    [trumpetImgView setImage:[UIImage imageNamed:@"RankList_Trumpet"]];
    
    UIButton *rankMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:rankMoreBtn];
    [rankMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.width.equalTo(rankMoreBtn.mas_height);
    }];
    [rankMoreBtn setImage:[UIImage imageNamed:@"RankList_More"] forState:UIControlStateNormal];
    [rankMoreBtn addTarget:self action:@selector(clickRankBtn:) forControlEvents:UIControlEventTouchUpInside];
    rankMoreBtn.tag = 20;
    rankMoreBtn.userInteractionEnabled = NO;
    
    BBCyclingLabel *rankListLbl = [[BBCyclingLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-15-(65+12.5), 65) andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
    [bgView addSubview:rankListLbl];
    [rankListLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(trumpetImgView.mas_right).offset(10);
        make.top.bottom.offset(0);
        make.right.equalTo(rankMoreBtn.mas_left).offset(-10);
    }];
    //    [rankListLbl setTitle:@"最美教练投票排行公布了最新榜" forState:UIControlStateNormal];
    [rankListLbl setLineBreakMode:NSLineBreakByTruncatingTail];
    rankListLbl.textColor = kGrayHex66;
    rankListLbl.font = [UIFont systemFontOfSize:14];
    rankListLbl.tag = 500;
    rankListLbl.numberOfLines = 1;
    [rankListTimer setFireDate:[NSDate distantPast]];
//    UITapGestureRecognizer *tapRankLbl = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRankLbl:)];
//    [rankListLbl addGestureRecognizer:tapRankLbl];
}

- (void)tapRankLbl:(UITapGestureRecognizer *)tap
{
//    checkLogin()
//    if (coachCommunityArr.count>rankIndex) {
//        NSDictionary *clickTopDic = coachCommunityArr[rankIndex];
//        NSLog(@"communityUrl===>%@",clickTopDic[@"communityUrl"]);
//        if (!isEmptyStr(clickTopDic[@"communityUrl"])) {
//            
//            NSString *momentId = numToStr(clickTopDic[@"communityId"]);
//            NSString *componentStr = [NSString stringWithFormat:@"/community/show/%@?uid=%@&app=1&cityid=%@&address=%@",momentId,kUid,kCityID,kAddress];
//            
////            LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:clickTopDic[@"communityUrl"]] title:nil rightImgName:nil];
//            LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:[WAP_HOST_ADDR stringByAppendingString:componentStr]] title:@"圈子详情" rightImgName:nil];
//            
//            CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
//            webVC.js_Manager = js_Manager;
//            webVC.object = @(1);
//            
//            
//            [self.navigationController pushViewController:webVC animated:YES];
//        }
//    }
    
    if (isEmptyArr(coachCommunityArr)) {
        return;
    }
    
    CircleTopLineController *vc = [[CircleTopLineController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.url = [NSString stringWithFormat:@"%@%@",WAP_HOST_ADDR,@"/circle?circleId=2"];
    vc.url2 = [NSString stringWithFormat:@"%@%@",WAP_HOST_ADDR,@"/topic?circleId=2"];
    
    vc.object = @"2";
    
    CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
    vc.js_Manager = js_Manager;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rankListTimerHandle:(NSTimer *)timer
{
    UITableViewCell *cell = [self.bg_TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    BBCyclingLabel *cyclingLbl = [cell.contentView viewWithTag:500];
    rankIndex++;
    if (rankIndex>=coachCommunityArr.count) {
        rankIndex=0;
    }
    if (coachCommunityArr.count>rankIndex) {
        NSDictionary *dic = coachCommunityArr[rankIndex];
        [cyclingLbl setText:dic[@"communityTitle"] animated:YES];
    }
}

- (void)setAdmissionsWithSuperView:(UIView *)superView
{
    superView.superview.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [tableRowHeightArr[3] floatValue]-12.5*2+1)];
    [superView addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(12.5, 0, 12.5, 0));
    }];
    [bgView addTopBorderWithHeight:kLineWidth andColor:kLineGrayColor];
    [bgView addBottomBorderWithHeight:kLineWidth andColor:kLineGrayColor];
    
    UIView *decorationView = [UIView new];
    [bgView addSubview:decorationView];
    decorationView.backgroundColor = kAppThemeColor;
    decorationView.layer.cornerRadius = 3;
    decorationView.layer.masksToBounds = YES;
    [decorationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kControlLeftSep);
        make.top.offset(kDecorationTopOffset);
        make.width.offset(6.5);
        make.height.offset(kDecorationHeight);
    }];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    [bgView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(decorationView.mas_right).offset(5);
        make.centerY.equalTo(decorationView);
        make.width.offset(80);
        make.height.offset(30);
    }];
    titleLbl.text = @"招生神器";
    titleLbl.textColor = kGrayHex33;
    titleLbl.font = [UIFont boldSystemFontOfSize:15];

    LLCouponView *couponView = [[LLCouponView alloc] initWithFrame:CGRectMake(0, kDecorationTopOffset*2+kDecorationHeight, kScreenWidth/2, [tableRowHeightArr[3] floatValue]-(kDecorationHeight+kDecorationTopOffset*2)-12.5*2)];
    [bgView addSubview:couponView];
    couponView.delegate = self;
    [couponView.couponBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-homecouponbg"] forState:UIControlStateNormal];
    NSMutableAttributedString *leftAttStr = [NSMutableAttributedString attributeStringWithText:@"代金券" attributes:@[[UIColor colorWithHexString:@"4c4c4c"],[UIFont boldSystemFontOfSize:18*kWidthScale]]];
    [leftAttStr appendBreakLineWithInterval:4];
    [leftAttStr appendText:@"立减200元" withAttributesArr:@[[UIColor colorWithHexString:@"666666"],@(10*kWidthScale)]];
    [leftAttStr appendBreakLineWithInterval:7];
    [leftAttStr appendText:@"有效期:" withAttributesArr:@[kGrayHex88,@(7*kWidthScale)]];
    [leftAttStr appendBreakLineWithInterval:2];
    [leftAttStr appendText:@"2016.7.30-2016.8.30" withAttributesArr:@[kGrayHex88,@(7*kWidthScale)]];
    [couponView.leftLbl setAttributedText:leftAttStr];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15f];
    shadow.shadowOffset = CGSizeMake(-2, 3);
    NSMutableAttributedString *rightAttrStr = [NSMutableAttributedString attributeStringWithText:@"¥" attributes:@[[UIColor whiteColor],@(12),@{NSShadowAttributeName:shadow,NSObliquenessAttributeName:@0.2}]];
    [rightAttrStr appendText:@"200" withAttributesArr:@[[UIColor whiteColor],[UIFont boldSystemFontOfSize:22.5*kWidthScale],@{NSShadowAttributeName:shadow,NSObliquenessAttributeName:@0.2}]];
    [rightAttrStr appendBreakLineWithInterval:8];
    [rightAttrStr appendText:@"优惠券" withAttributesArr:@[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5],@(8*kWidthScale),@{NSObliquenessAttributeName:@0.2}]];
    [rightAttrStr appendBreakLineWithInterval:8];
    [rightAttrStr appendText:@"可报名使用" withAttributesArr:@[[UIColor whiteColor],@(7*kWidthScale),@{NSObliquenessAttributeName:@0.2}]];
    [couponView.rightLbl setAttributedText:rightAttrStr];
    
    NSArray *btnImgNameArr = @[@"weimingpian",@"iconfont-homelaba"];
    NSArray *btnTitleArr1   = @[@"微名片",@"招生团"];
    NSArray *btnTitleArr2   = @[@"让学生更快认识你",@"迎新大促等你来"];
    for (int i = 0; i < 2; i++) {
        LLButton *btn = [LLButton buttonWithType:UIButtonTypeCustom];
        [bgView addSubview:btn];
        btn.frame = CGRectMake(couponView.frame.origin.x+couponView.frame.size.width, couponView.frame.origin.y+i*couponView.frame.size.height/2, kScreenWidth-(couponView.frame.origin.x+couponView.frame.size.width), couponView.frame.size.height/2);
        [btn setImage:[UIImage imageNamed:btnImgNameArr[i]] forState:UIControlStateNormal];
        NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:btnTitleArr1[i] attributes:@[[UIColor colorWithHexString:@"4c4c4c"],[UIFont boldSystemFontOfSize:18*kWidthScale]]];
        [attStr appendBreakLineWithInterval:6];
        [attStr appendText:btnTitleArr2[i] withAttributesArr:@[kGrayHex66,@(12*kWidthScale)]];
        [btn setAttributedTitle:attStr forState:UIControlStateNormal];
        btn.titleLabel.numberOfLines = 0;
        [btn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextLeft imageTitleSpace:14];
        if (i==0) {
            btn.layer.borderWidth = kLineWidth;
            btn.layer.borderColor = kLineWhiteColor.CGColor;
        }
        else {
            [btn addLeftBorderWithWidth:kLineWidth andColor:kLineWhiteColor];
//            [btn addLeftBorderWithWidth:1.0f andColor:kLineWhiteColor];
            btn.titleEdgeInsets = UIEdgeInsetsMake(btn.titleEdgeInsets.top, btn.titleEdgeInsets.left-6, btn.titleEdgeInsets.bottom, btn.titleEdgeInsets.right+6);
        }
        [btn addTarget:self action:@selector(clickAdmissionBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+10;
    }
}

- (void)setCoachToolsWithSuperView:(UIView *)superView
{
    superView.superview.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [tableRowHeightArr[4] floatValue]-kSepViewHeight)];
    [superView addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, kSepViewHeight, 0));
    }];
    [bgView addTopBorderWithHeight:kLineWidth andColor:kLineGrayColor];
    [bgView addBottomBorderWithHeight:kLineWidth andColor:kLineGrayColor];
    
    UIView *decorationView = [UIView new];
    [bgView addSubview:decorationView];
    decorationView.backgroundColor = kAppThemeColor;
    decorationView.layer.cornerRadius = 3;
    decorationView.layer.masksToBounds = YES;
    [decorationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kControlLeftSep);
        make.top.offset(kDecorationTopOffset);
        make.width.offset(6.5);
        make.height.offset(kDecorationHeight);
    }];
    
    CGFloat toolsLblHeight = 40;
    UILabel *toolsLbl = [UILabel new];
    [bgView addSubview:toolsLbl];
    [toolsLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(decorationView.mas_right).offset(5);
        make.centerY.equalTo(decorationView);
        make.width.offset(80);
        make.height.offset(toolsLblHeight);
    }];
    toolsLbl.text = @"教练福利";
    toolsLbl.font = [UIFont boldSystemFontOfSize:15];
    toolsLbl.textColor = kGrayHex33;
    
    int btnNumHorizontal = 2;
    CGFloat topSep = kDecorationTopOffset*2+kDecorationHeight;
    CGFloat leftSep = 0;
    CGFloat btnWidth = kScreenWidth/btnNumHorizontal;
    CGFloat btnHeight = ([tableRowHeightArr[4] floatValue] - topSep - kSepViewHeight)/2;
    CGFloat intelSep = (kScreenWidth - leftSep*2 - btnWidth*btnNumHorizontal)/(btnNumHorizontal-1);
    NSArray *btnImgNameArr = @[@"Home_CoachCarRent",@"Home_AreaRent",@"Home_ExamCandidate",@"Home_CoachImprest"];
    NSArray *btnTitleArr1 = @[@"教练车",@"训练场",@"考试",@"教练"];
    NSArray *btnTitleArr2 = @[@"租赁",@"租赁",@"名额",@"备用金"];
    NSArray *btnTitleArr3 = @[@"让教学更快更轻松",@"带领学员快速学车",@"便捷安排学员考试",@"应急开支不用愁"];
    NSArray *btnAttrArr  = @[[UIColor colorWithHexString:@"f96767"],[UIColor colorWithHexString:@"6d5ddd"],[UIColor colorWithHexString:@"ffac33"],[UIColor colorWithHexString:@"27d1c3"]];
    
    for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 2; col++) {
            LLButton *toolsBtn = [LLButton buttonWithType:UIButtonTypeCustom];
            [bgView addSubview:toolsBtn];
            toolsBtn.frame = CGRectMake(leftSep+col*(btnWidth+intelSep), btnHeight*row + topSep, btnWidth, btnHeight);
            [toolsBtn setImage:[UIImage imageNamed:btnImgNameArr[row*2+col]] forState:UIControlStateNormal];
            [toolsBtn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextRight imageTitleSpace:10];
//            toolsBtn.imageEdgeInsets = UIEdgeInsetsMake(toolsBtn.imageEdgeInsets.top-(col==0?8:5) ,toolsBtn.imageEdgeInsets.left+18, toolsBtn.imageEdgeInsets.bottom+(col==0?8:5), toolsBtn.imageEdgeInsets.right-18);
//            toolsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -0, -0-0/2.0, 0);
            [toolsBtn setIsShowColorBgWhenTouch:YES highlightedBgColor:@"0X5bb5fe" highlightedBgAlpha:@(0.5)];
            toolsBtn.titleLabel.numberOfLines = 0;
            toolsBtn.layer.borderWidth = kLineWidth;
            toolsBtn.layer.borderColor = kLineWhiteColor.CGColor;
            
            if((row==0)&&(col==1))
            {
                UIImageView *hotImgView = [[UIImageView alloc] init];
                [toolsBtn addSubview:hotImgView];
                [hotImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.offset(0);
                    make.width.equalTo(hotImgView.mas_height);
                    make.height.equalTo(toolsBtn.mas_height).multipliedBy(0.3);
                }];
                hotImgView.image = [UIImage imageNamed:@"hot"];
            }
            
            BOOL isCoachImprest = (row==1)&&(col==1);  //是否是教练备用金
            NSInteger index = row*2+col;
            NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:btnTitleArr1[index] attributes:@[btnAttrArr[index],isCoachImprest?@(16):[UIFont boldSystemFontOfSize:16]]];
            [attStr appendText:btnTitleArr2[index] withAttributesArr:@[btnAttrArr[index],isCoachImprest?[UIFont boldSystemFontOfSize:16]:@(16)]];
            [attStr appendBreakLineWithInterval:5];
            [attStr appendText:btnTitleArr3[index] withAttributesArr:@[kGrayHex66,@(11*kWidthScale)]];
            
            [toolsBtn setAttributedTitle:attStr forState:UIControlStateNormal];
            
            [toolsBtn addTarget:self action:@selector(clickCoachToolsBtn:) forControlEvents:UIControlEventTouchUpInside];
            toolsBtn.tag = row*2+col;
        }
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableRowHeightArr[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
        {
            [self setAlbumWithSuperView:cell.contentView];
        }
            break;
        case 1:
        {
            [self setFunctionViewWithSuperView:cell.contentView];
        }
            break;
        case 2:
        {
            [self setRankListWithSuperView:cell.contentView];
        }
            break;
        case 3:
        {
            [self setAdmissionsWithSuperView:cell.contentView];
        }
            break;
        case 4:
        {
            [self setCoachToolsWithSuperView:cell.contentView];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        [self tapRankLbl:nil];
    }
}

#pragma mark - SDCycleScrollViewDelegate 
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *dic = bannersArr[index];
    switch ([dic[@"pageType"] intValue]) {
        case 1:
        {
            //不能点击
            
        }
            break;
        case 2:
        {
            //跳转到原生界面
            
        }
            break;
        case 3:
        {
            //跳转到wap
            LLWebViewController *webViewController = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:isEmptyStr(dic[@"pageUrl"])?@"":dic[@"pageUrl"]] title:@"" rightImgName:nil];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    
}


#pragma mark - BMKLocationService Delegate

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
#pragma mark -- 暂时隐掉
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    ----
    
    
    [kUserDefault setObject:floatToStr(userLocation.location.coordinate.latitude) forKey:@"CoachUserLocationLatitude"];
    [kUserDefault setObject:floatToStr(userLocation.location.coordinate.longitude) forKey:@"CoachUserLocationLongitude"];
    
#warning  测试address:117.662926,32.572815 上线后更改
//        [kUserDefault setObject:floatToStr(32.572815) forKey:@"CoachUserLocationLatitude"];
//        [kUserDefault setObject:floatToStr(117.662926) forKey:@"CoachUserLocationLongitude"];
    
    
    //反向地理编码

        CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    
         CLLocation *cl = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
        [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
        
                for (CLPlacemark *placeMark in placemarks) {
  
                         NSDictionary *addressDic = placeMark.addressDictionary;
  
                         NSString *state=[addressDic objectForKey:@"State"];
            
                         NSString *city=[addressDic objectForKey:@"City"];
            
                         NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            
                         NSString *street=[addressDic objectForKey:@"Street"];
        
//                         NSLog(@"所在城市====%@ %@ %@ %@", state, city, subLocality, street);
                    
                        [self.leftBtn setTitle:city forState:UIControlStateNormal];
                    
                        CGSize locationSize = [city sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
                    
                        self.leftBtn.width = ((float)locationSize.width+10)*4/3;
                    
                        [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.leftBtn.frame.size.width/1.5+5/2.0, 0, -self.leftBtn.frame.size.width/1.5-5/2.0)];
                    
                        [USER_DEFAULT setObject:city forKey:@"CoachAreaName"];
                    
                    
                        [LLAddress getCityId:city completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
                        if (isSuccess) {
//                            NSLog(@"2222=====>countyID : %@\n 2222==>countyName : %@",areaID,areaName);
                            [kUserDefault setObject:areaName forKey:@"CoachAreaName"]; //全称
                            [kUserDefault setObject:areaID forKey:@"CoachAreaID"];     //地区ID
                        }
                        }];
                    
                         [_locService stopUserLocationService];
             
                     }
         
             }];
}

- (void)clickBarBtnItem:(UIBarButtonItem *)barBtnItem
{
    if (barBtnItem.tag == 10) {
        //clicked left bar button
        
    }
    else if(barBtnItem.tag == 20)
    {
        //clicked right bar button
        
    }
    WalletViewController *walletVC = [[WalletViewController alloc] init];
    [self.navigationController pushViewController:walletVC animated:YES];
}

//功能区
- (void)clickFuctionBtn:(LLButton *)functionBtn
{
//    checkLogin()
    switch (functionBtn.tag) {
        case 0:
        {
            //扫码验证
            checkLogin()
            ScanningController *scan = [[ScanningController alloc]init];
            [self presentViewController:scan animated:YES completion:nil];
            
        }
            break;
        case 1:
        {
            //添加学员
            AddStudentVC   *addStudentVC = [[AddStudentVC alloc] init];
            [self.navigationController pushViewController:addStudentVC animated:YES];
        }
            break;
        case 2:
        {
            //我的学员
            MyStudentVC * myStudentsVC = [[MyStudentVC alloc]init];
            myStudentsVC.isShowRightBtn = YES;
            [self.navigationController pushViewController:myStudentsVC animated:YES];
            
        }
            break;
        case 3:
        {
            //教学技巧
            TeachingSkillsController * teachingSkillsVC = [[TeachingSkillsController alloc] init];
            [self.navigationController pushViewController:teachingSkillsVC animated:YES];
            
        }
            break;
        case 4:
        {
            //赚外快
            checkLogin()
            EarnExtraMoneyController * earnExtraMoneyVC = [[EarnExtraMoneyController alloc]init];
            [self.navigationController pushViewController:earnExtraMoneyVC animated:YES];
            
//            EarnWindfallVC * vc = [[EarnWindfallVC alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 5:
        {
            //考场学时
            ExamStudyHourVC * examStudyHourVC = [[ExamStudyHourVC alloc] init];
            [self.navigationController pushViewController:examStudyHourVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

//教练头条
- (void)clickRankBtn:(UIButton *)rankBtn
{
    if (rankBtn.tag==10) {
        //点击了排行榜
        
    }
    else if(rankBtn.tag==20)
    {
        //点击了排行榜的更多
        
    }
}

- (void)requestAllowEditData:(requestCompletionBlock)block
{
    [LLUtils showTextAndProgressHud:@"正在加载"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = kTimeStamp;
    param[@"sign"] = kSignWithIdentify(@"/card/AllowEdit");
    
    [NetworkEngine postRequestWithRelativeAdd:@"/card/AllowEdit" paraDic:param completeBlock:^(BOOL isSuccess, id jsonObj) {
        [LLUtils dismiss];
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
//                NSString * jstr = [LLUtils jsonStrWithJSONObject:jsonObj];
//                NSString * str = [LLUtils replaceUnicode:jstr];
//                NSLog(@"%@",str);
                
                block([jsonObj[@"info"][@"state"] intValue]);
                
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
            else
            {
                //失败
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
                
            }
            
        }
    }
    ];
}

//招生神器
- (void)clickAdmissionBtn:(LLButton *)admissionBtn
{
//    checkLogin()
//    NSLog(@"%ld", (long)admissionBtn.tag);
    switch (admissionBtn.tag) {
        case 10:
        {
            //微名片
            NSString *cardId = kUid;
            NSString *componentStr = [NSString stringWithFormat:@"/card/show/%@?uid=%@&app=1&cityid=%@&address=%@",cardId,kUid,kCityID,kAddress];
            
            LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:[WAP_HOST_ADDR stringByAppendingPathComponent:componentStr]] title:@"微名片" rightImgName:nil];
//            webVC.rightText = @"编辑";
            webVC.delegate = self;
            
            MricoCardJSManager *js_manager = [[MricoCardJSManager alloc] init];
            webVC.js_Manager = js_manager;
            
            [self.navigationController pushViewController:webVC animated:YES];
            
            [self requestAllowEditData:^(int state) {
                if (state==1) {
                    [webVC setRightText:@"编辑" textColor:nil ImgPath:nil];
                }
                else if (state == 2)
                {
                    [webVC setRightText:@"" textColor:nil ImgPath:nil];
                }
            }];
            
            if (!isLogin) {
                //未登陆
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [webVC loadFailWeb];
                });
            }
            
        }
            break;
        case 11:
        {
            //招生团
            MyAdmissionsVC *myAdmissionVC = [[MyAdmissionsVC alloc] init];
            [self.navigationController pushViewController:myAdmissionVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - LLWebViewControllerDelegate

- (void)LLWebViewController:(LLWebViewController *)vc clickRightBtn:(UIButton *)rightBtn;
{
    checkLogin()
    BusinessCardController * businessCardVC = [[BusinessCardController alloc]init];
    businessCardVC.webVC = vc;
    [self.navigationController pushViewController:businessCardVC animated:YES];
}


//教练福利
- (void)clickCoachToolsBtn:(LLButton *)toolsBtn
{
//    checkLogin()
    switch (toolsBtn.tag) {
        case 0:
        {
            //教练车租赁
            RentViewController *rentVC = [[RentViewController alloc] init];
            rentVC.type = RentViewControllerTypeCoachCarRent;
            [self.navigationController pushViewController:rentVC animated:YES];
        }
            break;
        case 1:
        {
            //训练场租赁
            RentViewController *rentVC = [[RentViewController alloc] init];
            rentVC.type = RentViewControllerTypePlaceRent;
            [self.navigationController pushViewController:rentVC animated:YES];
        }
            break;
        case 2:
        {
            //考试名额
//            ExamPlacesViewController * examPlacesVC = [[ExamPlacesViewController alloc]init];
//            [self.navigationController pushViewController:examPlacesVC animated:YES];

//            KSMEController *ksme = [[KSMEController alloc]init];
//            [self.navigationController pushViewController:ksme animated:YES];
            
            MEHZController * vc = [[MEHZController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        
        }
            break;
        case 3:
        {
            //教练备用金
            LLWebViewController *coachImprestVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:kCoachImprestUrl] title:@"教练备用金" rightImgName:nil];
            [self.navigationController pushViewController:coachImprestVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - LLCouponViewDelegate

- (void)LLCouponView:(UIView *)view clickCouponBtn:(UIButton *)couponBtn;
{
//    checkLogin()
   //代金券
//    VoucherController * VoucherVC = [[VoucherController alloc] init];
//    [self.navigationController pushViewController:VoucherVC animated:YES];
    
    DJJViewController *ddj = [[DJJViewController alloc]init];
    [self.navigationController pushViewController:ddj animated:YES];
    
}

#pragma mark - Network

- (void)requestData
{
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/main" paraNameArr:@[@"uid",@"time",@"deviceInfo",@"sign"] paraValueArr:@[kUid,kTimeStamp,kDeviceInfo,kSignWithIdentify(@"/main")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                bannersArr = jsonObj[@"info"][@"banners"];
                bannersImgArr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in bannersArr) {
                    [bannersImgArr addObject:isEmptyStr(dic[@"imgUrl"])?@"":dic[@"imgUrl"]];
                }
                coachCommunityArr = jsonObj[@"info"][@"coachCommunity"];
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                [indexSet addIndex:0];
                [indexSet addIndex:2];
                [self.bg_TableView reloadData];
            }
            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
            {
                //需要登录
                
            }
            else
            {
                
            }
        }
    }];
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
