//
//  TerminusReceiveBean.h
//  TerminusDemo
//
//  Created by huangdroid on 15-1-30.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TerminusReceiveBean : NSObject
/*!
 @property
 @brief   错误代码 @see BluetoothErrorCodes
 */
@property (nonatomic, assign)BluetoothErrorCodes errorCode;
/*!
 @property
 @brief   错误提示
 */
@property (nonatomic, retain) NSString *errorMessage;
/*!
 @property
 @brief   开门所用事件
 */
@property (nonatomic, assign) NSInteger openDoorTime NS_AVAILABLE_IOS(2_0);

/*!
 *  数据实体  配对、开门返回为钥匙实体，获取所有用户返回为 TerminusEntranceKeyUserBean 实体集合
 *
 */
@property (nonatomic,retain) id receiveBean;

@end
