//
//  TerminusBleUtils.h
//  TerminusDemo
//  处理蓝牙数据的工具类
//  Created by huangdroid on 15-1-30.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSLAESUtil8.h"
#import "TerminusKeyBean.h"
#import "TerminusReceiveBean.h"
#import "TerminusEntranceKeyUserBean.h"

@interface TerminusBleUtils : NSObject


/*!
 *  将字符串拆分成单个数据包数组
 *
 *  @param cipher    开锁密文
 *  @param controlId 操作ID
 *
 *  @return 返回格式化数据
 */
+ (NSMutableArray *) handleSendDataToDataArray:(NSString *) cipher
                                    ControlID:(BluetoothOperation) controlId NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用新方法 handleSendDataToDataWithChiper:operation");
/*!
 *  将字符串拆分成单个数据包数组
 *
 *  @param cipher    开锁密文
 *  @param controlId 操作ID
 *
 *  @return 返回格式化数据
 */
+ (NSData *) handleSendDataToDataWithChiper:(NSString *)chiper
                                  operation:(BluetoothOperation)operation;
/*!
 *  处理配对之后的结果数据
 *
 *  @param newMsgs 接收到的所有数据集合
 *  @param cUid    钥匙唯一主键 （KeyUid）
 *  @param macAdd  钥匙macdress
 *
 *  @return 返回结果对象
 */
+ (TerminusReceiveBean *) handlePierData:(NSString *) newMsgs
                                   UUID:(NSString *) cUid
                             MacAddress:(NSString *) macAdd;


/*!
 *  处理公共错误 eg: 密码被更改，用户已被清除，钥匙已反锁
 *
 *  @param mMsgs 接收到的所有数据集合
 *
 *  @return 返回操作结果  YES 成功 NO 失败
 */
+ (BOOL) handleFailElseData:(NSString *) mMsgs;


/*!
 *  解析开门和配对数据
 *
 *  @param recMsg   接收蓝牙底层数据
 *  @param isPier   是否是配对
 *  @param cUid     钥匙唯一主键 （KeyUid）
 *  @param macName  macAdress
 *  @param isRemote 是否为远程钥匙
 *
 *  @return 钥匙实体 如果数据发生错误将返回 nil
 */
+ (TerminusKeyBean *) resolveOpenDoorOrPierData:(NSString *) recMsg
                                         IsPier:(BOOL) isPier
                                           UUID:(NSString *) cUid
                                            Mac:(NSString *) macName
                                       IsRemote:(BOOL) isRemote;

/*!
 *  转换16->10进制
 *
 *  @param tmpid 代转16进制
 *
 *  @return 返回转化后的10进制
 */
+ (int)ToHex:(NSString*)tmpid;


/*!
 *  处理修改密码数据
 *
 *  @param newMsgs 接收到的蓝牙数据
 *  @param cUid    钥匙唯一主键
 *  @param cipher  开锁密文
 *
 *  @return 返回 结果实体 see “TerminusReceiveBean”
 */
+(TerminusReceiveBean *) handleUpdatePwdData:(NSString *) newMsgs UUID:(NSString *) cUid Cipher:(NSString *) cipher;


/*!
 *  处理校验握手数据
 *
 *  @param newMsgs 接收到的蓝牙数据
 *  @param cUid    钥匙唯一主键
 *  @param cipher  开锁密文
 *
 *  @return 返回结果实体 see “TerminusReceiveBean”
 */
+(TerminusReceiveBean *) handleOpenDoorHandleData:(NSString *) newMsgs UUID:(NSString *) cUid TerminusKeyBeanInfo:(TerminusKeyBean *) curKeyBean;


/*!
 *  处理校验握手数据
 *
 *  @param newMsgs  接收到的蓝牙数据
 *  @param cUid     钥匙唯一主键
 *  @param isRemote 是否是远程钥匙
 *
 *  @return 返回结果实体 see “TerminusReceiveBean”
 */
+(TerminusReceiveBean *) handleOpenDoorData:(NSString *) newMsgs UUID:(NSString *) cUid IsRemote:(BOOL) isRemote;


/*!
 *  处理开门日志数据
 *
 *  @param newMsgs 接收到的蓝牙数据
 *  @param cUid    钥匙唯一主键
 *
 *  @return 返回结果实体 see “TerminusReceiveBean”
 */
+(TerminusReceiveBean *) handleOpenLogsData:(NSString *) newMsgs UUID:(NSString *) cUid;


