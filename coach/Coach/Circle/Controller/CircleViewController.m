//
//  CircleViewController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MessageDataBase.h"
#import "MyCircleViewController.h"
#import "CircleJSManager.h"
#import <IQKeyboardManager.h>
#import "ChatBarContainer.h"
#import "CircleViewController.h"
#import "CircleMainContentCell.h"
#import "CircleMainModel.h"
#import "CircleMainFrameModel.h"
#import "CircleMessageCell.h"
#import "CircleZanMessageCell.h"
#import "CircleHeaderView.h"
#import <JSBadgeView.h>
#import "SendCircleMessegeController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "CircleHeadModel.h"
#import <MWPhotoBrowser.h>
//#import "CircleDetailWebController.h"

#import "HJHttpManager.h"
#import "HttpParamManager.h"
#import "LLWebViewController.h"

#import "CircleTopLineController.h"

@interface CircleViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CircleMainContentCellDelegate,MWPhotoBrowserDelegate>

@property(nonatomic,strong)UISegmentedControl * segmentControl;

@property(nonatomic,strong)UITableView * platFormTableView;

@property(nonatomic,strong)UITableView * studentTableView;

@property(nonatomic,strong)UIScrollView * bgScrollView;

@property(nonatomic,strong)NSMutableArray * studentDataFrameArray;

@property(nonatomic,strong)NSMutableArray * platFormDataArray;

@property(nonatomic,strong)CircleHeadModel * studentHeadData;

@property(nonatomic,strong)CircleHeadModel * platHeadData;

@property(nonatomic,strong)CircleHeaderView * platFormHeaderView;

@property(nonatomic,strong)CircleHeaderView * studentHeaderView;

@property(nonatomic,strong)UIButton * sendMessgaeBtn;

@property(nonatomic,strong)UIButton * rightBtn;

@property(nonatomic,strong)JSBadgeView * badgeView;

@property(nonatomic,assign)int typeId;

@property(nonatomic,assign)NSUInteger platFormPageId;

@property(nonatomic,assign)NSUInteger studentPageId;

@property(nonatomic,strong)NSString * commityType;

@property(nonatomic,strong)NSMutableArray *photos;

@property(nonatomic,assign)NSUInteger pageSize;   //记录一页返回多少条数据

@property(nonatomic,strong)ChatBarContainer *chat_Bar;

@end

@implementation CircleViewController

- (id)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = NO;
        
        [NOTIFICATION_CENTER addObserver:self selector:@selector(msgRead) name:kMakeMsgIsReadNotification object:nil];
        [NOTIFICATION_CENTER addObserver:self selector:@selector(msgRead) name:kUpdateMainMsgRedPointNotification object:nil];
        [NOTIFICATION_CENTER addObserver:self selector:@selector(loginStateChanged) name:kCoachUserLoginStateChangedNotificationName object:nil];
    }
    return self;
}

-(void)msgRead
{
    [self configNav];
}

