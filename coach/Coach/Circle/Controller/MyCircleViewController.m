//
//  CircleViewController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MessageDataBase.h"
#import "MsgModel.h"
#import <IQKeyboardManager.h>
#import "ChatBarContainer.h"
#import "CircleJSManager.h"
#import "LLWebViewController.h"
#import "MyCircleViewController.h"
#import "CircleMainContentCell.h"
#import "CircleMainModel.h"
#import "CircleMainFrameModel.h"
#import "CircleMessageCell.h"
#import "CircleZanMessageCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <MWPhotoBrowser.h>
#import "CircleMessageModel.h"

#import "HJHttpManager.h"
#import "HttpParamManager.h"
#import "HJInterfaceManager.h"

@interface MyCircleViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CircleMainContentCellDelegate,MWPhotoBrowserDelegate>

@property(nonatomic,strong)UISegmentedControl * segmentControl;

@property(nonatomic,strong)UITableView * messageNewTableView;

@property(nonatomic,strong)UITableView * publishedTableView;

@property(nonatomic,strong)UIScrollView * bgScrollView;

@property(nonatomic,strong)NSMutableArray * publishDataFrameArray;

@property(nonatomic,strong)NSMutableArray * messageDataArray;

@property(nonatomic,assign)int publishedPageId;

@property(nonatomic,strong)NSMutableArray *photos;

@property(nonatomic,assign)int messagePage;

@property(nonatomic,assign)NSUInteger messagePageSize;   //记录一页返回多少条数据

@property(nonatomic,assign)NSUInteger publishPageSize;   //记录一页返回多少条数据

@property(nonatomic,strong)ChatBarContainer *chat_Bar;

@end

@implementation MyCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.publishedPageId = 1;
    
    self.messagePage = 1;
    
    self.view.backgroundColor = BG_COLOR;
    
    self.publishDataFrameArray = [NSMutableArray array];
    
    self.messageDataArray = [NSMutableArray array];

//    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:nil];

    [self createSegment];
    
    [self createUI];
    
    [self loadMessageData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}

-(void)loadMessageData
{
    NSString *url = self.interfaceManager.memberCommunity;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"pageId"] = @(self.messagePage);
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/member/community" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    NSLog(@"=====>%@",[NSString stringWithFormat:@"%@%@%@%@%@",kUUID,@"/member/community",kUid,kToken,kTimeStamp]);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            
            NSArray *dataArray = [CircleMessageModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];
            
            self.messageDataArray = dataArray.mutableCopy;
            
            _messagePageSize = dataArray.count;
            
            [self.hudManager dismissSVHud];
            
            [_messageNewTableView reloadData];
            [_messageNewTableView.mj_header endRefreshing];
            
            //设置所有信息已读
//            for (int i = 0; i<self.dataArray.count ; i++) {
//                MsgModel *model = self.dataArray[i];
//                [[MessageDataBase shareInstance]setDataIsReadWithModel:model];
//            }
            NSArray *msgArr = [MsgModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];
            
            for (int i = 0; i<msgArr.count; i++) {
                MsgModel *model = msgArr[i];
                [[MessageDataBase shareInstance] setDataIsReadWithModel:model];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kMakeMsgIsReadNotification object:nil];
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_messageNewTableView.mj_header endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_messageNewTableView.mj_header endRefreshing];
    }];
 



}
-(void)loadMoreMessageData
{
    NSString *url = self.interfaceManager.memberCommunity;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"pageId"] = @(self.messagePage);
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/member/community" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            
            NSArray *dataArray = [CircleMessageModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];
            [self.messageDataArray addObjectsFromArray:dataArray];
            [self.hudManager dismissSVHud];
            [_messageNewTableView reloadData];
            [_messageNewTableView.mj_footer endRefreshing];
            
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_messageNewTableView.mj_footer endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_messageNewTableView.mj_footer endRefreshing];
    }];
    


}
-(void)loadMoreData
{
    NSString *url = self.interfaceManager.memberCommunityList;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"pageId"] = @(self.publishedPageId);
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/member/communitylist" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            
            NSArray *dataArray = [CircleMainModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];
            
            for (int i = 0; i<dataArray.count; i++) {
                
                CircleMainFrameModel *frameModel =[[CircleMainFrameModel alloc]init];
                
                frameModel.circleMainModel = dataArray[i];
                
                [self.publishDataFrameArray addObject:frameModel];
                
            }
            [self.hudManager dismissSVHud];

            [_publishedTableView reloadData];
            [_publishedTableView.mj_footer endRefreshing];
            
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_publishedTableView.mj_footer endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_publishedTableView.mj_footer endRefreshing];
    }];
    
}
-(void)loadData
{
    NSString *url = self.interfaceManager.memberCommunityList;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"pageId"] = @(self.publishedPageId);
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/member/communitylist" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            
            NSArray *dataArray = [CircleMainModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];

            self.publishDataFrameArray = [NSMutableArray array];
            
            _publishPageSize = dataArray.count;
                
            for (int i = 0; i<dataArray.count; i++) {
                
                CircleMainFrameModel *frameModel =[[CircleMainFrameModel alloc]init];
                
                frameModel.circleMainModel = dataArray[i];
                
                [self.publishDataFrameArray addObject:frameModel];
                
            }
            [_publishedTableView reloadData];
            [self.hudManager dismissSVHud];
            [_publishedTableView.mj_header endRefreshing];
            
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_publishedTableView.mj_header endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_publishedTableView.mj_header endRefreshing];
    }];
    
}

