//
//  HttpSessionBaseManager.h
//  Terminus
//
//  Created by tom on 11/16/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <CommonCrypto/CommonDigest.h>

typedef NS_ENUM(int,TSLHttpErrorType) {
    
    //请求正常，无错误
    TSLHttpErrorTypeNull=0,
    
    //请求时出错，可能是URL不正确
    TSLHttpErrorTypeURLConnectionError,
    
    //请求时出错，服务器未返回正常的状态码：200
    TSLHttpErrorTypeStatusCodeError,
    
    //请求回的Data在解析前就是nil，导致请求无效，无法后续JSON反序列化。
    TSLHttpErrorTypeDataNilError,
    
    //data在JSON反序列化时出错
    TSLHttpErrorTypeDataSerializationError,
    
    //无网络连接
    TSLHttpErrorTypeNoNetWork,
    
    //服务器请求成功，但抛出错误
    TSLHttpErrorTypeServiceRetrunErrorStatus,
    
    /**
     *  以下是文件上传中的错误类型
     */
    TSLHttpErrorTypeUploadDataNil,                                                                     //什么都没有上传
    
    
};                                                                                     //错误类型定义


typedef void(^TSLSuccessBlock)(id obj);


typedef void(^TSLErrorBlock)(TSLHttpErrorType errorType, NSString *errorMsg);


@interface HttpSessionBaseManager : NSObject

+ (void)enableDebugMode;


+(BOOL)requestBeforeCheckNetWorkWithErrorBlock:(TSLErrorBlock)errorBlock;

/**
 *  GET:
 *  params中可指明参数类型
 */
+(NSURLSessionDataTask *)getUrl:(NSString *)urlString params:(id)params success:(TSLSuccessBlock)successBlock errorBlock:(TSLErrorBlock)errorBlock;


/**
 *  POST:
 */
+(NSURLSessionDataTask *)postUrl:(NSString *)urlString params:(id)params success:(TSLSuccessBlock)successBlock errorBlock:(TSLErrorBlock)errorBlock;


/**
 文件上传 (待完善)

 @param uploadUrl 地址
 @param params 参数
 @param files 文件
 @param successBlock 成功回调
 @param errorBlock 失败回调
 @param delegate 代理
 */
+(void)uploadUrl:(NSString *)uploadUrl params:(id)params files:(NSArray *)files success:(TSLSuccessBlock)successBlock errorBlock:(TSLErrorBlock)errorBlock delegate:(id<NSURLSessionDelegate>)delegate;
//签名算法
+(NSDictionary *) getCommonParamsSign:(NSDictionary *) dict;

+(NSString *)getBaseURL;

+(NSString *)getDeviceType;

@end