- (void)loginStateChanged
{
    if (isLogin) {
        [self loadData];
    }
    else
    {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.platFormPageId = 1;
    
    self.studentPageId = 1;
    
    self.commityType = @"0";
    
    self.typeId = 0;

    self.view.backgroundColor = BG_COLOR;
    
    self.studentDataFrameArray = [NSMutableArray array];
    
    self.platFormDataArray = [NSMutableArray array];
    
    [self configNav];

    [self createSegment];
    
    [self createUI];

    [NOTIFICATION_CENTER addObserver:self selector:@selector(refreshCircle) name:kUpdateCircleNotification object:nil];
    
    
    //加载平台圈
    self.platFormPageId = 1;
    self.typeId = 0;
    [self loadData];

    
    
}
-(void)refreshCircle
{
    [self loadData];

}




-(void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    //切换的时候可能按钮导致不显示
    self.sendMessgaeBtn.alpha = 1.0f;

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}

-(void)configNav
{
    NSArray *navBtns = [self createNavWithLeftBtnImageName:nil leftHighlightImageName:nil leftBtnSelector:nil andCenterTitle:nil andRightBtnImageName:@"圈子_iconfont-circle-talk" rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick)];
    self.rightBtn = navBtns[1];
    self.rightBtn.width = 20;
    
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
        self.badgeView.badgeText = [NSString stringWithFormat:@"%ld",[[MessageDataBase shareInstance] queryCircleUnRead].count];
    }
    else
    {
        self.badgeView.badgeText = nil;
    }
    //当更新数字时，最好刷新，不然由于frame固定的，数字为2位时，红圈变形
    [self.badgeView setNeedsLayout];

}
-(void)rightBtnClick
{
    checkLogin()
    MyCircleViewController *myCircleVC = [[MyCircleViewController alloc] init];
    [self.navigationController pushViewController:myCircleVC animated:YES];
}
-(void)loadMoreData
{

    NSString *url = self.interfaceManager.getCommunity;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    if (self.typeId == 0) {
        param[@"pageId"] = @(self.platFormPageId);
    }
    else
    {
        param[@"pageId"] = @(self.studentPageId);
    }
    param[@"typeId"] = @(self.typeId);
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/community" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            
            NSArray *dataArray = [CircleMainModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];
            
            if (self.typeId == 0) {//平台圈
                
                for (int i = 0; i<dataArray.count; i++) {
                    CircleMainFrameModel *frameModel =[[CircleMainFrameModel alloc]init];
                    frameModel.circleMainModel = dataArray[i];
                    [self.platFormDataArray addObject:frameModel];
                }
                
                [_platFormTableView reloadData];
                
                [_platFormTableView.mj_footer endRefreshing];


            }
            else//学员圈
            {
                
                for (int i = 0; i<dataArray.count; i++) {
                    CircleMainFrameModel *frameModel =[[CircleMainFrameModel alloc]init];
                    frameModel.circleMainModel = dataArray[i];
                    [self.studentDataFrameArray addObject:frameModel];
                }
                
                [_studentTableView reloadData];
                
                [_studentTableView.mj_footer endRefreshing];


            }
            [self.hudManager dismissSVHud];
            
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_platFormTableView.mj_footer endRefreshing];
            [_studentTableView.mj_footer endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_platFormTableView.mj_footer endRefreshing];
        [_studentTableView.mj_footer endRefreshing];
    }];
    


}

-(void)refreshDataWithPage:(NSUInteger)page
{
    
    NSString *url = self.interfaceManager.getCommunity;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
//    if (self.typeId == 0) {
//        param[@"pageId"] = @(self.platFormPageId);
//    }
//    else if (self)
//    {
//        param[@"pageId"] = @(self.studentPageId);
//    }
    param[@"pageId"] = @(page);
    param[@"typeId"] = @(self.typeId);
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/community" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            
            NSArray *dataArray = [CircleMainModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];
            
            
            NSUInteger currentPageStartIndex = (page-1)*_pageSize;
//            NSUInteger currentPageEndIndex = (page+1)*_pageSize-1;
            
            if (self.typeId == 0) {//平台圈
                
                for (int i = 0; i<dataArray.count; i++) {
                    CircleMainFrameModel *frameModel =[[CircleMainFrameModel alloc]init];
                    frameModel.circleMainModel = dataArray[i];
//                    [self.platFormDataArray addObject:frameModel];
                    if (self.platFormDataArray.count>currentPageStartIndex+i) {
                       [self.platFormDataArray replaceObjectAtIndex:currentPageStartIndex+i withObject:frameModel];
                    }
                }
                
                [_platFormTableView reloadData];
                
//                [_platFormTableView.mj_footer endRefreshing];
                
                
            }
            else//教练圈
            {
                
                for (int i = 0; i<dataArray.count; i++) {
                    CircleMainFrameModel *frameModel =[[CircleMainFrameModel alloc]init];
                    frameModel.circleMainModel = dataArray[i];
//                    [self.studentDataFrameArray addObject:frameModel];
                    if (self.studentDataFrameArray.count>currentPageStartIndex+i) {
                        [self.studentDataFrameArray replaceObjectAtIndex:currentPageStartIndex+i withObject:frameModel];
                    }
                }
                
                [_studentTableView reloadData];
                
//                [_studentTableView.mj_footer endRefreshing];
                
                
            }
//            [self.hudManager dismissSVHud];
            
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_platFormTableView.mj_footer endRefreshing];
            [_studentTableView.mj_footer endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_platFormTableView.mj_footer endRefreshing];
        [_studentTableView.mj_footer endRefreshing];
    }];
    
    
    
}

