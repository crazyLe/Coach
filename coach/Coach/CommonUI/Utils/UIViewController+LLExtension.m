//
//  UIViewController+LLExtension.m
//  Coach
//
//  Created by LL on 16/8/5.
//  Copyright © 2016年 sskz. All rights reserved.
//



#import "LoginRegisterVC.h"
#import "UIViewController+LLExtension.h"

@implementation UIViewController (LLExtension)

- (void)showLoginRegisterWithLoginSuccessBlock:(void(^)())block
{
    LoginRegisterVC *loginRegisterVC = [[LoginRegisterVC alloc] init];
    loginRegisterVC.successBlock = block;
    [self presentViewController:loginRegisterVC animated:YES completion:nil];
}

@end
