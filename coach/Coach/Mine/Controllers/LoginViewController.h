//
//  LoginViewController.h
//  Coach
//
//  Created by LL on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>

@optional

- (void)loginSuccess;

@end

@interface LoginViewController : UIViewController

@property (nonatomic,assign) id delegate;

@end