/*!
 *  解析开门日志数据
 *
 *  @param mMsg 需要解析的开门日志数据
 *
 *  @return 返回开门日志结果
 */
+(NSMutableArray *) resolveOpenLogsData:(NSString *) mMsg;


/*!
 *   处理获取门锁所有用户数据
 *
 *  @param newMsgs 接收到的蓝牙数据
 *  @param cUid    钥匙唯一主键
 *  @param keyCate 钥匙类型 see BluetoothKeyType
 *
 *  @return 返回结果实体 see “TerminusReceiveBean”
 */
+(TerminusReceiveBean *) handleKeyAllUserData:(NSString *) newMsgs UUID:(NSString *) cUid KeyCate:(BlueDeviceType) keyCate;


/*!
 *  解析小区门禁用户数据，返回用户实体列表
 *
 *  @param resultStr 接收到的蓝牙数据
 *  @param curIndex  第几个数据
 *
 *  @return 返回门禁用户实体列表
 */
+ (NSMutableArray *) resolveModels:(NSString *) resultStr CurIndex:(int) curIndex ;


/*!
 *  解析家庭门用户数据，返回用户实体列表
 *
 *  @param resultStr 接收到的蓝牙数据
 *  @param curIndex  第几个数据
 *
 *  @return 返回家庭门用户实体列表
 */
+ (NSMutableArray *) resolveDoorModels:(NSString *) resultStr CurIndex:(int) curIndex;


/*!
 *  解析小区门禁用户数据，去除特殊字符
 *
 *  @param userBean 待处理钥匙实体eg：实体类中有硬件中协定的特殊站位符号 使用方法去除方法
 *
 *  @return 返回处理后的钥匙实体
 */
+ (TerminusEntranceKeyUserBean *) replaceStrModel:(TerminusEntranceKeyUserBean *) userBean;


/*!
 *  解析小区门禁用户数据，去除已删除的实体
 *
 *  @param userBeans 待处理的钥匙实体集合
 *
 *  @return 返回处理后的钥匙实体集合
 */
+ (NSMutableArray *) replaceNullModel:(NSMutableArray *) userBeans;


/*!
 *  处理删除单个数据
 *
 *  @param newMsgs 接受蓝牙数据集合
 *  @param cUid    钥匙唯一主键
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleDeleteOneUserData:(NSString *) newMsgs UUID:(NSString *) cUid;


/*!
 *  处理删除所有用户数据
 *
 *  @param newMsgs 接受蓝牙数据集合
 *  @param cUid    钥匙唯一主键
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleDeleteAllUserData:(NSString *) newMsgs UUID:(NSString *) cUid;


/*!
 *  处理禁用单个用户数据
 *
 *  @param newMsgs 接受蓝牙数据集合
 *  @param cUid    钥匙唯一主键
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleDisableOneUserData:(NSString *) newMsgs UUID:(NSString *) cUid;


/*!
 *  处理启用单个用户数据
 *
 *  @param newMsgs 接受蓝牙数据集合
 *  @param cUid    钥匙唯一主键
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleEnableOneUserData:(NSString *) newMsgs UUID:(NSString *) cUid;

#pragma mark -
/*!
 *  处理完善用户信息数据
 *
 *  @param newMsgs    接受蓝牙数据集合
 *  @param cUid       钥匙唯一主键
 *  @param deviceName 蓝牙设备mac地址
 *  @param sendData   发送到蓝牙的数据
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleCompleteUserInfoData:(NSString *) newMsgs UUID:(NSString *) cUid DeviceNameMac:(NSString *) deviceName SendData:(NSString *) sendData;

/*!
 *  处理开始双模固件升级信息数据
 *
 *  @param newMsgs    接受蓝牙数据集合
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleStartUpgradeFirmwareData:(NSString *) newMsgs;

/*!
 *  处理法哦送双模固件分包信息数据
 *
 *  @param newMsgs    接受蓝牙数据集合
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handlePostUpgradeFirmwareData:(NSString *) newMsgs;

/*!
 *  解析完善用户信息数据
 *
 *  @param newMsg 接受到的蓝牙数据
 *  @param cUid   钥匙唯一主键
 *
 *  @return 是否完善成功 @see TerminusReceiveBean
 */
+(BOOL) resolveCompleteUserInfoData:(NSString *) newMsg KeyBean:(TerminusKeyBean *)curKeyBean;

