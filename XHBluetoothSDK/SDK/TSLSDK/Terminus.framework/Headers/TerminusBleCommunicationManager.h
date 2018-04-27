//
//  TerminusBleCommunicationManager.h
//  TerminusDemo
//
//  Created by huangdroid on 15-1-30.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TerminusConstants.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "FMDatabaseQueue.h"
#import <CoreLocation/CoreLocation.h>

@protocol TerminusBleDelegate <NSObject>

@required
/*!
 *  返回操作结果
 *
 *  @param data 返回的结果 结果实体 @see TerminusReceiveBean
 */
- (void) didReceiveData:(id)data;


/*!
 *  蓝牙数据错误 （不包括蓝牙通讯返回数据错误，主要是SDK中处理数据失败）
 *
 *  @param code 错误代码 @see BluetoothErrorCodes
 *  @param operation 操作代码 @see BluetoothOperation
 *  @param error 错误 error不为空时候 代表系统操作失败
 */
- (void) didBluetoothReaceivedErrorCode:(BluetoothErrorCodes)code operation:(BluetoothOperation)operation error:(NSError *)error;

///*!
// *  返回操作结果 当前返回结果只返回蓝牙操作成功结果 移除失败以前包含的失败结果
// *
// *  @param data 返回的结果 结果实体 @see TerminusReceiveBean
// */
//- (void) didReceiveData:(id)data blueOperation:(BluetoothOperation)operation;
@optional
/*!
*  设备断开连接
*
*  @param peripheral        蓝牙设备
*/
- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral;

/*!
 *  返回搜索到的设备
 *
 *  @param peripheral        蓝牙设备
 *  @param advertisementData 设备特征
 *  @param RSSI              信号强度
 */
- (void) didFoundBleDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
/**
 *  数据错误回调 主要用于调试
 *
 *  @param msg       错误信息
 *  @param operation 操作的ID
 */
- (void) didDataError:(NSString *)msg operation:(BluetoothOperation)operation;

/**
 * 日志上传后返回数据
 */
- (void) didUploadOpenLog:(id)data;

@end

@interface TerminusBleCommunicationManager : NSObject

@property(nonatomic, weak) id<TerminusBleDelegate> TBLEDelegate;
//当前操作蓝牙对象的 芯片ID （远程钥匙为后台传的Id）
@property(nonatomic, readonly, copy) NSString * currentLockCode;
//当前操作蓝牙对象的 钥匙类型 (远程钥匙为后台传送的类型 >= 95)
@property(nonatomic, readonly, assign) NSInteger currentKeyCate;
//操作ID
@property(nonatomic,readonly, assign) BluetoothOperation    controlID;
//是否远程钥匙
@property(nonatomic,readonly, assign) BOOL                  isRemote;
//设备ID
@property(nonatomic,readonly,copy) NSString * EquipmentID;
@property (nonatomic,readonly, copy) NSString * registerKey;
/**
 *  当前开锁对象的 mac地址
 */
@property (nonatomic,readonly, copy) NSString        *address;
@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) CBCentralManager *centralManager;

@property (nonatomic,readonly,copy) NSNumber * currentKeyRSSI;
+ (void)enableDebugMode;
+ (BOOL)isDebugMode;

+ (void)enableBlueToothLog;
+ (BOOL)isBlueToothLogEnabled;
// 设置 key值  无key 无法使用
+ (void)registerTslSamrt:(NSString *)key appId:(NSString *)appId;

+ (void)configAppInfo:(NSString *)channelId appType:(NSString *)appType;
+ (NSString *)channelId;
+ (NSString *)applicationType;

/*!
 *   操作蓝牙的单例
 *
 *  @return 返回蓝牙对象
 */
+ (TerminusBleCommunicationManager *) shareManagerInstance;
/*!
 *   设置数据库密匙
 *
 */

/*!
 *   操作ID
 */
+ (BOOL)BlueOpen;

/*!
 *   获取特斯联SDK 版本
 *
 *  @return 返回SDK版本
 */

+ (NSString *)getAPIVersion;


/*!
 *  搜索的方法，传人远程钥匙mac集合
 *
 *  fuctions of scan
 *
 *  @param remoteKeys
 */
-(void) startScanDevice:(NSMutableArray *) remoteKeys;

/*!
 *  停止蓝牙搜索的方法
 *
 * stop  bluetooth scan
 *
 */
-(void) stopScanDevice;


/*!
 *  设置配对需要的参数
 *
 *  @param pierPwd  配对密码
 *  @param newPwd   新密码
 *  @param isAdmin  是否是管理员
 *  @param userName 钥匙名称
 */
-(void) setPierWithPierPwd:(NSString *) pierPwd
                    NewPwd:(NSString *) newPwd
                   IsAdmin:(BOOL) isAdmin
                  UserName:(NSString *) userName;



/*!
 *  通过远程密文开门的方法
 *
 *  @param tempCipher 开门密文
 */
- (void) StartCommonCommunicationWithCipher:(NSString *) tempCipher PhoneNum:(NSString *) phoneNum LockCode:(NSString *)aCode KeyCate:(NSInteger)aCate;





