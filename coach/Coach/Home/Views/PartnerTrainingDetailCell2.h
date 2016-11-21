//
//  PartnerTrainingDetailCell2.h
//  学员端
//
//  Created by zuweizhong  on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerTrainingDetailCell2 : UITableViewCell

@property(nonatomic,strong)UIButton * leftScrollBtn;

@property(nonatomic,strong)UIButton * rightSrcollBtn;

@property(nonatomic,strong)NSMutableArray * dayBtnArray;

@property(nonatomic,strong)NSMutableArray * orderViewArray;

@property(nonatomic,strong)UILabel * selectedLabel;

@property (nonatomic, assign)CGFloat cellHeight;


@end