/*!
 *  处理设备信息数据
 *
 *  @param newMsgs    接受蓝牙数据集合
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleGetDeviceInfoData:(NSString *) newMsgs;


#pragma mark -
/*!
 *  通过得到的结果判断错误的信息
 *
 *  @param resStr 接受到的蓝牙数据
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) getErrorCodeByResultStr:(NSString *) resStr;


/*!
 *   恢复出厂设置
 *
 *  @param newMsgs 接受到的蓝牙数据
 *  @param cUid    钥匙主键（KeyUid）
 *
 *  @return 返回结果实体
 */
+(TerminusReceiveBean *) handleResetData:(NSString *) newMsgs UUID:(NSString *) cUid;


/*!
 *  处理通用接口数据，没有额外返回数据，@SUCC 表示成功
 *
 *  @param newMsgs 接受到的蓝牙数据
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleCommonResponseData:(NSString *) newMsgs;


/*!
 *  处理硬件回调数据
 *
 *  @param newMsgs   接受到的蓝牙数据
 *  @param controlID 当前操作ID @see BluetoothOperation
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleHardwareData:(NSString *) newMsgs ControlID:(BluetoothOperation) controlID;


/*!
 *  处理获取状态的数据
 *
 *  @param newMsgs 接受到的蓝牙数据
 *  @param cUid    钥匙唯一主键
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleGarateStatusData:(NSString *) newMsgs UUID:(NSString *) cUid;


/*!
 *  处理NFC信息数据
 *
 *  @param newMsgs    接受蓝牙数据集合
 *
 *  @return 返回数据实体 @see TerminusReceiveBean
 */
+(TerminusReceiveBean *) handleGetNFCInfoData:(NSString *) newMsgs;

/*!
 *  自动补齐Ascii字符串到目标长度
 *
 *  @param text    输入字符串
 *  @param targetLen    目标长度
 *
 *  @return 补齐后的字符串
 */
+ (NSString *)completeAsciiText:(NSString*)text length:(NSUInteger)targetLen;

@end

@interface TerminusBleUtils (Tools)
/*!
 *  根据搜索名称前缀获取设备类型
 *
 *  @param searchName    根据搜索名称前缀（搜索名称去掉Mac地址）
 *
 *  @return 返回设备类型 @see BlueDeviceType
 */
+ (NSInteger)getKeyTypeByName:(NSString *)searchName;

/*!
 *  根据产品编码获取产品型号
 *
 *  @param productCode    产品编码
 *
 *  @return 返回产品型号
 */
+ (NSString *)getProductModelByCode:(int)productCode;
+ (NSString *)getProductModelByCode:(int)productCode simpleName:(NSString**)simpleName;

@end

extern NSString * const FLAGA_CONNECT_OPEN_DOOR_FAIL;

/*!
 *  开门：门锁已清除，其他操作：密码错误
 */
extern NSString * const FLAGA_CONNECT_OPEN_DOOR_PWD_CLEAN_ERROR_FAIL;

/*!
 *  密码错误
 */
extern NSString * const FLAGA_CONNECT_OPEN_DOOR_PWD_ERROR_FAIL;
/*!
 *  用户已清除
 */
extern NSString * const FLAGA_CONNECT_OPEN_DOOR_CLEAN_FAIL;
/*!
 *  室内已反锁
 */
extern NSString * const FLAGA_CONNECT_OPEN_DOOR_LOCKED_FAIL;
/*!
 *  用户被禁用
 */
extern NSString * const FLAGA_CONNECT_OPEN_DOOR_DISABLE_FAIL;
/*!
 *  配对数量已满，需要清除用户
 */
extern NSString * const FLAGA_CONNECT_OPEN_DOOR_PIER_FULL_FAIL;


extern NSString * const FLAGA_CONNECT_OPEN_DOOR_PIER_FULL_FAIK;

/*!
 *  当前配对用户不可用
 */
extern NSString * const KYE_SUER_DISABLE;
/*!
 *  可用
 */
extern NSString * const KYE_SUER_ENABLE;

/*!
 *  自动开门
 */
extern NSString * const ID_OPEN_TYPE_AUTO ;
/*!
 *  手动开门
 */
extern NSString * const ID_OPEN_TYPE_MANUAL;


/*!
 *  客户端类型  0-安卓，1-苹果，2-Wp8，3-Web，如不填写，      端自动获取
 */
extern NSString * const ClientType_IOS;

/*!
 *  客户端苹果私钥
 *
 */
extern NSString * const ClientType_PRIVATE_KEY;
/*!
 *  设置管理员
 */
extern NSString * const ID_PIER_SET_ADMIN ;
/*!
 *  普通用户
 */
extern NSString * const ID_PIER_UNSET_ADMIN;