/*!
 *  所有与蓝牙通信的方法
 *  fuctions of communication
 *  @param mSendData  发送的数据
 *  @param mAddress   蓝牙模块的名称
 *  @param mCurUid    主键ID
 *  @param mControlID 操作ID  @see BluetoothOperation
 */
- (void) StartCommonCommunication:(NSString *) mSendData
                       MacAddress:(NSString *) mAddress
                             UUID:(NSString *) mCurUid
                        ControlID:(BluetoothOperation) mControlID
                         LockCode:(NSString *)aCode
                          KeyCate:(NSInteger)aCate;





/*!
 *   所有公租房的操作
 *
 *  @param mSendData  发送的数据
 *  @param mAddress   mac地址
 *  @param mControlID 操作ID    @see BluetoothOperation
 */
- (void) StartCommonCommunicationByPrh:(NSString *) mSendData
                            MacAddress:(NSString *) mAddress
                             ControlID:(BluetoothOperation) mControlID NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用新方法 TSL_StartCommonCommunicationByPrh:MacAddress:ControlID 开门失败后只回调给 didBluetoothReaceivedErrorCode:operation:error:");


/*!
 *  关闭蓝牙链接
 */
-(void) CloseBleConnect;

- (void)cancelOpenKey;
/*!
 *  清除BLE蓝牙连接缓冲
 *  app进入后台时调用 防止缓冲数据错误导致开门失败
 */
-(void) ClearBleConnectCache;

/*!
 *  获取mac地址对应的设备
 */
- (CBPeripheral *)peripheralForMac:(NSString*)mac;

- (NSString *)scanNameForMac:(NSString*)mac;

- (BOOL)isBLEDevice:(NSString*)mac;

@end






@interface TerminusBleCommunicationManager (expansion)
/**
 *  地锁操作需要2部操作
 *
 *  @param chiper        密文
 *  @param blueOperation 操作ID
 */
- (void)TSL_StartCommonCommunicationWithCipher:(NSString *)chiper sendData:(NSString *)data controllId:(BluetoothOperation) blueOperation LockCode:(NSString *)aCode  KeyCate:(NSInteger)aCate;

/*!
 *  通过远程密文开门的方法
 *
 *  @param tempCipher 开门密文
 */
- (void)TSL_StartCommonCommunicationWithCipher:(NSString *) tempCipher PhoneNum:(NSString *) phoneNum LockCode:(NSString *)aCode  KeyCate:(NSInteger)aCate;

/*!
 *  所有与蓝牙通信的方法
 *  fuctions of communication
 *  @param mSendData  发送的数据
 *  @param mAddress   蓝牙模块的名称
 *  @param mCurUid    主键ID
 *  @param mControlID 操作ID  @see BluetoothOperation
 */
- (void) TSL_StartCommonCommunication:(NSString *) mSendData MacAddress:(NSString *) mAddress UUID:(NSString *) mCurUid ControlID:(BluetoothOperation) mControlID LockCode:(NSString *)aCode  KeyCate:(NSInteger)aCate;
/*!
 *   所有公租房的操作
 *
 *  @param mSendData  发送的数据
 *  @param mAddress   mac地址
 *  @param mControlID 操作ID    @see BluetoothOperation
 */
- (void) TSL_StartCommonCommunicationByPrh:(NSString *) mSendData
                            MacAddress:(NSString *) mAddress
                             ControlID:(BluetoothOperation) mControlID;

/*!
 *   所有蓝牙操作集合
 *
 *  @param data  数据集合  不同的  操作ID不同，传入的数据集合都不一样 操作ID 对应的Key  详情 See BluetoothOperation   
 *  eg:
 *  blueOperation 为 BlueHandleOpenDoor 时候
 *  data 数据为 data = @{TerminusKeyMacAddress: xxxx,TerminusKeyUid:xxxx,TerminusKeyUserPhone:xxxx}
 *
 *  @param blueOperation   操作ID @see BluetoothOperation
 */
- (void)StartCommonCommunicationWithData:(NSDictionary<NSString *, id> *) data operation:(BluetoothOperation) blueOperation LockCode:(NSString *)aCode  KeyCate:(NSInteger)aCate;


@end

extern NSString * const TerminusKeyIndexString; //配对用户的编号
extern NSString * const TerminusKeyUid;         //配对时候本地生成的唯一编号
extern NSString * const TerminusKeyMacAddress;  // 蓝牙的macAdress
extern NSString * const TerminusKeyUserPhone;   // 用户的手机号


extern NSString * const TerminusKeyPiaringPwd; //配对密码 6位
extern NSString * const TerminusKeyPiaringNewPwd; //配对新密码 6位
extern NSString * const TerminusKeyPiaringIsAdmin; //是否是管理员 @YES or @NO
extern NSString * const TerminusKeyPiaringKeyName; //锁名

extern NSString * const TerminusKeyOpenDoorNewPwd; //门禁开门密码

//完善信息

extern NSString * const TerminusKeyUserConnectType; // 联系方式
extern NSString * const TerminusKeyUserName;        //用户姓名
extern NSString * const TerminusKeyUserHouseInfor;  //住房楼栋信息






