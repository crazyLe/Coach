//
//  AddressBookVC.m
//  Coach
//
//  Created by gaobin on 16/8/1.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLPopoverView.h"
#import "AddressBookVC.h"
#import "ZYPinYinSearch.h"
#import "ChineseString.h"
#import "AddressBookCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <UIKit/UIKit.h>
#import "PersonModel.h"

#define spacingSize (kScreenWidth-10-60-10-40-60-25-25-10-45-15)/3

@interface AddressBookVC ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>
{
//    BOOL        _selectRows[27][100];
    CGFloat oldContentOffsetY;
}
@property (nonatomic, strong) NSMutableArray * optionsDataArray;
@property (nonatomic, strong) UITableView * optionsTableview;
@property (nonatomic, strong) UITableView * tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSArray *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (nonatomic, strong) NSArray * indexBarArray;//26个字母加一个#号

@property (nonatomic, strong) NSMutableArray * mutableArray;
@property (nonatomic, strong) NSArray * allPeopleArray; //手机通讯录的所有联系人
@property (nonatomic, strong) NSMutableArray * allPeopleMutableArr;

@property (nonatomic ,strong) NSMutableArray *selectPersonArr;

//记录点击的按钮
@property (nonatomic, assign) int lastSelectRow;


@end

@implementation AddressBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lastSelectRow = -1;
    _mutableArray = [NSMutableArray array];
    _allPeopleMutableArr = [NSMutableArray array];
    _indexBarArray = [NSArray arrayWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"G",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    _selectPersonArr = [[NSMutableArray alloc] init];
    
    
    [self initData];
    
    [self createNavigation];
    
    [self createUI];
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    
}

- (void)initData {
    
    //获取通讯录联系人
//    ABAddressBookRef addBook =nil;
//    NSArray * dataSource = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(addBook));
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (error) {
                [LLUtils showErrorHudWithStatus:@"获取通讯录权限失败"];
            }
            else if (!granted)
            {
                [LLUtils showErrorHudWithStatus:@"请先前往设置中打开通讯录权限"];
            }
            else
            {
                //成功获取通讯录权限
                [self prepareDataSourceWithAddressbook:addressBook];
            }
        });
    }
    else
    {
        //有权限
        [self prepareDataSourceWithAddressbook:addressBook];
    }
}

- (void)prepareDataSourceWithAddressbook:(ABAddressBookRef)addressBook
{
    _allPeopleArray =(__bridge NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (int i = 0; i < _allPeopleArray.count; i ++){
        
        ABRecordRef person  = (__bridge ABRecordRef)(_allPeopleArray[i]);
        
        NSString * name = (__bridge NSString *)ABRecordCopyCompositeName(person);
        
        if (isNull(name)) {
            continue;
        }
        
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSString * phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, 0));
        
        PersonModel * p = [[PersonModel alloc] init];
        
        p.name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (!isNull(p.name)) {
            p.name = [ChineseString RemoveSpecialCharacter:p.name];
        }
        
        
        NSMutableCharacterSet *charSet = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
        [charSet addCharactersInString:@"("];
        [charSet addCharactersInString:@")"];
        [charSet addCharactersInString:@"-"];
        NSString *filterPhone =  [[phone componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
        
        //过滤+86
        NSString *filter86Phone = [LLUtils filterPhoneNum86:filterPhone];
        
        p.phone = filter86Phone;
        
        [_mutableArray addObject:p.name];
        
        [_allPeopleMutableArr addObject:p];
        
    }
    _dataSource = [_mutableArray mutableCopy];
    
    //_dataSource = @[@"九寨沟",@"鼓浪屿",@"香格里拉",@"千岛湖",@"西双版纳",@"嫦娥1号",@"1314Love",@"故宫",@"上海科技馆",@"东方明珠",@"外滩",@"HK香港",@"CapeTown",@"The Grand Canyon",@"4567.com",@"-你me"];
    
    _searchDataSource = [NSMutableArray new];
    //获取索引的首字母
    _indexDataSource = [ChineseString IndexArray:_dataSource];
    
    //对原数据进行排序重新分组
    _allDataSource = [ChineseString LetterSortArray:_dataSource];
}


- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"输入学员名或首字母";
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!self.searchController.active) {
        return _indexDataSource.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!self.searchController.active) {
        return [_allDataSource[section] count];
    }else {
        return _searchDataSource.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
    
}
//设置区头区脚高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        //搜索状态
        return 60;
    }
    else
    {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = kTableBgColor;
    
    UILabel * letterLab = [[UILabel alloc] init];
    if (!self.searchController.active) {
        
         letterLab.text = _indexDataSource[section];
        
    }
    letterLab.font = [UIFont boldSystemFontOfSize:16];
    [bgView addSubview:letterLab];
    [letterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(15);
    }];
   
    
    return bgView;
    
    
}

