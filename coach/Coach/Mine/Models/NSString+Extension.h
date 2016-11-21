//
//  NSString+Extension.h
//  
//
//  Created by zwz on 14-5-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)

/**
 *  计算文本占用的宽高
 *
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *
 *  @return 占用的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)convertSimpleUnicodeStr:(NSString *)inputStr;

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;
/**
 *  ios 格式化金额，金额三位一个逗号
 *
 *  @param num 原金额字符串
 *
 *  @return Format后字符串
 */
+ (NSString *)countNumAndChangeFormat:(NSString *)num;

@end
