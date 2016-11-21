//
//  NetworkEngine.m
//  Coach
//
//  Created by LL on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//


#import <AFNetworking.h>
#import "NetworkEngine.h"

@implementation NetworkEngine
{
    
}

//+ (NetworkEngine *)defaultEngine
//{
//    static NetworkEngine *engine = nil;
//    if (!engine) {
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            engine = [[NetworkEngine alloc] init];
//        });
//    }
//    return engine;
//}

//发送异步GET请求
// paraNameArr  : 参数名称数组
// paraValueArr : 参数值数组
+ (void)sendAsynGetRequestRelativeAdd:(NSString *)relativeAdd paraNameArr:(NSArray *)paraNameArr paraValueArr:(NSArray *)paraValueArr completeBlock:(void(^)(BOOL isSuccess,id jsonObj))block
{
    if (!relativeAdd || [relativeAdd isEqualToString:@""] || !paraNameArr || !paraValueArr || paraNameArr.count != paraValueArr.count) {
        block(NO,@"参数名与参数值数量不匹配");
        return ;
    }
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < paraNameArr.count; i++) {
        [paraDic setObject:paraValueArr[i] forKey:paraNameArr[i]];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //默认响应JSON
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[LLUtils customSecurityPolicy]];
    }
    else
    {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [manager GET:[HOST_ADDR stringByAppendingPathComponent:relativeAdd] parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"success!\nresponseString===>%@",str);
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(YES,jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed!\nerror===>%@",error);
        block(NO,error);
    }];
    return ;
}

//发送POST异步请求
// paraNameArr  : 参数名称数组
// paraValueArr : 参数值数组
+ (void)sendAsynPostRequestRelativeAdd:(NSString *)relativeAdd paraNameArr:(NSArray *)paraNameArr paraValueArr:(NSArray *)paraValueArr completeBlock:(void(^)(BOOL isSuccess,id jsonObj))block
{
    if (!relativeAdd || [relativeAdd isEqualToString:@""] || !paraNameArr || !paraValueArr || paraNameArr.count != paraValueArr.count) {
        block(NO,@"参数名与参数值数量不匹配");
        return ;
    }
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < paraNameArr.count; i++) {
        [paraDic setObject:paraValueArr[i] forKey:paraNameArr[i]];
    }
    NSLog(@"requestParaDic===>%@",paraDic);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //默认响应JSON
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[LLUtils customSecurityPolicy]];
    }
    else
    {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [manager POST:[HOST_ADDR stringByAppendingPathComponent:relativeAdd] parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"success!\nresponseString===>%@",str);
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(YES,jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed!\nerror===>%@",error);
        block(NO,error);
    }];
}

+ (void)postRequestWithRelativeAdd:(NSString *)relativeAdd paraDic:(NSDictionary *)paraDic completeBlock:(void(^)(BOOL isSuccess,id jsonObj))block
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //默认响应JSON
    NSString *pathStr = [HOST_ADDR stringByAppendingPathComponent:relativeAdd];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[LLUtils customSecurityPolicy]];
    }
    else
    {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [manager POST:pathStr parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSLog(@"success!\nresponseString===>%@",str);
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(YES,jsonObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        NSLog(@"failed!\nerror===>%@",error.localizedDescription);
        block(NO,error);
    }];
}

+ (void)UploadFileWithRelativeAdd:(NSString *)urlStr param:(NSDictionary *)dict serviceName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)data finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock
{
//    BOOL reachabilityFlag = [self reachable];
    
//    if (!reachabilityFlag) {
//        
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请检查网络连接状况" forKey:NSLocalizedDescriptionKey];
//        
//        NSError *aError = [NSError errorWithDomain:CustomErrorDomain code:HttpConnectFailed userInfo:userInfo];
//        
//        if (failedBlock) {
//            
//            failedBlock(aError);
//            
//        }
//        
//        return;
//    }
    
    if (isEmptyStr(urlStr)) {
        failedBlock(nil);
        return ;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];  // 此处设置content-Type生效
    //修改返回格式为二进制
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",@"image/.jpg",@"image/jpeg",nil];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[LLUtils customSecurityPolicy]];
    }
    else
    {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [manager POST:[HOST_ADDR stringByAppendingPathComponent:urlStr] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        if (finishBlock) {
            finishBlock(data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求失败" forKey:NSLocalizedDescriptionKey];
            
            NSError *aError = [NSError errorWithDomain:CustomErrorDomain code:HttpDefultFailed userInfo:userInfo];
            
            failedBlock(aError);
            
        }
    }];
    
}


+(void)UploadFileWithUrl:(NSString *)urlStr param:(NSDictionary *)dict serviceName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)data finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock
{
//    BOOL reachabilityFlag = [self reachable];
//    
//    if (!reachabilityFlag) {
//        
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请检查网络连接状况" forKey:NSLocalizedDescriptionKey];
//        
//        NSError *aError = [NSError errorWithDomain:CustomErrorDomain code:HttpConnectFailed userInfo:userInfo];
//        
//        if (failedBlock) {
//            
//            failedBlock(aError);
//            
//        }
//        
//        return;
//    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];  // 此处设置content-Type生效
    //修改返回格式为二进制
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",@"image/.jpg",@"image/jpeg",nil];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[LLUtils customSecurityPolicy]];
    }
    else
    {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        if (finishBlock) {
            finishBlock(data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求失败" forKey:NSLocalizedDescriptionKey];
            
            NSError *aError = [NSError errorWithDomain:CustomErrorDomain code:HttpDefultFailed userInfo:userInfo];
            
            failedBlock(aError);
            
        }
    }];
    
}


+(void)UploadFileWithUrl:(NSString *)urlStr param:(NSDictionary *)dict serviceNameArr:(NSArray *)nameArr fileNameArr:(NSArray *)fileNameArr mimeType:(NSString *)mimeType fileDataArr:(NSArray *)dataArr finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock
{
    //    BOOL reachabilityFlag = [self reachable];
    //
    //    if (!reachabilityFlag) {
    //
    //        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请检查网络连接状况" forKey:NSLocalizedDescriptionKey];
    //
    //        NSError *aError = [NSError errorWithDomain:CustomErrorDomain code:HttpConnectFailed userInfo:userInfo];
    //
    //        if (failedBlock) {
    //
    //            failedBlock(aError);
    //
    //        }
    //
    //        return;
    //    }
    
    if (fileNameArr.count != dataArr.count || nameArr.count != fileNameArr.count) {
        NSLog(@"fileNameArr,dataArr,nameArr数组个数不匹配，请检查传入参数!");
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];  // 此处设置content-Type生效
    //修改返回格式为二进制
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",@"image/.jpg",@"image/jpeg",nil];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[LLUtils customSecurityPolicy]];
    }
    else
    {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0 ; i < fileNameArr.count ; i++) {
            NSString *fileName = fileNameArr[i];
            NSData *data = dataArr[i];
            NSString *name = nameArr[i];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = (NSData *)responseObject;
        if (finishBlock) {
            finishBlock(data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"请求失败" forKey:NSLocalizedDescriptionKey];
            
            NSError *aError = [NSError errorWithDomain:CustomErrorDomain code:HttpDefultFailed userInfo:userInfo];
            
            failedBlock(aError);
            
        }
    }];
    
}

@end
