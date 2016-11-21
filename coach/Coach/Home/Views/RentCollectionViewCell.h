//
//  RentCollectionViewCell.h
//  Coach
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RentCollectionViewCellTypeCoachRent = 1,
    RentCollectionViewCellTypePlaceRent
}RentCollectionViewCellType;

@interface RentCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *imgView,*symbolImgView;

@property (nonatomic,strong) UILabel *priceLbl,*areaLbl,*infoLbl,*remainLbl;

@property (nonatomic,assign)   RentCollectionViewCellType type;

- (void)setContentWithType:(RentCollectionViewCellType)type;

@end
