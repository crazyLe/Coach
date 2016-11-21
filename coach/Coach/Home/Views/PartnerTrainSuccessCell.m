//
//  PartnerTrainSuccessCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PartnerTrainSuccessCell.h"

@implementation PartnerTrainSuccessCell
{
    NSMutableArray *_topImageArray;
    UIImageView *middleImageView;
    NSMutableArray *_bottomImageArray;    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headLabel.font =[UIFont boldSystemFontOfSize:15*AutoSizeScaleX];
    self.backgroundColor = BG_COLOR;
    _topImageArray = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor colorWithHexString:@"c9c9c9"];
        [self.contentView addSubview:imageView];
        [_topImageArray addObject:imageView];
    }
    
    UIImageView *imageView = [[UIImageView alloc]init];
    middleImageView = imageView;
    imageView.clipsToBounds = NO;
    imageView.image = [UIImage imageNamed:@"iconfont-greenpoint"];
    [self.contentView addSubview:imageView];
    
    _bottomImageArray = [NSMutableArray array];
    for (int i = 0; i<19; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor colorWithHexString:@"c9c9c9"];
        [self.contentView addSubview:imageView];
        [_bottomImageArray addObject:imageView];
    }
 
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    for (int i = 0; i<_topImageArray.count; i++) {
        UIImageView *imageView = _topImageArray[i];
        imageView.frame = CGRectMake(20, (3+8)*i, 3, 3);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
    }
    middleImageView.frame = CGRectMake(14, 28,15, 15);
    for (int i = 0; i<_bottomImageArray.count; i++) {
        UIImageView *imageView = _bottomImageArray[i];
        imageView.frame = CGRectMake(20, 68+(3+8)*i, 3, 3);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
    }


}

@end
