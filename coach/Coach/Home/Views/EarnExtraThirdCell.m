//
//  EarnExtraThirdCell.m
//  Coach
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EarnExtraThirdCell.h"
#import "EarnCarListModel.h"

@interface EarnExtraThirdCell ()
{
    NSMutableArray * _machineArr;
}
@end

@implementation EarnExtraThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _machineArr = [NSMutableArray array];
    
    [_firstBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10.0 , 0.0, 0)];
    [_secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10.0 , 0.0, 0)];
    
    
    [_chooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_chooseBtn.imageView.image.size.width, 0, _chooseBtn.imageView.image.size.width)];
    if (isEmptyStr(_chooseBtn.titleLabel.text)) {
         [_chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _chooseBtn.bounds.size.width-_chooseBtn.imageView.image.size.width-7, 0, 16-_chooseBtn.imageView.image.size.width+7)];
    }
    else
    {
         [_chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _chooseBtn.bounds.size.width-_chooseBtn.imageView.image.size.width, 0, 16-_chooseBtn.imageView.image.size.width)];
    }
   
    
    _chooseBtn.layer.cornerRadius = 3.0;
    _chooseBtn.layer.borderWidth = 1.0;
    _chooseBtn.layer.borderColor = rgb(227, 227, 227).CGColor;
    [_chooseBtn addTarget:self action:@selector(clickChooseBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _firstBtn.tag = 100;
    [_firstBtn addTarget:self action:@selector(clickFirstBtn:) forControlEvents:UIControlEventTouchUpInside];
    _secondBtn.tag = 200;
    [_secondBtn addTarget:self action:@selector(clickFirstBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickChooseBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(EarnExtraThirdCellClickChooseBtn)]) {
        [_delegate EarnExtraThirdCellClickChooseBtn];
    }
}

- (void)clickFirstBtn:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(EarnExtraThirdCellVehicleTypeBtn:)]) {
        switch (sender.tag) {
            case 100:
            {
                [_firstBtn setImage:[UIImage imageNamed:@"earn_blueCircle.png"] forState:UIControlStateNormal];
                [_secondBtn setImage:[UIImage imageNamed:@"earn_garyCircle.png"] forState:UIControlStateNormal];
                [_delegate EarnExtraThirdCellVehicleTypeBtn:@"C1"];
                
            }
                break;
            case 200:
            {
                [_firstBtn setImage:[UIImage imageNamed:@"earn_garyCircle.png"] forState:UIControlStateNormal];
                [_secondBtn setImage:[UIImage imageNamed:@"earn_blueCircle.png"] forState:UIControlStateNormal];
                [_delegate EarnExtraThirdCellVehicleTypeBtn:@"C2"];
            }
                break;
                
            default:
                break;
        }
        
    }
}

- (void)setCarArray:(NSMutableArray *)carArray
{
    _carArray = carArray;
    _machineArr = _carArray;
}

- (void)setModel:(EarnAppointModel *)model
{
    _model = model;
//    if ([_model.carId isEqualToString:@"1"]) {
//        [_chooseBtn setTitle:@"" forState:UIControlStateNormal];
//    }else if ([_model.carId isEqualToString:@"2"]) {
//        [_chooseBtn setTitle:@"江淮" forState:UIControlStateNormal];
//    }else if ([_model.carId isEqualToString:@"3"]) {
//        [_chooseBtn setTitle:@"桑塔纳" forState:UIControlStateNormal];
//    }
    for (EarnCarListModel * carModel in _machineArr) {
        if ([model.carId isEqualToString:carModel.idStr]) {
           [_chooseBtn setTitle:carModel.car_name forState:UIControlStateNormal];
        }
    }
    
    if (isEmptyStr(_chooseBtn.titleLabel.text)) {
        [_chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _chooseBtn.bounds.size.width-_chooseBtn.imageView.image.size.width-7, 0, 16-_chooseBtn.imageView.image.size.width+7)];
    }
    else
    {
        [_chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _chooseBtn.bounds.size.width-_chooseBtn.imageView.image.size.width, 0, 16-_chooseBtn.imageView.image.size.width)];
    }
    
    NSLog(@"车型的id：---%@--",model.carId);
    
    if ([_model.classId isEqualToString:@"1"]) {
        [_firstBtn setImage:[UIImage imageNamed:@"earn_blueCircle.png"] forState:UIControlStateNormal];
        [_secondBtn setImage:[UIImage imageNamed:@"earn_garyCircle.png"] forState:UIControlStateNormal];
    }else if ([_model.classId isEqualToString:@"2"]){
        [_firstBtn setImage:[UIImage imageNamed:@"earn_garyCircle.png"] forState:UIControlStateNormal];
        [_secondBtn setImage:[UIImage imageNamed:@"earn_blueCircle.png"] forState:UIControlStateNormal];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
