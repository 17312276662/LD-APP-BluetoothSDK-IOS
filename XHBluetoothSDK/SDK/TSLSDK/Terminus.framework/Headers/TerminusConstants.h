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




/*!
 *  蓝牙钥匙门锁类型
 */
typedef enum {
    BlueDeviceTypeMen             = 0,//家庭门锁类型
    BlueDeviceTypeEbike           = 1,//电动车
    BlueDeviceTypeMoto            = 2,//摩托车
    BlueDeviceTypeCar             = 3,//汽车
    BlueDeviceTypeStrongBox       = 4,//保险柜
    BlueDeviceTypeCompanyEntrance = 5,//公司门禁
    BlueDeviceTypeVillageEntrance = 6,//小区门禁
    BlueDeviceTypeGongZu          = 7,//公租房管理员
    BlueDeviceTypeGate            = 9,//道闸
    BlueDeviceTypeLandKey         = 10,//地锁
    BlueDeviceTypeHotelKey        = 13,//酒店
    BlueDeviceTypeRemoteMen       = 95,//门闸
    BlueDeviceTypeRemoteVillage   = 96,//小区门禁
    BlueDeviceTypeRemoteLoudong   = 97,//楼栋门禁
    BlueDeviceTypeRemoteCar       = 98,//车库
    BlueDeviceTypeRemoteOther     = 99,//99-其他
    
}BlueDeviceType;
/*!
 *  蓝牙钥匙操作集合
 */
typedef NS_ENUM(int, BluetoothOperation) {
    BluetoothOperationDefault              = 1,
    BluetoothOperationHandle              = 17,   //我发送给蓝牙的握手
    BluetoothOperationHandleToPhone       = 18,   //底层发给我的握手
    /*
     最终开门的握手结束
     eg: data  @{
     TerminusKeyUid:xxx,
     TerminusKeyUserPhone:xxx, //可选参数
     }
     */
    BluetoothOperationHandleOpenDoor      = 19,
    /** 修改密码
     data      @{
     TerminusKeyUid:xxx,
     TerminusKeyPiaringPwd:xxx,//旧密码
     TerminusKeyPiaringNewPwd:xxx, //新密码
     }
     */
    BluetoothOperationUpdateSecret        = 1,
    /** 开门记录
     @{
     TerminusKeyUid:xxx
     }
     */
    BluetoothOperationOpenRecode          = 3,
    BluetoothOperationPierUpdateOpenDoor  = 5,    // 开门
    
    /** 获取地锁状态
     @{TerminusKeyUid:xxx}
     */
    BluetoothOperationGarateStatus        = 7,
    /** 关闭地锁连接
     @{TerminusKeyUid:xxx}
     */
    BluetoothOperationGarateClose         = 12,
    /*配对是否修改密码 修改密码*/
    BluetoothOperationPierUpdatePWD       = 8,
    /*配对是否修改密码 不修改密码
     eg: data @{
     TerminusKeyMacAddress:xxx,
     TerminusKeyPiaringPwd:xxx,
     TerminusKeyPiaringKeyName:xxx, //锁名称
     TerminusKeyPiaringNewPwd:xxx, //可选参数
     TerminusKeyPiaringIsAdmin:xxx,//可选参数 默认是非管理员 @YES or @NO
     }
     */
    BluetoothOperationPierUnupdatePWD     = 9,
    
    /** 获取所有用户
     @{TerminusKeyUid:xxx}
     */
    BluetoothOperationGetAllUser          = 27,
    /** 完善用户信息--门禁
     @{
     TerminusKeyUserConnectType:xxx,
     TerminusKeyUserName:xxx,
     TerminusKeyUserHouseInfor:xxx,
     TerminusKeyUid:xxx,
     }
     */
    BluetoothOperationCompleteUserInfor   = 26,
    /**删除单个用户
     @{TerminusKeyUid:xxx,TerminusKeyIndexString:xxx}
     */
    BluetoothOperationDeleteOneUser       = 28,
    /** 删除所有
     @{TerminusKeyUid:xxx}
     */
    BluetoothOperationDeleteAllUser       = 29,
    /**
     禁用单个用户
     @{TerminusKeyUid:xxx,TerminusKeyIndexString:xxx}
     */
    BluetoothOperationDisableOneUser      = 20,
    /** 启用单个用户
     @{TerminusKeyUid:xxx,TerminusKeyIndexString:xxx}
     */
    BluetoothOperationEnableOneUser       = 21,
    BluetoothOperationAgingTest           = 87,   // 老化测试
    /** 获取设备信息
     @{ChipId:NSString,WxMac:NSString}
     */
    BluetoothOperationGetDeviceInfo       = 88,
    /** 恢复出厂设置
     @{TerminusKeyUid:xxx,TerminusKeyPiaringPwd:xxx}
     */
    BluetoothOperationLockReset           = 89,
    BluetoothOperationManageEnable        = 13,   //公租房管理员启用
    BluetoothOperationMangeDisable        = 14,   //公租房管理员禁用
    BluetoothOperationMangeSecret         = 15,   //公租房管理员修改密码
    /** 设置门禁开门密码
     @{TerminusKeyUid:xxx,TerminusKeyPiaringPwd:xxx,TerminusKeyOpenDoorNewPwd:xxx}
     */
    BluetoothOperationUserSecret          = 22,
    BluetoothOperationSecretChiperOpenDoor = 23,
    /** 获取NFC信息
     @{InstallType:NSString,NFCMode:NSString,OpenDelay:NSNumber,
     VillageId:NSString, BuildingId:NSString, HouseId:NSString}
     */
    BluetoothOperationGetNFCInfo = 43,
    BluetoothOperationResetNFC = 44,  // 初始化nfc
    BluetoothOperationStartUpgradeFirmware = 97, // 开始双模固件升级
    BluetoothOperationPostUpgradeFirmware = 1000 // 发送固件分包
};