//刷新指定页数据源
-(void)refreshDataWithPage:(NSUInteger)page
{
    NSString *url = self.segmentControl.selectedSegmentIndex==0?self.interfaceManager.memberCommunity:self.interfaceManager.memberCommunityList;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"pageId"] = @(page);
    param[@"sign"] = [HttpParamManager getSignWithIdentify:self.segmentControl.selectedSegmentIndex==0?@"/member/community":@"/member/communitylist" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            
            NSArray *dataArray = [CircleMainModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];
            
            NSUInteger currentPageStartIndex = (page-1)*(_segmentControl.selectedSegmentIndex==0?_messagePageSize:_publishPageSize);
            
            if (self.segmentControl.selectedSegmentIndex == 0) {//新消息
                
                NSArray *msgDataArray = [CircleMessageModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"Community"]];
                
                if (self.messageDataArray.count>=currentPageStartIndex+msgDataArray.count) {
                    [self.messageDataArray replaceObjectsInRange:NSMakeRange(currentPageStartIndex, msgDataArray.count) withObjectsFromArray:msgDataArray];
                }
                else if(page==1)
                {
                    self.messageDataArray = [msgDataArray mutableCopy];
                }
                
                [_messageNewTableView reloadData];
            }
            else//已发布
            {
                
                for (int i = 0; i<dataArray.count; i++) {
                    CircleMainFrameModel *frameModel =[[CircleMainFrameModel alloc]init];
                    frameModel.circleMainModel = dataArray[i];
                    //                    [self.studentDataFrameArray addObject:frameModel];
                    if (self.publishDataFrameArray.count>currentPageStartIndex+i) {
                        [self.publishDataFrameArray replaceObjectAtIndex:currentPageStartIndex+i withObject:frameModel];
                    }
                }
                
                [_publishedTableView reloadData];
            }
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_messageNewTableView.mj_footer endRefreshing];
            [_publishedTableView.mj_footer endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_messageNewTableView.mj_footer endRefreshing];
        [_publishedTableView.mj_footer endRefreshing];
    }];
    
}

