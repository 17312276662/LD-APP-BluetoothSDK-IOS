//
//  HttpSessionManager.h
//  Terminus
//
//  Created by tom on 6/29/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    //请求正常，无错误
    TslHttpErrorTypeNull=0,
    
    //请求时出错，可能是URL不正确
    TslHttpErrorTypeURLConnectionError,
    
    //请求时出错，服务器未返回正常的状态码：200
    TslHttpErrorTypeStatusCodeError,
    
    //请求回的Data在解析前就是nil，导致请求无效，无法后续JSON反序列化。
    TslHttpErrorTypeDataNilError,
    
    //data在JSON反序列化时出错
    TslHttpErrorTypeDataSerializationError,
    
    //无网络连接
    TslHttpErrorTypeNoNetWork,
    
    //服务器请求成功，但抛出错误
    TslHttpErrorTypeServiceRetrunErrorStatus,
    
    /**
     *  以下是文件上传中的错误类型
     */
    TslHttpErrorTypeUploadDataNil,                                                                     //什么都没有上传
    
    
}TslHttpErrorType;                                                                                     //错误类型定义


typedef void(^SuccessBlock)(id obj);

typedef void(^ErrorBlock)(TslHttpErrorType errorType, NSString *errorMsg);





@interface HttpSessionManager : NSObject

+ (void)enableDebugMode;

/**
 *  GET:
 *  params中可指明参数类型
 */
+(NSURLSessionDataTask *)getUrl:(NSString *)urlString params:(id)params success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock;


/**
 *  POST:
 */
+(NSURLSessionDataTask *)postUrl:(NSString *)urlString params:(id)params success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock;



/**
 *  文件上传 (待完善)
 *  @params: 普通参数
 *
 */
+(void)uploadUrl:(NSString *)uploadUrl params:(id)params files:(NSArray *)files success:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock delegate:(id<NSURLSessionDelegate>)delegate;

@end
