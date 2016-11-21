//
//  DateCell.h
//  wills
//
//  Created by ai_ios on 16/4/18.
//  Copyright © 2016年 ai_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateCell : UICollectionViewCell

/// 修改label字体颜色
@property (nonatomic, strong) UIColor *textTintColor;
/// 星期
@property (nonatomic, copy) NSString *week;
/// 日期
@property (nonatomic, copy) NSString *date;

@end