//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (!self.searchController.active) {
        
//        return _indexBarArray;
        if ((_indexDataSource.count>0) && ([_indexDataSource[0] isEqualToString:@"#"])) {
            return _indexDataSource;
        }
        else
        {
            NSMutableArray *arr = [@[@"#"] mutableCopy];
            [arr addObjectsFromArray:_indexDataSource];
            return arr;
        }
        
    }else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [UIView new];
    
    if (self.searchController.active) {
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footView addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(10, 20, 10, 20));
        }];
        confirmBtn.layer.cornerRadius = (60-10-10)/2.0f;
        confirmBtn.layer.masksToBounds = YES;
        confirmBtn.backgroundColor = kAppThemeColor;
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return footView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"AddressBookCell";
    AddressBookCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        cell.bottomLineView.backgroundColor = kLineGrayColor;
        [cell.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
        }];
    }
    else
    {
        cell.bottomLineView.backgroundColor = kLineWhiteColor;
        [cell.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
        }];
    }
    
    //设置name
    if (!self.searchController.active)
    {
        cell.namaLab.text = _allDataSource[indexPath.section][indexPath.row];
    }
    else
    {
        //搜索状态
        cell.namaLab.text = _searchDataSource[indexPath.row];
    }
    NSLog(@"nameLblText==>%@",cell.namaLab.text);
    //设置phone
    for (PersonModel * person in _allPeopleMutableArr) {
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",person.name);
        
        if ([person.name isEqualToString:cell.namaLab.text]) {
            
            NSLog(@"<<<<<<<<<<<<<%@",person.phone);
            cell.phoneLab.text = person.phone;
            cell.personModel = person;
            break;
        }
    }
    
    if ([_selectPersonArr containsObject:cell.personModel]) {
        [cell.isSelectBtn setImage:[UIImage imageNamed:@"iconfont-addressbookyuanseleted"] forState:UIControlStateNormal];
    }
    else
    {
       [cell.isSelectBtn setImage:[UIImage imageNamed:@"iconfont-addressbookyuan"] forState:UIControlStateNormal];
    }
    
    
//    if (!self.searchController.active) {
//        
//        if (_selectRows[indexPath.section][indexPath.row] == YES)
//        {
//            [cell.isSelectBtn setImage:[UIImage imageNamed:@"通讯录选中-(1)"] forState:UIControlStateNormal];
//        }else
//        {
//            
//            [cell.isSelectBtn setImage:[UIImage imageNamed:@"通讯录椭圆-21"] forState:UIControlStateNormal];
//        }
//        
//    }else {
//        
//        [cell.isSelectBtn setImage:[UIImage imageNamed:@"通讯录椭圆-21"] forState:UIControlStateNormal];
//        
//        if (_selectRows[indexPath.section][indexPath.row] == YES)
//        {
//            [cell.isSelectBtn setImage:[UIImage imageNamed:@"通讯录选中-(1)"] forState:UIControlStateNormal];
//        }else
//        {
//            
//            [cell.isSelectBtn setImage:[UIImage imageNamed:@"通讯录椭圆-21"] forState:UIControlStateNormal];
//        }
//        
//    }

    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    if (index < [tableView numberOfSections]) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    return index;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (!self.searchController.active) {
//        //        NSString *str = _allDataSource[indexPath.section][indexPath.row];
//        self.block(_allDataSource[indexPath.section][indexPath.row]);
//    }else{
//        self.block(_searchDataSource[indexPath.row]);
//    }
//    self.searchController.active = NO;
//    [self.navigationController popViewControllerAnimated:YES];
    
    
//    if (!self.searchController.active) {
//        
//        // 先根据区号取出小数组,再根据行号取出元素,进行取反
//        _selectRows[indexPath.section][indexPath.row] = !_selectRows[indexPath.section][indexPath.row];
//        
//        // 刷新表
//        [tableView reloadData];
//    }else {
//        
//        _selectRows[indexPath.section][indexPath.row] = !_selectRows[indexPath.section][indexPath.row];
//        [tableView reloadData];
//    }
    AddressBookCell *addressBookCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([_selectPersonArr containsObject:addressBookCell.personModel]) {
        [_selectPersonArr removeObject:addressBookCell.personModel];
    }
    else
    {
        [_selectPersonArr addObject:addressBookCell.personModel];
    }
    [tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UISearchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
    
    [_searchDataSource removeAllObjects];
    NSArray *ary = [NSArray new];
    ary = [ZYPinYinSearch searchWithOriginalArray:_dataSource andSearchText:searchController.searchBar.text andSearchByPropertyName:@"name"];
    if (searchController.searchBar.text.length == 0) {
        [_searchDataSource addObjectsFromArray:_dataSource];
    }else {
        [_searchDataSource addObjectsFromArray:ary];
    }
    [self.tableView reloadData];
    
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    self.tableView.sectionIndexColor = kAppThemeColor;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"AddressBookCell" bundle:nil] forCellReuseIdentifier:@"AddressBookCell"];
    
    
    //添加下拉table
