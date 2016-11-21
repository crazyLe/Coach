//
//  ProgressHUD.m
//  好心人
//
//  Created by zwz on 15/9/19.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import "ProgressHUD.h"
#import "KVNProgress.h"
#import <MBProgressHUD.h>
#import <SVProgressHUD.h>
static ProgressHUD *progressView = nil;
@interface ProgressHUD ()

@property (nonatomic, strong) MBProgressHUD *stateHud;

@end

@implementation ProgressHUD

+(id) sharedInstance
{
    @synchronized(self) {
        if (progressView == nil) {
            
            progressView = [[ProgressHUD alloc]init];
            
            //KVNProgress属性配置
            [KVNProgress appearance].statusColor = [UIColor whiteColor];
            [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
            [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
            [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
            [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
            [KVNProgress appearance].backgroundFillColor = [UIColor whiteColor];
            [KVNProgress appearance].backgroundTintColor =[UIColor blackColor];
            [KVNProgress appearance].successColor = [UIColor whiteColor];
            [KVNProgress appearance].errorColor = [UIColor whiteColor];
            [KVNProgress appearance].circleSize = 50.0f;
            [KVNProgress appearance].lineWidth = 1.0f;

            //SVProgressView配置
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//无蒙版，无交互
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//黑色风格
            
            
        }
    }
    return progressView;
    
}
-(void)showNormalStateKVNHUDWithTitle:(NSString *)title
{
    [KVNProgress showWithStatus:title];
}
-(void)showNormalStateKVNHUDWithTitleAndSolidBackground:(NSString *)title
{
    [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: title,
                                      KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
                                      
                                      KVNProgressViewParameterFullScreen: @(NO)}];
    
    
}
-(void)showNormalStateKVNHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay
{
    if (title == nil) {
        [KVNProgress show];
    }else
    {
        [KVNProgress showWithStatus:title];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
    
    
}
-(void)showSuccessKVNHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay
{
    [KVNProgress showSuccessWithStatus:title];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
    
    
}
-(void)showErrorKVNHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay
{
    [KVNProgress showErrorWithStatus:title];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
    
    
}
-(void)dismissKVNHud
{
    [KVNProgress dismiss];
}

-(void)showNormalStateMBHUDWithTitle:(NSString *)title animaton:(BOOL)animation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.stateHud) {
            [self.stateHud hide:NO];
            self.stateHud = nil;
        }
        self.stateHud = [[MBProgressHUD alloc] initWithWindow:[[[UIApplication sharedApplication] windows] firstObject]];
        [[[UIApplication sharedApplication].delegate window] addSubview:self.stateHud];
        self.stateHud.removeFromSuperViewOnHide = YES;
        self.stateHud.mode = MBProgressHUDModeIndeterminate;
        self.stateHud.labelText = title;
        
        [self.stateHud show:animation];
    });
    
}
-(void)showNormalStateMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.stateHud) {
            [self.stateHud hide:NO];
            self.stateHud = nil;
        }
        self.stateHud = [[MBProgressHUD alloc] initWithWindow:[[[UIApplication sharedApplication] windows] firstObject]];
        [[[UIApplication sharedApplication].delegate window] addSubview:self.stateHud];
        self.stateHud.removeFromSuperViewOnHide = YES;
        self.stateHud.mode = MBProgressHUDModeIndeterminate;
        self.stateHud.labelText = title;
        [self.stateHud hide:animation afterDelay:delay];
    });
    
}
-(void)showSuccessMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.stateHud) {
            [self.stateHud hide:NO];
        }
        MBProgressHUD * newStateHud = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication].delegate window]];
        [[[UIApplication sharedApplication].delegate window] addSubview:newStateHud];
        newStateHud.removeFromSuperViewOnHide = YES;
        newStateHud.mode = MBProgressHUDModeCustomView;
        newStateHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"success.png"]]];
        newStateHud.customView.frame=CGRectMake(newStateHud.customView.frame.origin.x, newStateHud.customView.frame.origin.y, 40, 40);
        newStateHud.labelText=title;
        [newStateHud show:animation];
        
        [newStateHud hide:animation afterDelay:delay];
    });
    
    
}
-(void)showErrorMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.stateHud) {
            [self.stateHud hide:NO];
        }
        MBProgressHUD * newStateHud = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication].delegate window]];
        [[[UIApplication sharedApplication].delegate window] addSubview:newStateHud];
        newStateHud.removeFromSuperViewOnHide = YES;
        newStateHud.mode = MBProgressHUDModeCustomView;
        newStateHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"error"]]];
        newStateHud.customView.frame=CGRectMake(newStateHud.customView.frame.origin.x, newStateHud.customView.frame.origin.y, 40, 40);
        
        newStateHud.labelText=title;
        
        [newStateHud show:animation];
        
        [newStateHud hide:animation afterDelay:delay];
    });
    
}
-(void)dismissMBHud
{
    if (self.stateHud) {
        [self.stateHud hide:NO];
        self.stateHud = nil;
    }
    
}
-(void)showMultiLineNormalStateMBHUDWithTitle:(NSString *)title animaton:(BOOL)animation
{
    __block UIView * blockView = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        blockView = [[UIApplication sharedApplication].windows lastObject];
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:blockView animated:animation];
        hud.detailsLabelText = title;
        hud.opacity = 0.5;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        //    hud.dimBackground = YES;
        hud.detailsLabelFont = [UIFont systemFontOfSize:16]; //Johnkui - added
    });
    
}
-(void)showMultiLineNormalStateMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation
{
    
    __block UIView * blockView = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        blockView = [[UIApplication sharedApplication].windows lastObject];
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:blockView animated:animation];
        hud.detailsLabelText = title;
        hud.opacity = 0.5;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        //    hud.dimBackground = YES;
        hud.detailsLabelFont = [UIFont systemFontOfSize:16]; //Johnkui - added
        
        [hud hide:animation afterDelay:delay];
        
    });
    
}
-(void)showMultiLineSuccessMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation
{
    __block UIView * blockView = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (blockView == nil)
            blockView = [[UIApplication sharedApplication].windows lastObject];
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:blockView animated:animation];
        hud.opacity = 0.5;
        hud.detailsLabelText = title;
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"success.png"]]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        hud.detailsLabelFont = [UIFont systemFontOfSize:16]; //Johnkui - added
        // 1秒之后再消失
        [hud hide:animation afterDelay:delay];
    });
    
    
}
-(void)showMultiLineErrorMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation
{
    
    __block UIView * blockView = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (blockView == nil) blockView = [[UIApplication sharedApplication].windows lastObject];
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:blockView animated:animation];
        hud.detailsLabelText = title;
        hud.opacity = 0.5;
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"error.png"]]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        hud.detailsLabelFont = [UIFont systemFontOfSize:16]; //Johnkui - added
        // 1秒之后再消失
        [hud hide:animation afterDelay:delay];
    });
    
    
}
-(void)showNormalStateSVHUDWithTitle:(NSString *)title
{
    if (title == nil) {
        [SVProgressHUD show];
    }else
    {
        [SVProgressHUD showWithStatus:title];
    }

}
-(void)showNormalStateSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay
{
    if (title == nil) {
        [SVProgressHUD show];
    }else
    {
        [SVProgressHUD showWithStatus:title];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });

}
-(void)showSuccessSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation
{
    [SVProgressHUD showSuccessWithStatus:title];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });


}
-(void)showErrorSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay
{
    [SVProgressHUD showErrorWithStatus:title];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });

}
-(void)dismissSVHud
{
    [SVProgressHUD dismiss];
}


@end
