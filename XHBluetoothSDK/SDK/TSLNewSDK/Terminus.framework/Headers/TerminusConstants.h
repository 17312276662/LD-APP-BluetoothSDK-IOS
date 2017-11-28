//
//  TerminusConstants.h
//  TerminusDemo
//
//  Created by huangdroid on 15-1-29.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#ifndef TerminusDemo_TerminusConstants_h
#define TerminusDemo_TerminusConstants_h

#define TERMINUSDB [TSLKeysDataBaseUtils sharedInstance]

#define TSLAESUtil [TSLAESUtil8 sharedInstance]

#define TERMINUSSHARE self

#undef	NSLogTD
#undef	NSLogTDD
#undef	NSLogTBD
#define NSLogTD(fmt, ...) if ([TerminusBleCommunicationManager isDebugMode]) {NSLog((@"%s [Line %d] DEBUG: \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#define NSLogTDD if ([TerminusBleCommunicationManager isDebugMode]) {NSLogTD(@"%@", @""); }
#define NSLogTDSelf if ([TerminusBleCommunicationManager isDebugMode]) {NSLogTDD(@"Class: %@", NSStringFromClass([self class]));}
#define NSLogTBD(fmt, ...) if ([TerminusBleCommunicationManager isBlueToothLogEnabled]) {NSLog((@"%s [Line %d] DEBUG: \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}

/**
 蓝牙钥匙门锁类型

 - BlueDeviceTypeMen: 家庭门锁类型
 - BlueDeviceTypeEbike: 电动车
 - BlueDeviceTypeMoto: 摩托车
 - BlueDeviceTypeCar: 汽车
 - BlueDeviceTypeStrongBox: 保险柜
 - BlueDeviceTypeCompanyEntrance: 公司门禁
 - BlueDeviceTypeVillageEntrance: 小区门禁
 - BlueDeviceTypeGongZu: 公租房管理员
 - BlueDeviceTypeTalkBack: 对讲门禁
 - BlueDeviceTypeGate: 道闸
 - BlueDeviceTypeLandKey: 地锁
 - BlueDeviceTypeTK1: 梯控
 - BlueDeviceTypeTK2: 梯控
 - BlueDeviceTypeHotelKey: 酒店
 - BlueDeviceTypeRemoteMen: 门闸
 - BlueDeviceTypeRemoteVillage: 小区门禁
 - BlueDeviceTypeRemoteLoudong: 楼栋门禁
 - BlueDeviceTypeRemoteCar: 车库
 - BlueDeviceTypeRemoteTK1: 梯控内
 - BlueDeviceTypeRemoteTK2: 梯控外
 - BlueDeviceTypeRemoteCommpany: 公司锁
 - BlueDeviceTypeRemoteOther: 其他
 */
typedef NS_ENUM(int, BlueDeviceType){
    BlueDeviceTypeMen             = 0,//家庭门锁类型
    BlueDeviceTypeEbike           = 1,//电动车
    BlueDeviceTypeMoto            = 2,//摩托车
    BlueDeviceTypeCar             = 3,//汽车
    BlueDeviceTypeStrongBox       = 4,//保险柜
    BlueDeviceTypeCompanyEntrance = 5,//公司门禁
    BlueDeviceTypeVillageEntrance = 6,//小区门禁
    BlueDeviceTypeGongZu          = 7,//公租房管理员
    BlueDeviceTypeTalkBack        = 8,//对讲门禁
    BlueDeviceTypeGate            = 9,//道闸
    BlueDeviceTypeLandKey         = 10,//地锁
    BlueDeviceTypeTK1             = 11,//梯控
    BlueDeviceTypeTK2             = 12,//梯控
    BlueDeviceTypeHotelKey        = 13,//酒店
    BlueDeviceTypeRemoteMen       = 95,//门闸
    BlueDeviceTypeRemoteVillage   = 96,//小区门禁
    BlueDeviceTypeRemoteLoudong   = 97,//楼栋门禁
    BlueDeviceTypeRemoteCar       = 98,//车库
    BlueDeviceTypeRemoteTK1         = 99,//梯控内
    BlueDeviceTypeRemoteTK2         = 100,//梯控外
    BlueDeviceTypeRemoteCommpany    = 101,//公司锁
    BlueDeviceTypeRemoteOther       = 200 //其他
    
};


/**
 授权类型

 - KeyAuthShareLocal: 本地钥匙
 - KeyAuthSharePermanent: 本地永久分享
 - KeyAuthShareTemp: 本地临时分享钥匙
 - KeyAuthShareRemoteTemp: 公共钥匙-临时分享
 - KeyAuthShareRemotePermanent: 公共钥匙-永久分享
 - KeyAuthShareRemoteDefault: 公共钥匙-永久分享
 */
typedef NS_ENUM(int,KeyAuthType){
    KeyAuthShareLocal = 1, //本地钥匙
    KeyAuthSharePermanent = 2, //本地永久分享
    KeyAuthShareTemp = 4, //本地临时分享钥匙
    KeyAuthShareRemoteTemp = 5, //公共钥匙-临时分享
    KeyAuthShareRemotePermanent = 3, //公共钥匙-永久分享
    KeyAuthShareRemoteDefault = 6 //公共钥匙-永久分享
};


