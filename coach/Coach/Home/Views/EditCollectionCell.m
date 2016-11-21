//
//  EditCollectionCell.m
//  Coach
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EditCollectionCell.h"

@interface EditCollectionCell (){
    
    
}
@end

@implementation EditCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    
//    if (kScreenWidth == 320) {
//        NSInteger spaceNum = (kScreenWidth-95*3-10*2*kScreenWidth/375.0)/2;
//        chooseBtn.frame = CGRectMake((10*kScreenWidth/375.0+(95+spaceNum)*j), 10, 95, 29);
//        chooseBtn.frame =
//    }else{
//        NSInteger spaceNum = (kScreenWidth-95*3-24*2*kScreenWidth/375.0)/2;
//        chooseBtn.frame = CGRectMake((24*kScreenWidth/375.0+(95+spaceNum)*j), 10, 95, 29);
//    }
    
    _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseBtn.frame = CGRectMake((self.frame.size.width-95)/2, 10, 95, 29);
    _chooseBtn.titleLabel.font = Font14;
    
    [_chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.contentView addSubview:_chooseBtn];
    
    [_chooseBtn addTarget:self action:@selector(clickChooseBtn:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setTgaModel:(CardTgaModel *)tgaModel
{
    NSArray * labelImageArr = @[@"card_yellow",@"card_orange",@"card_blue",@"card_red"];
    
    _tgaModel = tgaModel;
    [_chooseBtn setTitle:_tgaModel.tgaName forState:UIControlStateNormal];
    [_chooseBtn setBackgroundImage:[UIImage imageNamed:labelImageArr[_index%4]] forState:UIControlStateNormal];
//    NSLog(@"得到：%ld,%ld",_index%4,(long)_index);
}

- (void)clickChooseBtn:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(EditCollectionCell:clickChooseBtn:)]) {
        [_delegate EditCollectionCell:self clickChooseBtn:btn];
    }
}

@end
