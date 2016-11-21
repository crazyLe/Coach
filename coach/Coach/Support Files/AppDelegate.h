//
//  AppDelegate.h
//  Coach
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) Reachability *hostReachability;

@property (nonatomic,strong)NSDictionary *launchOptions;

+ (AppDelegate *)sharedApplicationDelegate;

@end

