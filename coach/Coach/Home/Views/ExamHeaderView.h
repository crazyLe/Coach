//
//  ExamHeaderView.h
//  Coach
//
//  Created by gaobin on 16/7/29.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHPickView.h"
typedef enum {
    
    HeaderButtonTypeFrom = 0,
    
    HeaderButtonTypeTo,
    
    HeaderButtonTypeCarType
    

}HeaderViewButtonType;

@class ExamHeaderView;

@protocol HeaderReusableViewDelegate <NSObject>

- (void)headerReusableView:(ExamHeaderView *)headerView didClickBtnWithType:(HeaderViewButtonType)type;

@end








@interface ExamHeaderView : UICollectionReusableView
@property (nonatomic, strong) UIButton * fromTimeBtn;
@property (nonatomic, strong) UIButton * toTimeBtn;
@property (nonatomic,strong)UIButton * carTypeBtn;
@property (nonatomic, weak) id<HeaderReusableViewDelegate> delegate;

@end
