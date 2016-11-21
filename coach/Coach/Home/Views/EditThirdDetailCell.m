//
//  EditThirdDetailCell.m
//  Coach
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "EditThirdDetailCell.h"
#import "CardTgaModel.h"

@implementation EditThirdDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
//    NSArray * labelArr = @[@"资深教练",@"耐心教学",@"脾气温和",@"多年教龄",@"其他标签",@"其它标签"];
    //    NSArray * labelColorArr = @[[UIColor orangeColor],[UIColor greenColor],[UIColor blueColor],[UIColor redColor],[UIColor whiteColor],[UIColor whiteColor]];
//    NSArray * labelImageArr = @[@"card_yellow",@"card_orange",@"card_blue",@"card_red",@"card_white",@"card_white"];
    
    NSArray * labelArr = @[@"资深教练",@"耐心教学",@"脾气温和"];
    
    NSArray * labelImageArr = @[@"card_yellow",@"card_orange",@"card_blue"];
    
    //    NSArray * labelImageArr = @[RGBCOLOR(255, 167, 47),RGBCOLOR(111, 197, 27),RGBCOLOR(75, 167, 254),RGBCOLOR(255, 75, 74),RGBCOLOR(255, 255, 255),RGBCOLOR(255, 255, 255)];
    
    NSInteger spaceNum = (kScreenWidth-95*3-10*2*kScreenWidth/375.0)/2;
//    NSLog(@"--%ld--",(long)spaceNum);
//    for (int i = 0; i<2; i++) {
        for (int j=0; j<3; j++) {
            
            UIButton * chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (kScreenWidth == 320) {
                NSInteger spaceNum = (kScreenWidth-95*3-10*2*kScreenWidth/375.0)/2;
                chooseBtn.frame = CGRectMake((10*kScreenWidth/375.0+(95+spaceNum)*j), 10, 95, 29);
            }else{
                NSInteger spaceNum = (kScreenWidth-95*3-24*2*kScreenWidth/375.0)/2;
                chooseBtn.frame = CGRectMake((24*kScreenWidth/375.0+(95+spaceNum)*j), 10, 95, 29);
            }
            
            chooseBtn.titleLabel.font = Font14;
            [chooseBtn setTitle:labelArr[j] forState:UIControlStateNormal];
            [chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            if ((i==1 && j==1) ||(i==1 && j==2)) {
//                [chooseBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
//            }
            [chooseBtn setBackgroundImage:[UIImage imageNamed:labelImageArr[j]] forState:UIControlStateNormal];
            [self.contentView addSubview:chooseBtn];
        }
//    }

}

- (void)setTgaModel:(CardTgaModel *)tgaModel
{
    _tgaModel = tgaModel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
