//
//  LLGuideViewController.m
//  Coach
//
//  Created by LL on 16/8/26.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLGuideViewController.h"

@interface LLGuideViewController () <UIScrollViewDelegate>

@end

@implementation LLGuideViewController
{
    UIScrollView *bg_ScrollView;
    UIPageControl *pageControl;
    NSArray *imgNames;
    NSString *entryBtnTitle;
    ClickEntryBlock entryBtnBlock;
}

- (id)initWithImgNameArr:(NSArray *)imgNameArr entryBtnTitle:(NSString *)title entryBtnBlock:(ClickEntryBlock)block
{
    if (self = [super init]) {
        imgNames = imgNameArr;
        entryBtnTitle = title;
        entryBtnBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
}

#pragma mark - Setup

- (void)setUI
{
    [self setBg_ScrollView];
}

- (void)setBg_ScrollView
{
    bg_ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:bg_ScrollView];
    bg_ScrollView.pagingEnabled = YES;
    bg_ScrollView.delegate = self;
    bg_ScrollView.contentSize = CGSizeMake(bg_ScrollView.frame.size.width*imgNames.count, bg_ScrollView.frame.size.height);
    bg_ScrollView.showsHorizontalScrollIndicator = NO;
    bg_ScrollView.bounces = NO;
    int i = 0;
    for (NSString *nameStr in imgNames) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nameStr]];
        [bg_ScrollView addSubview:imgView];
        imgView.frame = CGRectMake(i*bg_ScrollView.frame.size.width,0, bg_ScrollView.frame.size.width, bg_ScrollView.frame.size.height);
        if (i==imgNames.count-1) {
            UIButton *entryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [imgView addSubview:entryBtn];
            entryBtn.bounds = CGRectMake(0, 0, 120*kWidthScale, 30*kWidthScale);
            entryBtn.center = CGPointMake(bg_ScrollView.center.x, bg_ScrollView.frame.size.height-70);
            entryBtn.layer.cornerRadius = 6;
            entryBtn.layer.masksToBounds = YES;
            entryBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            entryBtn.layer.borderWidth = 1.0f;
            [entryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [entryBtn setTitle:isEmptyStr(entryBtnTitle)?@"立即体验":entryBtnTitle forState:UIControlStateNormal];
            [entryBtn addTarget:self action:@selector(clickEntryBtn:) forControlEvents:UIControlEventTouchUpInside];
            imgView.userInteractionEnabled = YES;
        }
        i++;
    }
    
    pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:pageControl];
    pageControl.center = CGPointMake(bg_ScrollView.center.x, bg_ScrollView.frame.size.height-40);
    pageControl.bounds = CGRectMake(0, 0, kScreenWidth, 20);
    pageControl.currentPage = 0;
    pageControl.numberOfPages = imgNames.count;
    pageControl.hidesForSinglePage = YES;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = kAppThemeColor;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (pageControl.currentPage == imgNames.count-1) {
        pageControl.hidden = YES;
    }
    else
    {
        pageControl.hidden = NO;
    }
}

- (void)clickEntryBtn:(UIButton *)entryBtn
{
    if (entryBtnBlock) {
        entryBtnBlock(entryBtn);
    }
}

@end
