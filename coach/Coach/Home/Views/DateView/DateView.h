//
//  DateView.h
//  wills
//
//  Created by ai_ios on 16/4/18.
//  Copyright © 2016年 ai_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewDelegate <NSObject>

/**
 *  选中星期几
 */
- (void)dateViewDidSelectedIndex:(NSInteger)index ;

@end

/// 日期View
@interface DateView : UIView

@property (nonatomic,  weak) id<DateViewDelegate>delegate ;

@property (nonatomic, strong) NSArray *dataArray ;



@end