-(void)loadData
{
    NSString *url = self.interfaceManager.getCommunity;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    if (self.typeId == 0) {
        param[@"pageId"] = @(self.platFormPageId);
    }
    else
    {
        param[@"pageId"] = @(self.studentPageId);
    }
    param[@"typeId"] = @(self.typeId);
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/community" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
           
            NSArray *dataArray = [CircleMainModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];
            self.platHeadData = [CircleHeadModel mj_objectWithKeyValues:dict[@"info"][@"headlines"]];
            
            _pageSize = dataArray.count;
            
            if (self.typeId == 0) {//平台圈
                
                self.platFormHeaderView.titleLabel.text = self.platHeadData.title;
                
                self.platFormHeaderView.subTitleLabel.text = self.platHeadData.content;
                
                self.platFormDataArray = [NSMutableArray array];
                
                for (int i = 0; i<dataArray.count; i++) {
                    CircleMainFrameModel *frameModel =[[CircleMainFrameModel alloc]init];
                    frameModel.circleMainModel = dataArray[i];
                    [self.platFormDataArray addObject:frameModel];
                }
                [_platFormTableView reloadData];

            }
            else//学员圈
            {
                
                self.studentHeaderView.titleLabel.text = self.platHeadData.title;
                
                self.studentHeaderView.subTitleLabel.text = self.platHeadData.content;
            
                self.studentDataFrameArray = [NSMutableArray array];
                
                for (int i = 0; i<dataArray.count; i++) {
                    CircleMainFrameModel *frameModel =[[CircleMainFrameModel alloc]init];
                    frameModel.circleMainModel = dataArray[i];
                    [self.studentDataFrameArray addObject:frameModel];
                }

                [_studentTableView reloadData];

            }
            [self.hudManager dismissSVHud];
            [_platFormTableView.mj_header endRefreshing];
            [_studentTableView.mj_header endRefreshing];

            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_platFormTableView.mj_header endRefreshing];
            [_studentTableView.mj_header endRefreshing];
        }
        
    } failed:^(NSError *error) {
//        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_platFormTableView.mj_header endRefreshing];
        [_studentTableView.mj_header endRefreshing];
    }];
    
}
-(void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSegment
{
    NSArray * segmentArray = @[@"平台圈",@"教练圈"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentControl.selectedSegmentIndex = 0;
    //设置segment的选中背景颜色
    _segmentControl.tintColor = [UIColor whiteColor];
    [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:kFont13} forState:UIControlStateNormal];
    _segmentControl.frame = CGRectMake(100, 0, kScreenWidth -200, 30);
    [_segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentControl;
}
-(void)segmentValueChanged:(UISegmentedControl *)segmentControl
{
    if (segmentControl.selectedSegmentIndex == 0) {
        [self.bgScrollView setContentOffset:CGPointZero animated:YES];
        [_platFormTableView.mj_header beginRefreshing];
        self.commityType = @"0";

    }else
    {
        [self.bgScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
        [_studentTableView.mj_header beginRefreshing];
        self.commityType = @"2";

    }
    
}
- (void)createUI
{
    
    
    //创建scrollView作为两张表的载体
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - kNavHeight-kTabBarHeight)];
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavHeight-kTabBarHeight);
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.alwaysBounceVertical = NO;
    _bgScrollView.delegate = self;
    _bgScrollView.bounces = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    //平台
    _platFormTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight-kTabBarHeight) style:UITableViewStylePlain];
    _platFormTableView.delegate = self;
    _platFormTableView.dataSource = self;
    _platFormTableView.backgroundColor = [UIColor clearColor];
    [_platFormTableView setExtraCellLineHidden];
    [_platFormTableView setCellLineFullInScreen];
    _platFormTableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    [_bgScrollView addSubview:_platFormTableView];
    [_platFormTableView registerClass:[CircleMainContentCell class] forCellReuseIdentifier:@"CircleMainContentCell"];
    
    
    __weak typeof(self) weakSelf = self;
    _platFormTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.platFormPageId = 1;
        
        weakSelf.typeId = 0;
        
        [weakSelf loadData];
        
    }];
    
    
    _platFormTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.platFormPageId ++;
        
        weakSelf.typeId = 0;

        [weakSelf loadMoreData];
        
    }];
    
    self.platFormTableView.mj_footer.automaticallyHidden = YES;
    
    //添加HeaderView
    CircleHeaderView *platFormHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"CircleHeaderView" owner:nil options:nil]lastObject];
    [platFormHeaderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(platFromHeaderClick)]];
    self.platFormHeaderView = platFormHeaderView;
    platFormHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 74);
    _platFormTableView.tableHeaderView = platFormHeaderView;
    _platFormTableView.sectionHeaderHeight = 82;
    
    //学员
    _studentTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kNavHeight-kTabBarHeight) style:UITableViewStylePlain];
    _studentTableView.delegate = self;
    _studentTableView.dataSource = self;
    [_studentTableView setExtraCellLineHidden];
    _studentTableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    [_studentTableView setCellLineFullInScreen];
    _studentTableView.backgroundColor = [UIColor clearColor];
    [_bgScrollView addSubview:_studentTableView];
    [_studentTableView registerClass:[CircleMainContentCell class] forCellReuseIdentifier:@"CircleMainContentCell"];
    
    _studentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.studentPageId = 1;
        
        weakSelf.typeId = 2;
        
        [weakSelf loadData];
        
    }];
    
    
    _studentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.studentPageId ++;
        
        weakSelf.typeId = 2;
        
        [weakSelf loadMoreData];
        
    }];
    
    self.studentTableView.mj_footer.automaticallyHidden = YES;
    

    //添加HeaderView
    CircleHeaderView *studentHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"CircleHeaderView" owner:nil options:nil]lastObject];
    [studentHeaderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(studentHeaderClick)]];
    self.studentHeaderView = studentHeaderView;
    studentHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 74);
    _studentTableView.tableHeaderView = studentHeaderView;
    _studentTableView.sectionHeaderHeight = 82;
    
    //添加发送圈子信息按钮
    self.sendMessgaeBtn = [[UIButton alloc]init];
    [self.sendMessgaeBtn setImage:[UIImage imageNamed:@"iconfont-circle-bianji"] forState:UIControlStateNormal];
    [self.sendMessgaeBtn addTarget:self action:@selector(sendMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendMessgaeBtn];
    [self.sendMessgaeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.bottom.offset(-10-kTabBarHeight);
        make.width.equalTo(@70);
        make.height.equalTo(@70);
    }];
    
    //创建评论TextField
    [self setComment_TextField];
}

