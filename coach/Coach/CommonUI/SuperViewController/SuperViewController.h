//
//  SuperViewController.h
//  idea
//
//  Created by caochungui on 16/1/5.
//  Copyright © 2016年 mobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CGConfiguration.h"
#import "NoDataView.h"
#import "NoNetworkView.h"
#import <MJRefresh.h>

typedef void(^requestBlock)(NSInteger page);

/// 父类ViewController
@interface SuperViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

- (void)initWithUI;

- (void)initWithData;

- (void)initWithInterface;

/// 判断是否是登录状态
- (BOOL)judgeLogin;

/// 判断是否有网络
- (BOOL)judgeNetWork;

- (void)reloadButtonClick;


/// 无数据页面
@property (nonatomic , strong) NoDataView *noDataView;
/// 无网络页面
@property (nonatomic , strong) NoNetworkView *noNetworkView;

@property(nonatomic,assign)BOOL isNavBarHide;

@property(nonatomic,strong)UIColor *themeColor;

@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;

@property(nonatomic,strong)NSString *titleText;

@property(nonatomic,strong)UITableView *bg_TableView;

@property(nonatomic,strong)NSMutableArray *contentArr;

@property  (nonatomic,strong) NSDictionary *infoDic;

- (void)setTitleText:(NSString *)titleText textColor:(UIColor *)color;

- (void)setLeftText:(NSString *)leftText textColor:(UIColor *)color
            ImgPath:(NSString *)imgPath;
- (void)setRightText:(NSString *)rightText textColor:(UIColor *)color
             ImgPath:(NSString *)imgPath;

- (void)setLeftBtnLeftInset:(CGFloat)offset;
- (void)setRightBtnLeftInset:(CGFloat)offset;

- (void)setLeftBtnTextImgInterval:(CGFloat)spacing;

//block : 约束表的block , block传入nil即可添加默认约束UIEdgeInsetsMake(0, 0, 0, 0)
- (void)setBg_TableViewWithConstraints:(void(^)(MASConstraintMaker *make))block;  //创建表
- (void)registerClassWithClassNameArr:(NSArray *)nameArr cellIdentifier:(NSArray *)identifierArr; //注册单元格

- (void)clickLeftBtn:(UIButton *)leftBtn;
- (void)clickRightBtn:(UIButton*)rightBtn;
-(void)clickSecondRightBtu:(UIButton* )secondRightBtu;

//设置网络请求 适用于含有 上拉加载 下拉刷新的界面
//relativeAdd  : 请求的相对地址
//paraDic      : 请求的参数字典   eg. @{para1:value1,para2:value2}
//pageFiledName: 页码参数名      eg.  @"page"
//dicKeyArr    : 解析的Key数组   eg. @[@"info",@"student"]   解析 ===>  jsonObj[@"info"][@"student"]
- (void)setNetworkRelativeAdd:(NSString *)relativeAdd paraDic:(NSDictionary *)paraDic pageFiledName:(NSString *)pageFiledName parseDicKeyArr:(NSArray *)dicKeyArr;


#pragma mark - 子类重写这几个方法，就会在相应时机自动触发调用子类这些方法
//已经重新加载了数据
- (void)contentArrDidRefresh:(NSArray *)newArr;
//已经追加了数据
- (void)contentArrDidLoadMoreData:(NSArray *)appendArr;
//没有更多数据了
- (void)noMoreData;

@end
