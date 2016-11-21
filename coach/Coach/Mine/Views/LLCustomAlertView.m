//
//  LLCustomAlertView.m
//  Coach
//
//  Created by LL on 16/8/9.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kAnimationTime 0.2f

#import "LLCustomAlertView.h"

@implementation LLCustomAlertView
{
    CGFloat bgViewYOffset;
}

+ (LLCustomAlertView *)showWithTitle:(NSString *)title btnTitleArr:(NSArray *)titleArr textFieldPlaceHolder:(NSString *)placeHolder confirmBtnTitle:(NSString *)confimTitle object:(id)obj userInfo:(NSDictionary *)userInfo delegate:(id)delegate
{
    LLCustomAlertView *alertView = [[LLCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:title btnTitleArr:titleArr textFieldPlaceHolder:placeHolder confirmBtnTitle:confimTitle object:obj userInfo:userInfo delegate:delegate];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    alertView.coverView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        alertView.coverView.alpha = 1;
    }];
    [LLUtils showSpringBackAnimationView:alertView.bgView];
    return alertView;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title btnTitleArr:(NSArray *)titleArr textFieldPlaceHolder:(NSString *)placeHolder confirmBtnTitle:(NSString *)confimTitle object:(id)obj userInfo:(NSDictionary *)userInfo delegate:(id)delegate
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        [self setContraints];
        [self setAttributes];
        
        _titleLbl.text = isEmptyStr(title)?@"取消原因":title;
        if (!titleArr.count) {
            titleArr = @[@"时间更改",@"临时有事",@"其他原因"];
        }

        for (int i = 0; i < titleArr.count; i++) {
            if (i>2) {
                break;
            }
            UIButton *btn = _btnArr[i];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:kGrayHex64 forState:UIControlStateNormal];
            btn.titleLabel.font = kFont12;
            [btn setImage:[UIImage imageNamed:@"iconfont-appointunselect"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"iconfont-appointselect"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 10+i;
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        }
        
        _textView.placeholder = isEmptyStr(placeHolder)?@"请输入其他原因······":placeHolder;
        
        [_confirmBtn setTitle:isEmptyStr(confimTitle)?@"确定取消":confimTitle forState:UIControlStateNormal];
        
        _object = obj;
        
        _userInfo = userInfo;
        
        _delegate = delegate;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisapper:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - Setup

- (void)setUI
{
    _coverView = [UIView new];
    [self addSubview:_coverView];
    
    _bgView = [UIView new];
    [self addSubview:_bgView];
    
    _titleLbl = [UILabel new];
    [_bgView addSubview:_titleLbl];
    
    _leftSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_leftSelectBtn];
    
    _centerSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_centerSelectBtn];
    
    _rightSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_rightSelectBtn];
    
    _textView = [[SZTextView alloc] init];
    [_bgView addSubview:_textView];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_confirmBtn];
    
    _exitBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_exitBtn];
    
    _lineView = [UIView new];
    [_bgView addSubview:_lineView];
    
    _btnArr = @[_leftSelectBtn,_centerSelectBtn,_rightSelectBtn];
}

- (void)setContraints
{
    WeakObj(self)
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.equalTo(selfWeak.mas_width).multipliedBy(0.77f);
        make.height.equalTo(selfWeak.mas_height).multipliedBy(0.4f);
    }];
    
    WeakObj(_bgView)
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
        make.width.equalTo(_bgViewWeak).multipliedBy(0.328f);
        make.height.equalTo(_bgViewWeak).multipliedBy(0.17f);
    }];
    
    WeakObj(_titleLbl)
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLblWeak.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(1.0f);
    }];
    
    [_centerSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.width.equalTo(_bgViewWeak).multipliedBy(0.28f);
        make.height.offset(25);
        make.top.equalTo(_titleLblWeak.mas_bottom).offset(25);
    }];
    
    WeakObj(_centerSelectBtn)
    [_leftSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_centerSelectBtnWeak.mas_left).offset(-5);
        make.centerY.width.height.equalTo(_centerSelectBtnWeak);
    }];
    
    [_rightSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerSelectBtnWeak.mas_right).offset(5);
        make.centerY.width.height.equalTo(_centerSelectBtnWeak);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-15);
        make.centerX.offset(0);
        make.height.offset(40);
        make.width.equalTo(_bgViewWeak).multipliedBy(0.36);
    }];
    
    WeakObj(_leftSelectBtn)
    WeakObj(_rightSelectBtn)
    WeakObj(_confirmBtn)
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftSelectBtnWeak);
        make.right.equalTo(_rightSelectBtnWeak);
        make.top.equalTo(_centerSelectBtnWeak.mas_bottom).offset(10);
        make.bottom.equalTo(_confirmBtnWeak.mas_top).offset(-14);
    }];
    
    WeakObj(_exitBtn)
    [_exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.centerY.height.equalTo(_titleLblWeak);
        make.width.equalTo(_exitBtnWeak.mas_height);
    }];
}