- (void)setComment_TextField;
{
    _chat_Bar = [[ChatBarContainer alloc]init];
    _chat_Bar.max_Count = 140;
    _chat_Bar.myDelegate = self;
    [self.view addSubview:_chat_Bar];
    WeakObj(self)
    [_chat_Bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfWeak.view.mas_left);
        make.right.equalTo(selfWeak.view.mas_right);
        make.bottom.offset(-kTabBarHeight);
        make.height.offset(44);
    }];
    _chat_Bar.hidden = YES;
    //    UITapGestureRecognizer * resign_Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignChatBar)];
    //    [momentBg_TableView addGestureRecognizer:resign_Tap];
    //    resign_Tap.enabled = NO;
}

#pragma mark - ChatBarContainerDelegate

//点击评论发送按钮
- (void)ChatBarContainer:(ChatBarContainer *)chatBar clickSendWithContent:(NSString*)content;
{
    CircleMainFrameModel *model = chatBar.object;
    
    int idInt = model.circleMainModel.idNum;
    
    NSString *relativeAdd = @"/community/commentcreate";
    NSDictionary *paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"deviceInfo":kDeviceInfo,@"cityId":kCityID,@"address":kAddress,@"communityType":intToStr(self.typeId),@"id":intToStr(idInt),@"content":chatBar.txtView.text};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                NSLog(@"comment msg == > %@",jsonObj[@"msg"]);
                
                //计算当前Cell所在页码
                CircleMainContentCell *cell = chatBar.userInfo[@"CircleMainContentCell"];
                NSUInteger currentPageIndex = cell.indexPath.row/_pageSize+1;
                
                [self refreshDataWithPage:currentPageIndex];  //刷新对应页数据源 并reloadData
            }
            else
            {
                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            [LLUtils showErrorHudWithStatus:kRequestExceptionPrompt];
        }
    }];
    chatBar.alpha = 0;
    [chatBar.txtView resignFirstResponder];
}