-(void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSegment
{
    NSArray * segmentArray = @[@"新消息",@"已发布"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:kFont13} forState:UIControlStateNormal];
    //设置segment的选中背景颜色
    _segmentControl.tintColor = [UIColor whiteColor];
    _segmentControl.frame = CGRectMake(100, 0, kScreenWidth -200, 30);
    [_segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentControl;
}
-(void)segmentValueChanged:(UISegmentedControl *)segmentControl
{
    if (segmentControl.selectedSegmentIndex == 0) {
        [self.bgScrollView setContentOffset:CGPointZero animated:YES];

    }else
    {
        [self.bgScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    }


}
- (void)createUI
{
    
    //创建scrollView作为两张表的载体
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - kNavHeight)];
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavHeight-kTabBarHeight);
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.alwaysBounceVertical = NO;
    _bgScrollView.delegate = self;
    _bgScrollView.bounces = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    //新消息
    _messageNewTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    _messageNewTableView.delegate = self;
    _messageNewTableView.dataSource = self;
    _messageNewTableView.backgroundColor = [UIColor clearColor];
    [_messageNewTableView setExtraCellLineHidden];
    [_messageNewTableView setCellLineFullInScreen];
    _messageNewTableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    [_bgScrollView addSubview:_messageNewTableView];
    [_messageNewTableView registerNib:[UINib nibWithNibName:@"CircleMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CircleMessageCell"];
    [_messageNewTableView registerNib:[UINib nibWithNibName:@"CircleZanMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CircleZanMessageCell"];
    
    __weak typeof(self) weakSelf = self;
    _messageNewTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.messagePage = 1;
        
        [weakSelf loadMessageData];
        
    }];
    
    
    _messageNewTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.messagePage ++;
        
        [weakSelf loadMoreMessageData];
        
    }];
    
    [_messageNewTableView.mj_header beginRefreshing];
    _messageNewTableView.mj_footer.automaticallyHidden = YES;
    
    
    //已发布
    _publishedTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    _publishedTableView.delegate = self;
    _publishedTableView.dataSource = self;
    [_publishedTableView setExtraCellLineHidden];
    _publishedTableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    [_publishedTableView setCellLineFullInScreen];
    _publishedTableView.backgroundColor = [UIColor clearColor];
    [_bgScrollView addSubview:_publishedTableView];
    [_publishedTableView registerClass:[CircleMainContentCell class] forCellReuseIdentifier:@"CircleMainContentCell"];
    
    _publishedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.publishedPageId = 1;
        
        [weakSelf loadData];
        
    }];
    
    
    _publishedTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.publishedPageId ++;
        
        [weakSelf loadMoreData];
        
    }];
    _publishedTableView.mj_footer.automaticallyHidden = YES;

    
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

-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickZanBtnWithModel:(CircleMainFrameModel *)frameModel
{
    //点击点赞
    NSString *circleId = intToStr(frameModel.circleMainModel.idNum);
    
    NSString *relativeAdd = @"/community/praise";
    
    //计算当前Cell所在页码
    NSUInteger currentPageIndex = cell.indexPath.row/_publishPageSize+1;
    
    [self likeRequestWithRelativeAdd:relativeAdd Id:circleId currentPageIndex:currentPageIndex];
}
-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickCommentZanBtnWithModel:(CircleMainFrameModel *)frameModel
{
    //点击评论的点赞按钮
    NSString *circleId = intToStr(frameModel.circleMainModel.comemnt.idNum);
    
    NSString *relativeAdd = @"/community/commentpraise";
    
    //计算当前Cell所在页码
    NSUInteger currentPageIndex = cell.indexPath.row/_publishPageSize+1;
    
    [self likeRequestWithRelativeAdd:relativeAdd Id:circleId currentPageIndex:currentPageIndex];
}

