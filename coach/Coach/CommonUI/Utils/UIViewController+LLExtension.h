//
//  UIViewController+LLExtension.h
//  Coach
//
//  Created by LL on 16/8/5.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LLExtension)

//显示登录注册界面
//block : 登录成功回调
- (void)showLoginRegisterWithLoginSuccessBlock:(void(^)())block;

@end