//    [self.view addSubview:self.optionsTab];

    
    
}
//- (UITableView *)optionsTab
//{
//    if (!_optionsTableview) {
//        _optionsTableview = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth - 110 - 86 ,64+12.5+101,86,0) style:UITableViewStylePlain];
//        _optionsTableview.delegate = self;
//        _optionsTableview.dataSource = self;
//    }
//    return _optionsTableview;
//}

#pragma mark - AddressBookCellDelegate 

- (void)AddressBookCell:(AddressBookCell *)cell clickSubjectBgView:(UIView *)subjectBgView;
{
    _optionsDataArray = [[NSMutableArray alloc]initWithObjects:@"科目一",@"科目二",@"科目三",@"科目四", nil];
    
    CGFloat popViewWidth = 85.0f;
    CGSize  btnImgSize = subjectBgView.frame.size;
    CGRect originRect = CGRectMake(subjectBgView.center.x-popViewWidth/2
                                   , subjectBgView.center.y+btnImgSize.height/2+2.0f, popViewWidth, 150);
    CGRect targetRect = [cell.contentView convertRect:originRect toView:self.view];
    
    LLPopoverView *popoverView = [LLPopoverView showAtRect:targetRect inView:self.view withItemArr:_optionsDataArray delegate:self object:cell];
    popoverView.bgImg = [UIImage imageNamed:@"PopoverView_ArrowCenter"];
}

#pragma mark -

- (void)LLPopoverView:(LLPopoverView *)view didSelectItemAtIndex:(NSInteger)index;
{
    AddressBookCell *cell = view.object;
    [cell.subjectLab setText:view.ItemTitleArr[index]];
    cell.personModel.subject = view.ItemTitleArr[index];
}

- (void)popoverViewWillDismiss:(LLPopoverView *)view;
{
    
}

- (void)popoverViewDidDismiss:(LLPopoverView *)view;
{
    
}

- (void)createNavigation {
    
    [self setTitleText:@"通讯录" textColor:nil];
    [self setLeftText:nil textColor:nil ImgPath:@"Navigation_Return"];
    [self setRightText:@"确定" textColor:nil ImgPath:nil];
    
}
- (void)clickRightBtn:(UIButton *)rightBtn
{
    //确定
    [self addNewStudentRequest]; //添加新学员
}

- (void)clickConfirmBtn:(UIButton *)confirmBtn
{
    [self clickRightBtn:nil];
}


#pragma mark - Network


- (void)addNewStudentRequest
{
    if (isEmptyArr(_selectPersonArr)) {
        [LLUtils showOnlyTextHub:@"请先选择要添加的学员"];
        return;
    }
    
    NSMutableArray *jsonArr = [NSMutableArray array];
    for (PersonModel *model in _selectPersonArr) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:isEmptyStr(model.phone)?@"":model.phone];
        [arr addObject:isEmptyStr(model.name)?@"":model.name];
        NSInteger subjectInt = 0;
        if ([model.subject rangeOfString:@"科目一"].location != NSNotFound) {
            subjectInt = 1;
        }
        else if ([model.subject rangeOfString:@"科目二"].location != NSNotFound)
        {
            subjectInt = 2;
        }
        else if ([model.subject rangeOfString:@"科目三"].location != NSNotFound)
        {
            subjectInt = 3;
        }
        else if ([model.subject rangeOfString:@"科目四"].location != NSNotFound)
        {
            subjectInt = 4;
        }
        else
        {
            subjectInt = 1; //默认
        }
        [arr addObject:[NSString stringWithFormat:@"%ld",subjectInt]];
        [jsonArr addObject:arr];
    }
    
    NSString *jsonStr = [LLUtils jsonStrWithJSONObject:jsonArr];
    [NetworkEngine sendAsynPostRequestRelativeAdd:@"/myStudent/create" paraNameArr:@[@"uid",@"time",@"student",@"sign"] paraValueArr:@[kUid,kTimeStamp,jsonStr,kSignWithIdentify(@"/myStudent/create")] completeBlock:^(BOOL isSuccess, id jsonObj) {
        if (isSuccess) {
            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
                //请求成功
                [LLUtils showSuccessHudWithStatus:jsonObj[@"msg"]];
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
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        [self showLoginRegisterWithLoginSuccessBlock:nil];
    }
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
