//
//  LLAdmissionAlertView.m
//  Coach
//
//  Created by LL on 16/8/15.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define kAnimationTime 0.2f

#import "LLAdmissionAlertView.h"

@implementation LLAdmissionAlertView
{
    CGFloat bgViewYOffset;
}

+ (LLAdmissionAlertView *)showWithTitle:(NSString *)title textFieldPlaceHolder:(NSString *)placeHolder confirmBtnTitle:(NSString *)confimTitle rechargeBtnTitle:(NSString *)rechargeTitle beansUnit:(NSString *)unit beansRemain:(NSMutableAttributedString *)beansRemainAtt object:(id)obj userInfo:(NSDictionary *)userInfo delegate:(id)delegate
{
    LLAdmissionAlertView *alertView = [[LLAdmissionAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:title  textFieldPlaceHolder:placeHolder confirmBtnTitle:confimTitle rechargeBtnTitle:rechargeTitle beansUnit:unit beansRemain:beansRemainAtt object:obj userInfo:userInfo delegate:delegate];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    alertView.coverView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        alertView.coverView.alpha = 1;
    }];
    [LLUtils showSpringBackAnimationView:alertView.bgView];
    return alertView;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title textFieldPlaceHolder:(NSString *)placeHolder confirmBtnTitle:(NSString *)confimTitle rechargeBtnTitle:(NSString *)rechargeTitle beansUnit:(NSString *)unit beansRemain:(NSMutableAttributedString *)beansRemainAtt object:(id)obj userInfo:(NSDictionary *)userInfo delegate:(id)delegate
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        [self setContraints];
        [self setAttributes];
        
        _titleLbl.text = isEmptyStr(title)?@"取消原因":title;
        
        _textField.attributedPlaceholder = [NSMutableAttributedString attributeStringWithText:isEmptyStr(placeHolder)?@"请输入要奖励赚豆数":placeHolder attributes:@[kGrayHex88]];
        
        [_confirmBtn setTitle:isEmptyStr(confimTitle)?@"保存":confimTitle forState:UIControlStateNormal];
        
        [_rechargeBtn setTitle:isEmptyStr(rechargeTitle)?@"充值":rechargeTitle forState:UIControlStateNormal];
        
        _unitLbl.text = isEmptyStr(unit)?@":  赚豆":unit;
        
        _beansRemainLbl.attributedText = isNull(beansRemainAtt)?[NSMutableAttributedString attributeStringWithText:nil attributes:nil]:beansRemainAtt;
        
        _object = obj;
        
        _userInfo = userInfo;
        
        _delegate = delegate;
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
    
    _textField = [[UITextField alloc] init];
    [_bgView addSubview:_textField];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_confirmBtn];
    
    _unitLbl = [UILabel new];
    [_bgView addSubview:_unitLbl];
    
    _beansRemainLbl = [UILabel new];
    [_bgView addSubview:_beansRemainLbl];
    
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_rechargeBtn];
    
    _exitBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_exitBtn];
    
    _lineView = [UIView new];
    [_bgView addSubview:_lineView];
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
        make.height.equalTo(selfWeak.mas_height).multipliedBy(0.32f);
    }];
    
    WeakObj(_bgView)
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(0);
        make.width.equalTo(_bgViewWeak).multipliedBy(0.75f);
        make.height.equalTo(_bgViewWeak).multipliedBy(0.17f);
    }];
    
    WeakObj(_titleLbl)
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLblWeak.mas_bottom);
        make.left.right.offset(0);
        make.height.offset(1.0f);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-15);
        make.centerX.offset(0);
        make.height.offset(40);
        make.width.equalTo(_bgViewWeak).multipliedBy(0.36);
    }];
    
    WeakObj(_confirmBtn)
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-0.167*kScreenWidth*0.77f);
        make.width.offset(40);
        make.height.equalTo(_confirmBtnWeak);
        make.bottom.equalTo(_confirmBtnWeak.mas_top).offset(-14);
    }];
    
    WeakObj(_rechargeBtn)
    [_beansRemainLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0.167*kScreenWidth*0.77f);
        make.height.bottom.equalTo(_rechargeBtnWeak);
        make.right.equalTo(_rechargeBtnWeak.mas_left);
    }];
    
    WeakObj(_lineView)
    [_unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rechargeBtnWeak);
//        make.bottom.equalTo(_rechargeBtnWeak.mas_top).offset(-10);
        make.top.equalTo(_lineViewWeak.mas_bottom).offset(13);
        make.height.offset(35);
        make.width.offset(50);
    }];
    
    WeakObj(_unitLbl)
    WeakObj(_beansRemainLbl)
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_unitLblWeak.mas_left).offset(-5);
        make.centerY.height.equalTo(_unitLblWeak);
        make.left.equalTo(_beansRemainLblWeak);
    }];
//    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_leftSelectBtnWeak);
//        make.right.equalTo(_rightSelectBtnWeak);
//        make.top.equalTo(_centerSelectBtnWeak.mas_bottom).offset(10);
//        make.bottom.equalTo(_confirmBtnWeak.mas_top).offset(-14);
//    }];
    
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
    
    [_exitBtn setImage:[UIImage imageNamed:@"Admisson_Multi"] forState:UIControlStateNormal];
    
    _textField.layer.borderColor = rgb(232, 245, 250).CGColor;
    _textField.layer.borderWidth = 1.0f;
    _textField.layer.cornerRadius = 5.0f;
    _textField.layer.masksToBounds = YES;
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.font = kFont13;
    
    [_confirmBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.tag = 13;
    [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = kFont13;
    _confirmBtn.layer.cornerRadius = 20.0f;
    _confirmBtn.layer.masksToBounds = YES;
//    [_confirmBtn setBackgroundColor:kAppThemeColor];
    [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"Admission_GreenBg"] forState:UIControlStateNormal];
    
    [_rechargeBtn setTitleColor:[UIColor colorWithHexString:@"fc8e0c"] forState:UIControlStateNormal];
    _rechargeBtn.titleLabel.font = kFont13;
    _rechargeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rechargeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _rechargeBtn.tag = 15;
    
    _unitLbl.textColor = kGrayHex99;
    _unitLbl.font = kFont13;
    _unitLbl.textAlignment = NSTextAlignmentRight;
    
    [_exitBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _exitBtn.tag = 14;
    
    _lineView.backgroundColor = [UIColor colorWithHexString:@"b5d3fe"];
}

- (void)clickBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 13:
        {
            //confirm btn
            if (_delegate && [_delegate respondsToSelector:@selector(LLAdmissionAlertView:clickConfirmSelectBtn:)]) {
                [_delegate LLAdmissionAlertView:self clickConfirmSelectBtn:btn];
            }
        }
            break;
        case 14:
        {
            //exit btn
            if (_delegate && [_delegate respondsToSelector:@selector(LLAdmissionAlertView:clickExitSelectBtn:)]) {
                [_delegate LLAdmissionAlertView:self clickExitSelectBtn:btn];
            }
            [self dismiss];
        }
            break;
        case 15:
        {
            //recharge btn
            if (_delegate && [_delegate respondsToSelector:@selector(LLAdmissionAlertView:clickRechargeBtn:)]) {
                [_delegate LLAdmissionAlertView:self clickRechargeBtn:btn];
            }
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLAdmissionAlertView:textFieldDidChange:)]) {
        [_delegate LLAdmissionAlertView:self textFieldDidChange:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLAdmissionAlertView:textFieldDidEndEditing:)]) {
        [_delegate LLAdmissionAlertView:self textFieldDidEndEditing:textField];
    }
}

@end
