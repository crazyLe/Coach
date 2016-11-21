//
//  SuperTableViewController.m
//  idea
//
//  Created by caochungui on 16/1/5.
//  Copyright © 2016年 mobisoft. All rights reserved.
//

#import "SuperTableViewController.h"

@interface SuperTableViewController ()

@end

@implementation SuperTableViewController

-(instancetype)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithUI];
    [self initWithData];
    [self initWithInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithUI
{
    //处理tableview被navigation覆盖一部分
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)initWithData
{
    
}

- (void)initWithInterface
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 滚动时结束编辑状态
    [self.view endEditing:YES];
}

@end