/**
 蓝牙钥匙操作集合
 
 - BluetoothOperationDefault: 默认,
 - BluetoothOperationHandle: 我发送给蓝牙的握手
 - BluetoothOperationHandleToPhone: 底层发给我的握手
 - BluetoothOperationHandleOpenDoor: 最终开门的握手结束
 - BluetoothOperationUpdateSecret: 修改密码
 - BluetoothOperationOpenRecode: 开门记录
 - BluetoothOperationPierUpdateOpenDoor: 开门
 - BluetoothOperationGarateStatus: 获取地锁状态
 - BluetoothOperationGarateClose: 关闭地锁连接
 - BluetoothOperationPierUpdatePWD: 配对是否修改密码 修改密码
 - BluetoothOperationPierUnupdatePWD: 配对是否修改密码 不修改密码
 - BluetoothOperationGetAllUser: 获取所有用户
 - BluetoothOperationCompleteUserInfor: 完善用户信息--门禁
 - BluetoothOperationDeleteOneUser: 删除单个用户
 - BluetoothOperationDeleteAllUser: 删除所有用户
 - BluetoothOperationDisableOneUser: 禁用单个用户
 - BluetoothOperationEnableOneUser: 启用单个用户
 - BluetoothOperationAgingTest: 老化测试
 - BluetoothOperationGetDeviceInfo: 获取设备信息
 - BluetoothOperationLockReset: 恢复出厂设置
 - BluetoothOperationUserSecret: 设置门禁开门密码
 - BluetoothOperationSecretChiperOpenDoor: 密文
 - BluetoothOperationStart433Pair: 开始组网配对 NSNumber, 0 表示新设备，1是已有设备
 - BluetoothOperationGetNFCInfo: 获取NFC信息
 - BluetoothOperationResetNFC: 初始化nfc
 - BluetoothOperationConfigNFC: 配置门禁
 - BluetoothOperationStartUpgradeFirmware: 开始双模固件升级
 - BluetoothOperationPostUpgradeFirmware: 发送固件分包
 - BluetoothOperationSetKeyChainPwd: 设置钥匙扣密码
 - BluetoothOperationKeyChainDelete: 初始化钥匙扣
 - BluetoothOperationGetWiFiSetting: 获取WiFi信息
 - BluetoothOperationSetWiFi = 48: wifi设置
 */
typedef NS_ENUM(int, BluetoothOperation) {
    BluetoothOperationDefault              = 1,
    BluetoothOperationHandle              = 17,   //我发送给蓝牙的握手
    BluetoothOperationHandleToPhone       = 18,   //底层发给我的握手
    BluetoothOperationHandleOpenDoor      = 19, //最终开门的握手结束
    BluetoothOperationUpdateSecret        = 1, //修改密码
    BluetoothOperationOpenRecode          = 3,    //开门记录
    BluetoothOperationPierUpdateOpenDoor  = 5,    // 开门
    BluetoothOperationGarateStatus        = 7, //获取地锁状态
    BluetoothOperationGarateClose         = 12, //关闭地锁连接
    BluetoothOperationPierUpdatePWD       = 8, //配对是否修改密码 修改密码
    BluetoothOperationPierUnupdatePWD     = 9,//配对是否修改密码 不修改密码
    BluetoothOperationGetAllUser          = 27, //获取所有用户
    BluetoothOperationCompleteUserInfor   = 26, //完善用户信息--门禁
    BluetoothOperationDeleteOneUser       = 28, //删除单个用户
    BluetoothOperationDeleteAllUser       = 29,//删除所有用户
    BluetoothOperationDisableOneUser      = 20, //禁用单个用户
    BluetoothOperationEnableOneUser       = 21, //启用单个用户
    BluetoothOperationAgingTest           = 87,   // 老化测试
    BluetoothOperationGetDeviceInfo       = 88, //获取设备信息
    BluetoothOperationLockReset           = 89, //恢复出厂设置
    BluetoothOperationUserSecret          = 22,//设置门禁开门密码
    BluetoothOperationSecretChiperOpenDoor = 23,
    BluetoothOperationStart433Pair = 42,//开始组网配对 NSNumber, 0 表示新设备，1是已有设备
    BluetoothOperationGetNFCInfo = 43, // 获取NFC信息
    BluetoothOperationResetNFC = 44,  // 初始化nfc
    BluetoothOperationConfigNFC = 49, // 配置门禁
    BluetoothOperationStartUpgradeFirmware = 97, // 开始双模固件升级
    BluetoothOperationPostUpgradeFirmware = 1000, // 发送固件分包
    BluetoothOperationSetKeyChainPwd = 45,//设置钥匙扣密码
    BluetoothOperationKeyChainDelete = 46, //初始化钥匙扣
    BluetoothOperationGetWiFiSetting = 47, //获取WiFi信息
    BluetoothOperationSetWiFi = 48
};


