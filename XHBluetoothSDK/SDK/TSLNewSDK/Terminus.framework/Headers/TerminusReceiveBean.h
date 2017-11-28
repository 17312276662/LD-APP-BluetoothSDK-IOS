//
//  TerminusReceiveBean.h
//  TerminusDemo
//
//  Created by huangdroid on 15-1-30.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TerminusReceiveBean : NSObject
/**
 错误代码 @see BluetoothErrorCodes
 */
@property (nonatomic, assign)BluetoothErrorCodes errorCode;

/**
 错误提示
 */
@property (nonatomic, retain) NSString *errorMessage;

/**
 成功开锁耗时
 */
@property (nonatomic, assign) NSInteger openDoorTime NS_AVAILABLE_IOS(2_0);

/**
 数据实体  配对、开门返回为钥匙实体，获取所有用户返回为 TerminusKeyBean 实体集合
 */
@property (nonatomic,retain) id receiveBean;

@end
