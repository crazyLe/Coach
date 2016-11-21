//
//  ProgressHUD.h
//  好心人
//
//  Created by zwz on 15/9/19.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressHUD : NSObject

+ (id) sharedInstance;
/**
 * 正常模式的显示KVNProgressView
 */
-(void)showNormalStateKVNHUDWithTitle:(NSString *)title;

-(void)showNormalStateKVNHUDWithTitleAndSolidBackground:(NSString *)title;

/**
 * 正常模式的显示和隐藏KVNProgressView
 */
-(void)showNormalStateKVNHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay;

/**
 * 成功模式的显示和隐藏KVNProgressView
 */
-(void)showSuccessKVNHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay;


/**
 * 失败模式的显示和隐藏KVNProgressView
 */
-(void)showErrorKVNHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay;

/**
 * 直接隐藏KVNProgressView
 */
-(void)dismissKVNHud;


/**
 * 正常模式的显示MBProgressView
 */
-(void)showNormalStateMBHUDWithTitle:(NSString *)title animaton:(BOOL)animation;

/**
 * 正常模式的显示和隐藏MBProgressView
 */
-(void)showNormalStateMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation;

/**
 * 成功模式的显示和隐藏MBProgressView
 */
-(void)showSuccessMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation;

/**
 * 失败模式的显示和隐藏MBProgressView
 */
-(void)showErrorMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation;

/**
 * 直接隐藏MBProgressView
 */
-(void)dismissMBHud;

/**
 * 多行正常模式的显示MBProgressView
 */
-(void)showMultiLineNormalStateMBHUDWithTitle:(NSString *)title animaton:(BOOL)animation;

/**
 * 多行正常模式的显示和隐藏MBProgressView
 */
-(void)showMultiLineNormalStateMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation;

/**
 * 多行成功模式的显示和隐藏MBProgressView
 */
-(void)showMultiLineSuccessMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation;

/**
 * 多行失败模式的显示和隐藏MBProgressView
 */
-(void)showMultiLineErrorMBHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation;

/**
 * 正常模式的显示SVProgressView
 */
-(void)showNormalStateSVHUDWithTitle:(NSString *)title;

/**
 * 正常模式的显示和隐藏SVProgressView
 */
-(void)showNormalStateSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay;

/**
 * 成功模式的显示和隐藏SVProgressView
 */
-(void)showSuccessSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation;

/**
 * 失败模式的显示和隐藏SVProgressView
 */
-(void)showErrorSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay;

/**
 * 直接隐藏SVProgressView
 */
-(void)dismissSVHud;
@end
