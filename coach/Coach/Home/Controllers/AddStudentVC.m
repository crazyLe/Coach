//
//  AddStudentVC.m
//  Coach
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "UMSocialSnsPlatformManager.h"
#import "UMSocialSnsService.h"
#import "MyStudentVC.h"
#import "OneCenterBtnCell.h"
#import "EditInfoVC.h"
#import "AddStudentVC.h"

#import "AddressBookVC.h"

#import "ShareView.h"
@interface AddStudentVC ()  <UITableViewDelegate,UITableViewDataSource,OneCenterBtnCellDelegate,ShareViewDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)ShareView  * shareView;
@property(nonatomic,strong)UIView * cover;


@end

@implementation AddStudentVC
{
    NSArray     * imgNameArr;
    NSArray     * titleArr;
    NSArray     * desArr;
}

- (id)init
{
    if (self = [super init]) {
        imgNameArr = @[@"AddStudent_Contact",@"AddStudent_Add",@"AddStudent_Invite"];
        titleArr   = @[@"手机通讯录导入",@"手动添加学员",@"邀请学员使用康庄学车"];
        desArr     = @[@"添加或邀请通讯录中朋友",@"添加或邀请通讯录中朋友",@"添加或邀请通讯录中朋友"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setNav];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

//- (void)setNav
//{
//    self.title = @"添加学员";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Navigation_Return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(clickBarBtnItem:)];
//    leftBarBtnItem.tag = 10;
//    self.navigationItem.leftBarButtonItem  = leftBarBtnItem;
//    
//    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Navigation_Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBarBtnItem:)];
//    rightBarBtnItem.tag = 20;
//    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
//    
//    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:@"0X2993e8"]];
//}

- (void)setNav
{
    [self setTitleText:@"添加学员" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
//    [self setRightText:nil textColor:nil ImgPath:@"Navigation_Add"];
}

- (void)setUI
{
    [self setBg_TableViewWithConstraints:nil];
    [self registerClassWithClassNameArr:@[@"OneCenterBtnCell"] cellIdentifier:nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:nil options:nil]lastObject];
    self.shareView.delegate = self;
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _cover.backgroundColor = [UIColor darkGrayColor];
    _cover.userInteractionEnabled = YES;
    _cover.alpha = 0.0f;
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(translucentCoverViewSingleTap:)];
    [_cover addGestureRecognizer:singleTapGesture];
//    [self.view addSubview:_cover];
    [window addSubview:_cover];

}
-(void)translucentCoverViewSingleTap:(UITapGestureRecognizer *)tap
{
    [self.shareView dismissWithCompletionBlock:^(ShareView *view) {
        self.cover.alpha = 0.0;
    }];

}
-(void)shareViewDidClickCancelButton:(ShareView *)shareView
{
    [self.shareView dismissWithCompletionBlock:^(ShareView *view) {
        self.cover.alpha = 0.0;
    }];

}
-(void)shareView:(ShareView *)shareView didClickButtonWithType:(ShareViewBtnType)type
{
    shareView.transform = CGAffineTransformIdentity;
    [shareView removeFromSuperview];
    self.cover.alpha = .0f;
    
    NSString *shareType = nil;
    
    shareView.shareUrl = @"https://www.kangzhuangxueche.com/index.php/download?client=2";
    
    switch (type) {
        case ShareViewBtnWeChatQuan:
        {
            
            shareType = UMShareToWechatTimeline;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareView.shareUrl;
        }
            break;
        case ShareViewBtnWeChat:
        {
            //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
            
            
//            [UMSocialSnsService presentSnsIconSheetView:self
//                                                 appKey:kUMENG_APP_KEY
//                                              shareText:@"这是一个分享测试"
//                                             shareImage:[UIImage imageNamed:@"icon.png"]
//                                        shareToSnsNames:@[UMShareToWechatSession]
//                                               delegate:self];
             shareType = UMShareToWechatSession;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareView.shareUrl;
        }
            break;
        case ShareViewBtnWeBo:
        {
             shareType = UMShareToQQ;
            [UMSocialData defaultData].extConfig.qqData.url = shareView.shareUrl;
        }
            break;
        case ShareViewBtnQQZone:
        {
            
             shareType = UMShareToQzone;
            [UMSocialData defaultData].extConfig.qzoneData.url = shareView.shareUrl;
        }
            break;
            
        default:
            break;
    }
    
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareType] content:@"下载康庄教练端有惊喜哦" image:[UIImage imageNamed:@"组-1"] location:nil urlResource:[[UMSocialUrlResource alloc]  initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:@"http://www.kangzhuangxueche.com/"]  presentedController:self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
    
    
     [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:@"https://www.kangzhuangxueche.com/index.php/download?client=2"];
     [UMSocialData defaultData].extConfig.title = @"康庄学车";
     [UMSocialData defaultData].shareText = @"下载康庄教练端有惊喜哦";
     [UMSocialData defaultData].shareImage = [UIImage imageNamed:@"iconfont-kzjlicon"];
     UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType];
     snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