- (void)setAttributes
{
    _coverView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5f];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverView:)];
    [_coverView addGestureRecognizer:tap];
    
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10.0f;
    UITapGestureRecognizer *tapBgView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [_bgView addGestureRecognizer:tapBgView];
    
    _titleLbl.textColor = kAppThemeColor;
    _titleLbl.font = kFont15;
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    
    [_exitBtn setImage:[UIImage imageNamed:@"iconfont-appointexit"] forState:UIControlStateNormal];
    
    _textView.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
    _textView.placeholderTextColor = kGrayHex88;
    _textView.layer.borderWidth = kLineWidth;
    _textView.layer.cornerRadius = 10.0f;
    _textView.layer.masksToBounds = YES;
    _textView.delegate = self;
    
    [_confirmBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.tag = 13;
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = kFont13;
    _confirmBtn.layer.cornerRadius = 21.0f;
    _confirmBtn.layer.masksToBounds = YES;
//    [_confirmBtn setBackgroundColor:kAppThemeColor];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-appointlistbg"] forState:UIControlStateNormal];
    
    [_exitBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _exitBtn.tag = 14;
    
    _lineView.backgroundColor = [UIColor colorWithHexString:@"b5d3fe"];
}

- (void)clickBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 10: case 11: case 12:
        {
            //left center right btn
            if (_delegate && [_delegate respondsToSelector:@selector(LLCustomAlertView:clickSelectBtn:)]) {
                [_delegate LLCustomAlertView:self clickSelectBtn:btn];
            }

            for (UIButton *btn in _btnArr) {
                btn.selected = NO;
            }
            btn.selected = YES;
            if (btn.tag==12) {
                [_textView becomeFirstResponder];
            }
            else
            {
                [_textView resignFirstResponder];
            }
        }
            break;
        case 13:
        {
            //confirm btn
            if (_delegate && [_delegate respondsToSelector:@selector(LLCustomAlertView:clickConfirmSelectBtn:)]) {
                [_delegate LLCustomAlertView:self clickConfirmSelectBtn:btn];
            }
        }
            break;
        case 14:
        {
            //exit btn
            if (_delegate && [_delegate respondsToSelector:@selector(LLCustomAlertView:clickExitSelectBtn:)]) {
                [_delegate LLCustomAlertView:self clickExitSelectBtn:btn];
            }
            [self dismiss];
        }
            break;
            
        default:
            break;
    }
}

- (void)tapCoverView:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

- (void)tapBgView:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}

//- (void)keyboardWillShow:(NSNotification *)notify
//{
//    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    bgViewYOffset = keyboardFrame.size.height - kScreenHeight*0.6f/2;
//    if (bgViewYOffset<0) {
//        bgViewYOffset=0;
//    }
//    [UIView animateWithDuration:0.25f animations:^{
//        _bgView.center = CGPointMake(_bgView.center.x, _bgView.center.y-bgViewYOffset);
//    }];
//}

//- (void)keyboardWillDisapper:(NSNotification *)notify
//{
//    [UIView animateWithDuration:0.25f animations:^{
//        _bgView.center = CGPointMake(_bgView.center.x, _bgView.center.y+bgViewYOffset);
//    }];
//}

- (void)dismiss
{
    [self endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewWillDismiss:)]) {
        [_delegate alertViewWillDismiss:self];
    }
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.alpha = 0;
        self.bgView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (_delegate && [_delegate respondsToSelector:@selector(alertViewDidDismiss:)]) {
            [_delegate alertViewDidDismiss:self];
        }
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLCustomAlertView:textViewDidChange:)]) {
        [_delegate LLCustomAlertView:self textViewDidChange:_textView];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLCustomAlertView:textViewDidBeginEditing:)]) {
        [_delegate LLCustomAlertView:self textViewDidBeginEditing:_textView];
    }
    

    for (UIButton *btn in _btnArr) {
        btn.selected = NO;
    }
    _rightSelectBtn.selected = YES;
}

@end