/*!
 *  蓝牙钥匙电量常量
 */
typedef NS_ENUM(int,DevicePowerLevels){
    DevicePowerLevelHight       = 1,//--高
    DevicePowerLevelMedium      = 3,//--中等
    DevicePowerLevelLow         = 5,//--较低
    DevicePowerLevelVeryLow     = 9,//--低
};

/*!
 *  蓝牙钥匙电量常量
 */
typedef enum {
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
 
    
}BluetoothErrorCodes;

typedef NS_ENUM(int,TSLLockTypes){
    SUPPORT_F_600KJ     = 101,  // 600J单键机械按钮
    SUPPORT_F_600K_D    = 102,  // 600D单键触摸按钮
    SUPPORT_F_600K_MX   = 103,  // 600X12触摸键盘带锁芯
    SUPPORT_F_600K_M    = 104,  // 600M 12触摸键盘不带锁芯
    SUPPORT_F_600K_S    = 105,  // 600S 12触摸键盘双系统
    SUPPORT_F_600K_P    = 106,  // 600P 12触摸键盘
    SUPPORT_F_600K_H    = 107,  // 600H 单键机械按钮+触摸按钮
    SUPPORT_F_828K      = 110,  // 828K 12触摸键盘
    SUPPORT_F_826K      = 111,  // 826K 12触摸键盘
    SUPPORT_F_8004      = 112,  // 8004 12触摸键盘
    SUPPORT_F_829K      = 113,  // 829K 12触摸键盘门后2个触摸
    SUPPORT_F_830K      = 114,  // 830K 12触摸键盘
    SUPPORT_F_822K      = 115,  // 822K 12触摸键盘
    SUPPORT_F_835K      = 116,  // 835K 12触摸键盘
    SUPPORT_F_833K      = 117,  // 833K 12触摸键盘
    SUPPORT_F_MJ        = 201,  // MJ_2 小区门禁
    SUPPORT_F_MJ_1      = 202,  // MJ_1 公司门禁
    SUPPORT_F_MZ        = 211,  // MZ_1 公司门砸
    SUPPORT_F_MC        = 203,  // MC36 小区门禁
    SUPPORT_F_MA_MC     = 204,  // MAMC 小区门禁
    SUPPORT_F_MB        = 205,  // MB_1 小区门禁
    SUPPORT_F_622       = 301,  // 622_ 奥铂（宽）
    SUPPORT_F_625       = 302,  // 625_ 奥铂（铜面板）
    SUPPORT_F_626       = 303,  // 626_ 奥铂（窄）
    SUPPORT_F_633       = 401,  // 633_ 保佳安
    SUPPORT_F_632       = 402,  // 632_ 保佳安带下拉手
    SUPPORT_F_617       = 501,  // 617_ 创佳
    SUPPORT_F_DS        = 801,  // 地锁
};

typedef enum {
    BluetoothOPTotalFail = -2, // 总操作失败
    BluetoothOPSingleFail = -1, // 单次操作失败
    BluetoothOPSingleSuccess = 0, // 单次操作成功
    BluetoothOPTotalSuccess = 1,  // 总操作成功
}BluetoothOPErrorCode;

extern NSString * const OPERATION_SUCCESS_MESSAGE;  // 单次操作成功
extern NSString * const OPERATION_TOTAL_SUCCESS_MESSAGE;  // 总操作成功
extern NSString * const OPERATION_FAIL_MESSAGE;  // 单次操作失败
extern NSString * const OPERATION_TOTAL_FAIL_MESSAGE;  // 总操作失败

#endif