- (void)chatBarDidBecomeActive;
{
    
}

-(void)platFromHeaderClick
{
//    CircleHeadModel *mainModel = self.platHeadData;
//    NSString * componentStr= [NSString stringWithFormat:@"%@/%@?app=1&uid=%@&cityId=%@&address=%@",mainModel.url,mainModel.idStr,kUid,kCityID,kAddress];
//    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:componentStr] title:nil rightImgName:nil];
//    [self.navigationController pushViewController:webVC animated:YES];
    

    CircleTopLineController *vc = [[CircleTopLineController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
    vc.url = self.platHeadData.url;
    vc.url2 = self.platHeadData.url2;
    vc.object = @"2";
    
    CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
    vc.js_Manager = js_Manager;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)studentHeaderClick
{
//    CircleHeadModel *mainModel = self.platHeadData;
//    NSString * componentStr= [NSString stringWithFormat:@"%@/%@?app=1&uid=%@&cityId=%@&address=%@",mainModel.url,mainModel.idStr,kUid,kCityID,kAddress];
//    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:componentStr] title:nil rightImgName:nil];
//    [self.navigationController pushViewController:webVC animated:YES];
    
    CircleTopLineController *vc = [[CircleTopLineController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.url = self.platHeadData.url;
    vc.url2 = self.platHeadData.url2;
    vc.object = @"2";
    
    CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
    vc.js_Manager = js_Manager;
    
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)sendMessageBtnClick
{
    checkLogin()
    SendCircleMessegeController *sendCircleVC = [[SendCircleMessegeController alloc]init];
    sendCircleVC.hidesBottomBarWhenPushed = YES;
    sendCircleVC.communityType = self.commityType;
    [self.navigationController pushViewController:sendCircleVC animated:YES];

}
#pragma mark -- tableView的代理和数据源
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;

}
//去掉悬浮效果
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _platFormTableView)
    {
        return self.platFormDataArray.count;
    }
    else
    {
        return self.studentDataFrameArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == _platFormTableView) {
        
        CircleMainFrameModel *frameModel = self.platFormDataArray[indexPath.row];
        
        return frameModel.cellHeight;
        
    }else {
        
        CircleMainFrameModel *frameModel = self.studentDataFrameArray[indexPath.row];
        
        return frameModel.cellHeight;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _platFormTableView) {
        
        static NSString * identifer = @"CircleMainContentCell";
        CircleMainContentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
        cell.delegate = self;
        cell.circleFrameModel = self.platFormDataArray[indexPath.row];
        cell.indexPath = indexPath;
        return cell;
        
    }
    else
    {
        
        static NSString * identifer = @"CircleMainContentCell";
        CircleMainContentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
        cell.delegate = self;
        cell.circleFrameModel = self.studentDataFrameArray[indexPath.row];
        cell.indexPath = indexPath;
        return cell;
        
    }
    
    
}

#pragma mark - CircleMainContentCellDelegate

-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickImageViewWithImageUrl:(NSString *)url index:(int)index
{

    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    NSArray *arr = cell.circleFrameModel.circleMainModel.pic;
    for (int i = 0; i<arr.count; i++) {
        NSString *str = arr[i][@"imgpath"];
        str = [self getOriginImageUrlWithUrl:str];
        NSURL *url = [NSURL URLWithString:str];
        MWPhoto *photo = [MWPhoto photoWithURL:url];
        [photos addObject:photo];
    }
    self.photos = photos;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];



}