/**
 蓝牙钥匙电量常量

 - DevicePowerLevelHight: --高
 - DevicePowerLevelMedium: --中等
 - DevicePowerLevelLow: --较低
 - DevicePowerLevelVeryLow: --低
 */
typedef NS_ENUM(int,DevicePowerLevels){
    DevicePowerLevelHight       = 1,//--高
    DevicePowerLevelMedium      = 3,//--中等
    DevicePowerLevelLow         = 5,//--较低
    DevicePowerLevelVeryLow     = 9,//--低
};


/**
 蓝牙错误信息
 - BluetoothConnectSuccess: 连接成功
 - BluetoothConnectFail: 连接失败
 - BluetoothOperationSuccess: 操作成功
 - BluetoothOperationFail: 操作失败
 - BluetoothReceiveError: 接收数据异常
 - BluetoothDataError: 数据错误
 - BluetoothDisable: 禁用
 - BluetoothResolveError: 解析失败
 - BluetoothSignalFailS: 密码被修改
 - BluetoothSignalFailA: 钥匙被清除
 - BluetoothSignalFailM: 室内已反锁
 - BluetoothSignalFailD: 钥匙被禁用
 - BluetoothSignalFailUserFull: 配对已满
 - BluetoothSignalFailALL:  6001
 - BluetoothSignalFailFailk: 未按设置键

 - BluetoothCancelSendData: 7003
 - BluetoothSendDataError: 传入数据错误
 - BluetoothSendDataOrdinary: 数据发送太频繁
 - BluetoothConcat: 数据组装失败
 - BluetoothConcatSendDataError: 最终组装蓝牙数据失败
 - BluetoothNotOpen: 蓝牙未打开
 - BluetoothDisConnect: 蓝牙失去连接
 - BluetoothNotservices: 未发现链接蓝牙的服务
 - BluetoothNoConnectCBPeripheral: 当前没有链接的蓝牙对象
 - BluetoothNoCharacteristic: 当前链接蓝牙不支持
 - BluetoothWiteDataError: 外围设备写书数据出错 error有描述
 - BluetoothNotifyValueCharateristicError: 订阅的特征值请求出错 error有描述
 - BluetoothNoSearchBlue: 设备未找到
 */
typedef NS_ENUM(int, BluetoothErrorCodes){
    //硬件返回的错误码
    BluetoothConnectSuccess     = 1,//连接成功
    BluetoothConnectFail        = 2,//连接失败
    BluetoothOperationSuccess   = 251,//操作成功
    BluetoothOperationFail      = 252,//操作失败
    BluetoothReceiveError       = 253,//接收数据异常
    BluetoothDataError          = 255,//数据错误
    BluetoothDisable            = 256,//禁用
    BluetoothResolveError       = 11, //解析失败
    BluetoothSignalFailS        = 5001,//密码被修改
    BluetoothSignalFailA        = 5002,//钥匙被清除
    BluetoothSignalFailM        = 5003,//室内已反锁
    BluetoothSignalFailD        = 5004,//钥匙被禁用
    BluetoothSignalFailUserFull = 5005,//配对已满
    BluetoothSignalFailALL      = 6001,//
    BluetoothSignalFailFailk    = 6002,//未按设置键
    BluetoothSignalFailX        = 5006,// 非管理员操作
    
    
    
    
    //本地蓝牙错误代码
    BluetoothCancelSendData = 7003,
    BluetoothSendDataError         = 6003, //传入数据错误
    BluetoothSendDataOrdinary      = 6004, //数据发送太频繁
    BluetoothConcat                = 6005, //数据组装失败
    BluetoothConcatSendDataError   = 6006, //最终组装蓝牙数据失败
    BluetoothNotOpen               = 7001, //蓝牙未打开
    BluetoothDisConnect            = 7002, //蓝牙失去连接
    BluetoothNotservices           = 8000, //未发现链接蓝牙的服务
    BluetoothNoConnectCBPeripheral = 8001, //当前没有链接的蓝牙对象
    BluetoothNoCharacteristic      = 8003, //当前链接蓝牙不支持
    BluetoothWiteDataError         = 8004,//外围设备写书数据出错 error有描述
    BluetoothNotifyValueCharateristicError = 8005, //订阅的特征值请求出错 error有描述
    BluetoothNoSearchBlue = 8006,  //设备未找到
    // 暂时不支持该功能
    BluetoothFunctionTempUnsupport = 3010

    
};


typedef NS_ENUM(int,BluetoothOPErrorCode) {
    BluetoothOPTotalFail = -2, // 总操作失败
    BluetoothOPSingleFail = -1, // 单次操作失败
    BluetoothOPSingleSuccess = 0, // 单次操作成功
    BluetoothOPTotalSuccess = 1,  // 总操作成功
};

extern NSString * const OPERATION_SUCCESS_MESSAGE;  // 单次操作成功
extern NSString * const OPERATION_TOTAL_SUCCESS_MESSAGE;  // 总操作成功
extern NSString * const OPERATION_FAIL_MESSAGE;  // 单次操作失败
extern NSString * const OPERATION_TOTAL_FAIL_MESSAGE;  // 总操作失败

#endif