//    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:@"www.sskz.com.cn"];
    
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareType] content:@"下载康庄教练端有惊喜哦" image:[UIImage imageNamed:@"组-1"] location:nil urlResource:resource presentedController:self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//            [LLUtils showSuccessHudWithStatus:@"分享成功!"];
//        }
//        else{
//            NSLog(@"分享失败! ");
////            [LLUtils showErrorHudWithStatus:@"分享失败!"];
//        }
//    }];

}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.height.equalTo(cell.contentView.mas_height).multipliedBy(0.6);
        }];
        
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.imageView.mas_right).offset(10);
            make.top.right.bottom.offset(0);
        }];
        
        cell.imageView.image = [UIImage imageNamed:imgNameArr[indexPath.row]];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:titleArr[indexPath.row] attributes:@{NSForegroundColorAttributeName:kGrayHex33,NSFontAttributeName:Font16}];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:5]}]];
        [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:desArr[indexPath.row] attributes:@{NSForegroundColorAttributeName:kGrayHex88,NSFontAttributeName:Font13}]];
        [cell.textLabel setAttributedText:attStr];
        cell.textLabel.numberOfLines = 0;
        
        UIView *lineView = [UIView new];
        [cell.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.left.offset(15);
            make.right.offset(-15);
            make.height.offset(kLineWidth);
        }];
        lineView.backgroundColor = kLineWhiteColor;
    }
    else
    {
        OneCenterBtnCell *centerBtnCell = [tableView dequeueReusableCellWithIdentifier:@"OneCenterBtnCell"];
        centerBtnCell.backgroundColor = [UIColor clearColor];
        [centerBtnCell.centerBtn setTitle:@"进入我的学员" forState:UIControlStateNormal];
        centerBtnCell.delegate = self;
        centerBtnCell.centerBtn.layer.cornerRadius = 21.0f;
        return centerBtnCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                checkLogin()
                AddressBookVC * vc = [[AddressBookVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 1:
            {
                checkLogin()
                EditInfoVC *editInfoVC = [[EditInfoVC alloc] init];
                [self.navigationController pushViewController:editInfoVC animated:YES];
            }
                break;
            case 2:
            {
                self.cover.alpha = 0.8;
                
                [self.shareView show];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        
    }
}


- (void)clickBarBtnItem:(UIBarButtonItem *)barBtn
{
    if (barBtn.tag == 10) {
        //click navgation return
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(barBtn.tag == 20)
    {
        //click navgation add
        
    }
}

- (void)centerBtnCell:(OneCenterBtnCell *)cell clickCenterBtn:(UIButton *)centerBtn
{
    MyStudentVC *myStudentVC = [[MyStudentVC alloc] init];
    myStudentVC.isShowRightBtn = NO;
    [self.navigationController pushViewController:myStudentVC animated:YES];
}


@end
