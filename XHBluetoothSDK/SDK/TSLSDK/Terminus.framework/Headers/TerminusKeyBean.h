//
//  TerminusKeyBean.h
//  TerminusDemo
//
//  Created by huangdroid on 15-1-29.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TerminusKeyBean : NSObject

/*!
 @property
 @brief   蓝牙唯一标示   32位
 */
@property (copy, nonatomic)NSString *keyUid;
/*!
 @property
 @brief   锁的别名
 */
@property (copy, nonatomic)NSString *keyName;

/*!
 @property
 @brief   锁授权id
 */
@property (nonatomic,copy) NSString *empowerId;

/*!
 @property
 @brief   锁id
 */
@property (nonatomic,copy) NSString *chipId;

/*!
 @property
 @brief   标示该用户配对了，是否是管理员类型
 */
@property (nonatomic ,copy) NSString *isAdmin;

/*!
 @property
 @brief   该用户蓝牙模块地址
 */
@property (nonatomic,copy) NSString *macAddress;

/*!
 @property
 @brief   用户在底层地址
 */
@property (nonatomic,copy) NSString *keyPwd;

/*!
 @property
 @brief   用户在底层地址
 */
@property (nonatomic,assign) DevicePowerLevels keyBatV;

/*!
 @property
 @brief   用户当前授权了多少次
 */
@property (nonatomic,copy) NSString *authorizationTimes;

/*!
 @property
 @brief   锁底层被授权了多少次 10 － （authorizationTimes - lockAuthorizationTimes）＝ 剩余授权次数
 */
@property (nonatomic,copy) NSString *lockAuthorizationTimes;

/*!
 @property
 @brief   锁类别 默认为门锁类型
 */
@property (nonatomic,assign) BlueDeviceType keyCate;

/*!
 @property
 @brief   开门方式
 */
@property (nonatomic,copy) NSString *OpenTypeMode;

/*!
 @property
 @brief   index
 */
@property (nonatomic,copy) NSString *IndexString;


/*!
 @property
 @brief 门锁类型编号
 */
@property (nonatomic,copy) NSString *identifier;

@end
