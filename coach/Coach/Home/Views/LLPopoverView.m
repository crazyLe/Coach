//
//  LLPopoverView.m
//  Coach
//
//  Created by LL on 16/7/26.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLPopoverView.h"

@interface LLPopoverViewBtn : UIButton

@property (nonatomic,strong) UIColor *selectedColor;

@property (nonatomic,strong) UIColor *highlightColor; //高亮

@property (nonatomic,strong) UIColor *normalColor;    //正常状态

@end

@implementation LLPopoverViewBtn

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (_highlightColor) {
        self.backgroundColor = highlighted ? _highlightColor : _normalColor;
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (_selectedColor) {
         self.backgroundColor = selected ? _selectedColor : _normalColor;
    }
}

@end

@implementation LLPopoverView
{
    UITableView *_tableView;
    CGRect       _frame;
}

+ (LLPopoverView *)showAtRect:(CGRect)rect inView:(UIView *)view withItemArr:(NSArray *)itemArr delegate:(id)delegate object:(id)obj
{
    LLPopoverView *popoverView =  [[self alloc] initWithFrame:rect withItemArr:itemArr];
    popoverView.delegate = delegate;
    popoverView.object = obj;
    [popoverView showAtRect:rect inView:view withItemArr:itemArr];
    return popoverView;
}

- (void)showAtRect:(CGRect)rect inView:(UIView *)view withItemArr:(NSArray *)itemArr
{
    [view addSubview:self];
    
    self.alpha = 0.f;
    _tableView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
        _tableView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tableView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (id)initWithFrame:(CGRect)frame withItemArr:(NSArray *)itemArr
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        [self commonInit];
        if (itemArr) {
            _ItemTitleArr = itemArr;
        }
        _frame = frame;
        [self setUI];
    }
    return self;
}

#pragma mark - Setup

- (void)setUI
{
    _tableView = [[UITableView alloc] initWithFrame:_frame style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self setBgImg:[UIImage imageNamed:@"PopoverView_BgImg"]];
}

- (void)commonInit
{
    _ItemTitleArr = @[@"Item1",@"Item2"];
    _normalBgColor    = [UIColor clearColor];
    _sectionHeaderHeight = 7.8f;
//    _highlightBgColor    = [UIColor colorWithHexString:@"32bfff"];
    _selectedBgColor     = [UIColor colorWithHexString:@"2ab8f1"];
    _normalTitleAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:kFont13};
    _highlightTitleAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff"],NSFontAttributeName:kFont13};
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
    [self addGestureRecognizer:tap];
}

#pragma mark SET SECTION

- (void)setItemTitleArr:(NSArray *)ItemTitleArr
{
    if (_ItemTitleArr != ItemTitleArr) {
        _ItemTitleArr = ItemTitleArr;
        [self refresh];
    }
}

- (void)setBgImg:(UIImage *)bgImg
{
    if (_bgImg != bgImg) {
        _bgImg = bgImg;
        _tableView.backgroundView = [[UIImageView alloc] initWithImage:_bgImg];
        [self refresh];
    }
}

- (void)setHighlightBgColor:(UIColor *)highlightBgColor
{
    if (_highlightBgColor != highlightBgColor) {
        _highlightBgColor = highlightBgColor;
        [self refresh];
    }
}

- (void)setHighlightTitleAttributes:(NSDictionary *)highlightTitleAttributes
{
    if (_highlightTitleAttributes != highlightTitleAttributes) {
        _highlightTitleAttributes = highlightTitleAttributes;
        [self refresh];
    }
}

- (void)setNormalBgColor:(UIColor *)normalBgColor
{
    if (_normalBgColor != normalBgColor) {
        _normalBgColor = normalBgColor;
        [self refresh];
    }
}

- (void)setNormalTitleAttributes:(NSDictionary *)normalTitleAttributes
{
    if (_normalTitleAttributes != normalTitleAttributes) {
        _normalTitleAttributes   = normalTitleAttributes;
        [self refresh];
    }
}

- (void)setSectionHeaderHeight:(CGFloat)sectionHeaderHeight
{
    if (_sectionHeaderHeight != sectionHeaderHeight) {
        _sectionHeaderHeight = sectionHeaderHeight;
        [self refresh];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _sectionHeaderHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ItemTitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (_frame.size.height-_sectionHeaderHeight)/_ItemTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    LLPopoverViewBtn *popoverViewBtn = [LLPopoverViewBtn buttonWithType:UIButtonTypeCustom];
    [cell.contentView addSubview:popoverViewBtn];
    [popoverViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    popoverViewBtn.highlightColor = _highlightBgColor;
    popoverViewBtn.normalColor = _normalBgColor;
    popoverViewBtn.selectedColor = _selectedBgColor;
    [popoverViewBtn setAttributedTitle:[NSMutableAttributedString attributeStringWithText:_ItemTitleArr[indexPath.row] attributes:@[_normalTitleAttributes]] forState:UIControlStateNormal];
    [popoverViewBtn setAttributedTitle:[NSMutableAttributedString attributeStringWithText:_ItemTitleArr[indexPath.row] attributes:@[_highlightTitleAttributes]] forState:UIControlStateSelected];
    [popoverViewBtn addTarget:self action:@selector(clickItemBtn:) forControlEvents:UIControlEventTouchUpInside];
    popoverViewBtn.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)refresh
{
    [_tableView reloadData];
}

- (void)tapSelf:(UITapGestureRecognizer *)tapGesture
{
    [self dismiss:YES];
}

- (void)clickItemBtn:(UIButton *)itemBtn
{
    itemBtn.selected = YES;
    [self dismiss:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(LLPopoverView:didSelectItemAtIndex:)]) {
        [_delegate LLPopoverView:self didSelectItemAtIndex:itemBtn.tag];
    }
}

- (void)dismiss:(BOOL)animated
{
    if (_delegate && [_delegate respondsToSelector:@selector(popoverViewWillDismiss:)]) {
        [_delegate popoverViewWillDismiss:self];
    }
    
    if (!animated)
    {
        [self dismissComplete];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0.1f;
            _tableView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL finished) {
            [self dismissComplete];
        }];
    }
}

- (void)dismissComplete
{
    [self removeFromSuperview];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverViewDidDismiss:)]) {
        [_delegate popoverViewDidDismiss:self];
    }
}

@end