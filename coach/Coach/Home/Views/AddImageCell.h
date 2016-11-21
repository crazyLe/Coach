//
//  AddImageCell.h
//  Coach
//
//  Created by LL on 16/8/13.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AddImageCellBtnTypeLeftBtn = 10,
    AddImageCellBtnTypeCenterBtn ,
    AddImageCellBtnTypeRightBtn
}AddImageCellBtnType;

@class AddImageCell;

@protocol AddImageCellDelegate <NSObject>

- (void)AddImageCell:(AddImageCell *)cell clickBtn:(UIButton *)btn;

@end

@interface AddImageCell : SuperTableViewCell

@property (nonatomic,strong) NSMutableArray *btnArr;

@property (nonatomic,assign) id delegate;

@end
