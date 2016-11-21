//
//  NSString+LLRegEx.h
//  Coach
//
//  Created by LL on 16/8/24.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LLRegEx)

//邮箱判断
- (BOOL)isEmailAddress;
//用户名判断
- (BOOL)isUserName;
//用户密码判断
- (BOOL)isPassword;
//邮箱判断
- (BOOL)isEmail;
//URL判断
- (BOOL)isUrl;
//电话号码判断
- (BOOL)isTelephone;

@end