-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickCommentBtnWithModel:(CircleMainFrameModel *)frameModel
{
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

#pragma mark - ChatBarContainerDelegate

//点击评论发送按钮
- (void)ChatBarContainer:(ChatBarContainer *)chatBar clickSendWithContent:(NSString*)content;
{
    CircleMainFrameModel *model = chatBar.object;
    
    int idInt = model.circleMainModel.idNum;
    
    NSString *relativeAdd = @"/community/commentcreate";
    NSDictionary *paraDic = @{@"uid":kUid,@"time":kTimeStamp,@"sign":kSignWithIdentify(relativeAdd),@"deviceInfo":kDeviceInfo,@"cityId":kCityID,@"address":kAddress,@"communityType":intToStr(2),@"id":intToStr(idInt),@"content":chatBar.txtView.text};
    [NetworkEngine postRequestWithRelativeAdd:relativeAdd paraDic:paraDic completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if (isEqualValue(jsonObj[@"code"], 1)) {
                //成功
                NSLog(@"comment msg == > %@",jsonObj[@"msg"]);
                
                //计算当前Cell所在页码
                CircleMainContentCell *cell = chatBar.userInfo[@"CircleMainContentCell"];
                NSUInteger currentPageIndex = cell.indexPath.row/_publishPageSize+1;
                
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

#pragma mark -- tableView的代理和数据源
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _messageNewTableView)
    {
        return self.messageDataArray.count;
    }
    else
    {
        return self.publishDataFrameArray.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _messageNewTableView)
    {
        CircleMessageModel *model = self.messageDataArray[indexPath.row];
        if (model.type == 1)
        {
            //评论
            return [tableView fd_heightForCellWithIdentifier:@"CircleMessageCell" cacheByIndexPath:indexPath configuration:^(CircleMessageCell * cell) {

            }];
        }
        else
        {
            //赞
            return [tableView fd_heightForCellWithIdentifier:@"CircleZanMessageCell" cacheByIndexPath:indexPath configuration:^(CircleZanMessageCell * cell) {
            }];
        }
//        if (indexPath.row == 1) {
//            return [tableView fd_heightForCellWithIdentifier:@"CircleZanMessageCell" cacheByIndexPath:indexPath configuration:^(CircleZanMessageCell * cell) {
//            }];
//        }
//        
//        return [tableView fd_heightForCellWithIdentifier:@"CircleMessageCell" cacheByIndexPath:indexPath configuration:^(CircleMessageCell * cell) {
//            if (indexPath.row == 1) {
//                cell.subTitleLabel.text = @"";
//            }
//        }];
        
    }
    else
    {
        
        CircleMainFrameModel *frameModel = self.publishDataFrameArray[indexPath.row];
        
        return frameModel.cellHeight;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _publishedTableView) {
        
        static NSString * identifer = @"CircleMainContentCell";
        CircleMainContentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
        cell.delegate = self;
        cell.circleFrameModel = self.publishDataFrameArray[indexPath.row];
        
        return cell;
        
    }
    else
    {
        
        CircleMessageModel *model = self.messageDataArray[indexPath.row];
        
//        if ([model.desc containsString:@"评论了"]) {
        if (model.type == 1) {
            //评论
            static NSString * identifer = @"CircleMessageCell";
            CircleMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
            cell.messageModel = model;
            return cell;
        }
//        }
        
//        if ([model.desc containsString:@"赞了"]) {
        if (model.type==2) {
            //赞
            static NSString * identifer = @"CircleZanMessageCell";
            CircleZanMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
            cell.messageModel = model;
            return cell;
        }
//        }
        return [[UITableViewCell alloc] init];
    
    }

}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int idNum = 0;
    
    if (tableView == _publishedTableView) {
    
        CircleMainFrameModel *model = self.publishDataFrameArray[indexPath.row];
        idNum = model.circleMainModel.idNum;
    }
    else
    {
        CircleMessageModel *model = self.messageDataArray[indexPath.row];
        idNum = model.communityId;
    }
    
    NSString *momentId = intToStr(idNum);
    NSString *componentStr = [NSString stringWithFormat:@"/community/show/%@?uid=%@&app=1&cityid=%@&address=%@",momentId,kUid,kCityID,kAddress];
    
    LLWebViewController *webVC = [[LLWebViewController alloc] initWithUrl:[NSURL URLWithString:[WAP_HOST_ADDR stringByAppendingPathComponent:componentStr]] title:@"圈子详情" rightImgName:nil];
    
    CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
    webVC.js_Manager = js_Manager;
    webVC.object = @(_segmentControl.selectedSegmentIndex);
    
    WeakObj(self)
    js_Manager.needRefreshBlock = ^(CircleJSManager *js_Manager){
        
        //计算当前Cell所在页码
        NSUInteger currentPageIndex = indexPath.row/(_segmentControl.selectedSegmentIndex==0?_messagePageSize:_publishPageSize)+1;
        
        if (self.segmentControl.selectedSegmentIndex==0) {
            currentPageIndex = 1; //新消息默认更新第一页数据
        }
        
        //请求并刷新UI
        [selfWeak refreshDataWithPage:currentPageIndex];
    };
    
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_chat_Bar.txtView resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _bgScrollView) {
        
        CGFloat page = scrollView.contentOffset.x/kScreenWidth;
        
        if (page == 0) {
            
            [_messageNewTableView.mj_header beginRefreshing];
            
        }
        if (page == 1) {
            
            [_publishedTableView.mj_header beginRefreshing];
            
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

}


@end
