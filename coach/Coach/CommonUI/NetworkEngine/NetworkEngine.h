//
//  NetworkEngine.h
//  Coach
//
//  Created by LL on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpSuccessBlock)(NSData *data);
typedef void (^HttpFailedBlock)(NSError *error);

typedef NS_ENUM(NSInteger,CustomErrorFailed) {
    
    HttpDefultFailed = -1000,
    
    HttpConnectFailed,
    
};

#define CustomErrorDomain @"com.sskz.interfaceTest"

@class NetworkEngine;

@interface NetworkEngine : NSObject

//+ (NetworkEngine *)defaultEngine;

//发送异步GET请求
// relativeAdd  : 请求的相对地址
// paraNameArr  : 参数名称数组
// paraValueArr : 参数值数组
// block        : 请求完成时回调
+ (void)sendAsynGetRequestRelativeAdd:(NSString *)relativeAdd paraNameArr:(NSArray *)paraNameArr paraValueArr:(NSArray *)paraValueArr completeBlock:(void(^)(BOOL isSuccess,id jsonObj))block;

//发送POST异步请求
// relativeAdd  : 请求的相对地址
// paraNameArr  : 参数名称数组
// paraValueArr : 参数值数组
// block        : 请求完成时回调
+ (void)sendAsynPostRequestRelativeAdd:(NSString *)relativeAdd paraNameArr:(NSArray *)paraNameArr paraValueArr:(NSArray *)paraValueArr completeBlock:(void(^)(BOOL isSuccess,id jsonObj))block;

//发送POST异步请求
// relativeAdd  : 请求的相对地址
//paraDic       : 参数字典
// block        : 请求完成时回调
+ (void)postRequestWithRelativeAdd:(NSString *)relativeAdd paraDic:(NSDictionary *)paraDic completeBlock:(void(^)(BOOL isSuccess,id jsonObj))block;

+ (void)UploadFileWithRelativeAdd:(NSString *)urlStr param:(NSDictionary *)dict serviceName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)data finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock;

/**上传单个文件
 1. url地址
 2. 参数
 3. 对应后台网站上[upload.php中]处理文件的[字段"head"]
 4. 要保存在服务器上的[文件名]
 5. 上传文件的[mimeType]
 6. 上传文件的Data[二进制数据]
 */
+(void)UploadFileWithUrl:(NSString *)urlStr param:(NSDictionary *)dict  serviceName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)data finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock;

/**上传多个文件
 1. url地址
 2. 参数
 3. 对应后台网站上[upload.php中]处理文件的[字段"head"]
 4. 要保存在服务器上的[文件名]
 5. 上传文件的[mimeType]
 6. 上传文件的Data[二进制数据]
 */
+(void)UploadFileWithUrl:(NSString *)urlStr param:(NSDictionary *)dict serviceNameArr:(NSArray *)nameArr fileNameArr:(NSArray *)fileNameArr mimeType:(NSString *)mimeType fileDataArr:(NSArray *)dataArr finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock;

@end
