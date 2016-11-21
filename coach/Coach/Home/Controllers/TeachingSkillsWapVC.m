//
//  TeachingSkillsWapVC.m
//  Coach
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "TeachingSkillsWapVC.h"

@interface TeachingSkillsWapVC ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView * webView;

@end

@implementation TeachingSkillsWapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initWithUI
{
    [super initWithUI];
    self.title = @"详情";
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];

    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_pathStr]];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
    
}


- (void)initWithData
{
    [super initWithData];
    
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