- (NSString *)getOriginImageUrlWithUrl:(NSString *)url
{
    NSMutableArray *originUrlArr = [[url componentsSeparatedByString:@"."] mutableCopy];
    if (originUrlArr.count>originUrlArr.count-2) {
        originUrlArr[originUrlArr.count-2] = [originUrlArr[originUrlArr.count-2] stringByAppendingString:@"_original"];
        NSString *originUrl = [originUrlArr componentsJoinedByString:@"."];
        if (isEmptyStr(originUrl)) {
            return @"";
        }
        else
        {
            return originUrl;
        }
    }
    else
    {
        return @"";
    }
}

-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickZanBtnWithModel:(CircleMainFrameModel *)frameModel
{
    checkLogin()
    //点击点赞
    NSString *circleId = intToStr(frameModel.circleMainModel.idNum);
    
    NSString *relativeAdd = @"/community/praise";
    
    //计算当前Cell所在页码
    NSUInteger currentPageIndex = cell.indexPath.row/_pageSize+1;
    
    [self likeRequestWithRelativeAdd:relativeAdd Id:circleId currentPageIndex:currentPageIndex];
}
-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickCommentZanBtnWithModel:(CircleMainFrameModel *)frameModel
{
    checkLogin()
    //点击评论的点赞按钮
    NSString *circleId = intToStr(frameModel.circleMainModel.comemnt.idNum);
    
    NSString *relativeAdd = @"/community/commentpraise";
    
    //计算当前Cell所在页码
    NSUInteger currentPageIndex = cell.indexPath.row/_pageSize+1;
    
    [self likeRequestWithRelativeAdd:relativeAdd Id:circleId currentPageIndex:currentPageIndex];
}

-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickCommentBtnWithModel:(CircleMainFrameModel *)frameModel
{
    checkLogin()
    //点击评论
    _chat_Bar.hidden = NO;
    _chat_Bar.object = frameModel;
    _chat_Bar.userInfo = @{@"CircleMainContentCell":cell};
    [_chat_Bar.txtView becomeFirstResponder];

}

//发起点赞请求
- (void)likeRequestWithRelativeAdd:(NSString *)relativeAdd Id:(NSString *)Id currentPageIndex:(NSUInteger)pageIndex
{
    NSDictionary *paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"deviceInfo":kDeviceInfo,@"cityId":kCityID,@"address":kAddress,@"id":Id};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                //刷新页面
               
                //刷新对应页的数据源并reloadData
                [self refreshDataWithPage:pageIndex];
            }
            else
            {
//                [LLUtils showErrorHudWithStatus:jsonObj[@"msg"]];
            }
        }
        else
        {
            [LLUtils showErrorHudWithStatus:kRequestExceptionPrompt];
        }
    }];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self leftBtnClick];
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    CircleDetailWebController *circleDetail  =[[CircleDetailWebController alloc]init];
//    
//    circleDetail.hidesBottomBarWhenPushed = YES;
//    
//    CircleMainFrameModel *mainModel = self.platFormDataArray[indexPath.row];
//    
//    circleDetail.urlString = [NSString stringWithFormat:@"%@/%d?app=1&uid=%@&cityId=%ld&address=%@,%@",self.interfaceManager.circleDetailUrl,mainModel.circleMainModel.idNum,kUid,[HttpParamManager getCurrentCityID],[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
//    [self.navigationController pushViewController:circleDetail animated:YES];
    
    CircleMainFrameModel *model = [_commityType intValue]==0?_platFormDataArray[indexPath.row]:_studentDataFrameArray[indexPath.row];
    NSString *momentId = intToStr(model.circleMainModel.idNum);
    NSString *componentStr = [NSString stringWithFormat:@"/community/show/%@?uid=%@&app=1&cityid=%@&address=%@",momentId,kUid,kCityID,kAddress];
    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:[WAP_HOST_ADDR stringByAppendingPathComponent:componentStr]] title:@"圈子详情" rightImgName:nil];
    
    CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
    webVC.js_Manager = js_Manager;
    webVC.object = @(self.typeId);
    
    WeakObj(self)
    js_Manager.needRefreshBlock = ^(CircleJSManager *js_Manager){
        
        //计算当前Cell所在页码
        CircleMainContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSUInteger currentPageIndex = cell.indexPath.row/_pageSize+1;
        
        //请求并刷新UI
        [selfWeak refreshDataWithPage:currentPageIndex];
    };
    
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView != _bgScrollView) {
        [UIView animateWithDuration:0.25 animations:^{
            self.sendMessgaeBtn.alpha = 0.0;
        }];
    }

     [_chat_Bar.txtView resignFirstResponder];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (scrollView != _bgScrollView) {
        if (!decelerate) {
            [UIView animateWithDuration:1.0 animations:^{
                self.sendMessgaeBtn.alpha = 1.0;
            }];
        }
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _bgScrollView) {
        
        CGFloat page = scrollView.contentOffset.x/kScreenWidth;
        
        if (page == 0) {
            
            [_platFormTableView.mj_header beginRefreshing];
            
            self.commityType = @"0";
        }
        if (page == 1) {
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [_studentTableView.mj_header beginRefreshing];
                
                self.commityType = @"2";
            });
            
        }
        
    }



}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bgScrollView) {
        
        int page = scrollView.contentOffset.x/kScreenWidth+0.5;
        
        if (page == 0) {
            if (self.segmentControl.selectedSegmentIndex != 0) {
                self.segmentControl.selectedSegmentIndex = 0;

            }
        }
        if (page == 1) {
            if (self.segmentControl.selectedSegmentIndex != 1) {
                self.segmentControl.selectedSegmentIndex = 1;
            }
        }
        
    }
    else
    {
        [UIView animateWithDuration:1.0 animations:^{
            self.sendMessgaeBtn.alpha = 1.0;
        }];

    }
    
}

//头部导航栏
-(NSArray *)createNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector
{
    //创建左边的按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0,10, 20, 20);
    if (leftName) {
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftName] forState:UIControlStateNormal];
    }
    if (leftHightlightName) {
        
        [leftBtn setBackgroundImage:[UIImage imageNamed:leftHightlightName] forState:UIControlStateHighlighted];
    }
    [leftBtn addTarget:self action:leftSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //设置title
    self.navigationItem.title = title;
    //右边的按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    //rightBtn.frame = CGRectMake(0, 10, 23, 20);
    rightBtn.frame = CGRectMake(0, 10, 20, 20);
    if (rightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightName] forState:UIControlStateNormal];
    }
    if (rightHighlightName) {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightHighlightName] forState:UIControlStateHighlighted];
    }
    [rightBtn addTarget:self action:rightSelector forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font =[UIFont systemFontOfSize:17];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    NSArray *arr = @[leftBtn,rightBtn];
    
    return arr;
    
}



@end