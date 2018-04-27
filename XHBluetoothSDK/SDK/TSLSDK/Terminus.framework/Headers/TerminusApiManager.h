//
//  TerminusApiManager.h
//  TerminusDemo
//  
//  Created by huangdroid on 15-1-30.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TerminusKeyBean.h"

@interface TerminusApiManager : NSObject



/**
 *  数据解密
 *
 *  @param cipher 远程钥匙密文
 *
 *  @return 返回蓝牙能开锁密文 和门锁信息 key 包含：keyName，mac，pwd，IndexString，cipher
 */
+ (NSDictionary *)decodeCipher:(NSString *)cipher keyCate:(NSInteger)type;

/*!
 *  获取24位唯一标示
 *
 *  @return 通过时间戳获取唯一标示
 */
+ (NSString *) getKeyUUIDByDateTime;


/*!
 *  组装修改密码发送的数据
 *
 *  @param uid     钥匙唯一主键
 *  @param pierPwd 配对密码
 *  @param newPwd  新密码
 *
 *  @return 返回加密后的修改密码数据
 */
+ (NSString *) getUpdateSecretData:(NSString *)uid
                           PierPwd:(NSString *) pierPwd
                            NewPwd:(NSString *) newPwd;



/*!
 *  组装开门记录发送的数据
 *
 *  @param uid 钥匙唯一主键 KeyUid
 *
 *  @return 加密后的开门记录数据
 */
+ (NSString *) getOpenRecordData:(NSString *) uid;

+ (NSString *) getOpenRecordDataBean:(TerminusKeyBean *) tempKeyBean NS_AVAILABLE_IOS(2_0);

/*!
 *  组装开门发送的数据
 *
 *  @param uid         钥匙唯一主键 KeyUid
 *  @param tempKeyBean 钥匙实体
 *  @param openKey     动态密文
 *
 *  @return 加密后开门发送数据
 */
+(NSString *) getOpenDoorData:(NSString *) uid
              TerminusKeyBean:(TerminusKeyBean *) tempKeyBean
                      OpenKey:(NSString *) openKey;


/*!
 *  组装开门(NEW)
 *
 *  @param uid      钥匙唯一主键 KeyUid
 *  @param phoneNum 用户手机号码
 *
 *  @return 加密后组装开门(NEW)发送数据
 */
+ (NSString *) getOpenDoorData:(NSString *) uid
                     PhoneNum:(NSString *) phoneNum;

+ (NSString *) getOpenDoorDataBean:(TerminusKeyBean *) tempKeyBean
                          PhoneNum:(NSString *) phoneNum NS_AVAILABLE_IOS(2_0);

/*!
 *  组装获取地锁状态
 *
 *  @param uid 钥匙唯一主键 KeyUid
 *
 *  @return 加密后地锁状态发送数据
 */
+ (NSString *) getGarateStatusData:(NSString *)uid;

+(NSString *) getGarateStatusDataBean:(TerminusKeyBean *)tempKeyBean NS_AVAILABLE_IOS(2_0);

+ (NSString *)getGarateStatusDataByPwd:(NSString *)pwd kUid:(NSString *)aUid;

/*!
 *  组装地锁开门数据
 *
 *  @param uid      钥匙唯一主键 KeyUid
 *  @param isOpen   是否开地锁
 *  @param phoneNum 用户手机号码
 *
 *  @return 加密后地锁开门发送数据
 */
+ (NSString *) getOpenDoorData:(NSString *) uid
                        IsOpen:(BOOL) isOpen
                      PhoneNum:(NSString *) phoneNum;


/*!
 *  组装关闭地锁
 *
 *  @param uid 钥匙唯一主键 KeyUid
 *
 *  @return 加密后关闭地锁发送数据
 */
+ (NSString *) getGarateCloseData:(NSString *)uid;

+ (NSString *) getGarateCloseDataBean:(TerminusKeyBean *)tempKeyBean NS_AVAILABLE_IOS(2_0);
+ (NSString *) getGarateCloseDataByPwd:(NSString *)pwd kUid:(NSString *)aUid;
/*!
 *  组装远程开门(NEW)
 *
 *  @param tempKeyBean 钥匙实体
 *
 *  @return 加密后组装远程开门(NEW)发送数据
 */
+ (NSString *) getRemoteOpenDoorData:(TerminusKeyBean *) tempKeyBean PhoneNum:(NSString *) phoneNum;


/*!
 *  获取远程开门对象通过远程密文
 *
 *  @param cipher 开门钥匙密文
 *
 *  @return 加密后远程密文发送数据
 */
+(TerminusKeyBean *) getOpenDoorKeyBeanByRemoteCipher:(NSString *) cipher;


/*!
 *  组装开门握手数据通过远程密文
 *
 *  @param tempKeyBean 钥匙实体
 *
 *  @return 加密后组装开门握手数据通过远程密文发送的数据
 */
+(NSString *) getOpenDoorHandleDataByRemoteCipherBean:(TerminusKeyBean *) tempKeyBean;


/*!
 *  组装开门数据通过远程密文
 *
 *  @param tempKeyBean 钥匙实体
 *  @param openKey     动态密文
 *
 *  @return 加密后开门数据通过远程密文发送的数据
 */
+(NSString *) getOpenDoorHandleSuccDataByRemoteCipher:(TerminusKeyBean *) tempKeyBean
                                              OpenKey:(NSString *) openKey;


/*!
 *  组装握手数据
 *
 *  @param uid      钥匙唯一主键 KeyUid
 *  @param phoneNum 用户手机号码
 *
 *  @return 加密后握手数据发送的数据
 */
+(NSString *) getHandleOpenDoorData:(NSString *) uid
                           PhoneNum:(NSString *) phoneNum;


/*!
 *  握手成功后的开门数据
 *
 *  @param uid      钥匙唯一主键 KeyUid
 *  @param isRemote 是否是远程钥匙
 *
 *  @return 加密后握手成功后的开门数据发送的数据
 */
+(NSString *) getHandleSuccOpenDoorData:(NSString *) uid
                               IsRemote:(BOOL) isRemote;


/*!
 *  配对修改密码或设置管理员
 *
 *  @param uid      钥匙唯一主键 KeyUid
 *  @param pierPwd  配对密码
 *  @param newPwd   新密码
 *  @param isAdmin  是否为管理员
 *  @param userName 用户名称
 *
 *  @return 加密后配对修改密码或设置管理员发送的数据
 */
+ (NSString *) getPierUpdateSecretData:(NSString *) uid
                              PierPwd:(NSString *) pierPwd
                               NewPwd:(NSString *) newPwd
                              IsAdmin:(BOOL) isAdmin
                             UserName:(NSString *) userName;

/*!
 *  获取设备信息
 *
 *  @param uid      钥匙唯一主键 KeyUid
 *  @param pierPwd  配对密码
 *  @param newPwd   新密码
 *  @param isAdmin  是否为管理员
 *
 *  @return 加密后设备信息的数据
 */
+ (NSString *) getDeviceInfoData:(NSString *) uid
                               PierPwd:(NSString *) pierPwd
                                NewPwd:(NSString *) newPwd
                                IsAdmin:(BOOL) isAdmin;


/*!
 *  获取所有用户
 *
 *  @param uid 钥匙唯一主键 KeyUid
 *
 *  @return 加密后获取所有用户发送的数据
 */
+ (NSString *) getAllUserData:(NSString *) uid;

+ (NSString *) getAllUserDataBean:(TerminusKeyBean *)tempKeyBean NS_AVAILABLE_IOS(2_0);

/*!
 *  完善用户信息
 *
 *  @param uid            钥匙唯一主键 KeyUid
 *  @param name           用户名称
 *  @param phones         电话号码
 *  @param userAddress    用户地址
 *  @param userSettingMac 用户设置的macAddress 目前只能设置后面六位
 *
 *  @return 加密后完善用户信息发送的数据
 */
+ (NSString *) getCompleteUserInfoData:(NSString *) uid
                                 Name:(NSString *) name
                                Phone:(NSString *)phones
                          UserAddress:(NSString *) userAddress
                       UserSettingMac:(NSString *) userSettingMac;


/*!
 *  删除单个用户
 *
 *  @param uid     钥匙唯一主键 KeyUid
 *  @param userKey 用户ID
 *
 *  @return 加密后删除单个用户发送的数据
 */
+(NSString *) getDeleteOneUserData:(NSString *) uid
                           UserKey:(NSString *) userKey;

+(NSString *) getDeleteOneUserDataBean:(TerminusKeyBean *)tempKeyBean
                               UserKey:(NSString *) userKey NS_AVAILABLE_IOS(2_0);
/*!
 *  清除所有用户
 *
 *  @param uid 钥匙唯一主键 KeyUid
 *
 *  @return 加密后清除所有用户发送的数据
 */
+(NSString *) getDeleteAllUserData:(NSString *)uid;

+(NSString *) getDeleteAllUserDataBean:(TerminusKeyBean *)tempKeyBean NS_AVAILABLE_IOS(2_0);

/*!
 *  禁用单个用户
 *
 *  @param uid     钥匙唯一主键 KeyUid
 *  @param userKey 用户ID
 *
 *  @return 加密后禁用单个用户发送的数据
 */
+(NSString *) getDisableOneUserData:(NSString *) uid
                            UserKey:(NSString *) userKey;

+(NSString *) getDisableOneUserDataBean:(TerminusKeyBean *)tempKeyBean
                                UserKey:(NSString *)userKey NS_AVAILABLE_IOS(2_0);
/*!
 *  启用单个用户
 *
 *  @param uid     钥匙唯一主键 KeyUid
 *  @param userKey 用户ID
 *
 *  @return 加密后启用单个用户发送的数据
 */
+(NSString *) getEnableOneUserData:(NSString *) uid
                           UserKey:(NSString *) userKey;

+(NSString *) getEnableOneUserDataBean:(TerminusKeyBean *) tempKeyBean
                               UserKey:(NSString *) userKey NS_AVAILABLE_IOS(2_0);
/*!
 *  获取用户所有配对钥匙
 *
 *  @return 加密后获取所有配对钥匙发送的数据
 */
+(NSMutableArray *) getUserAllKeys;


/*!
 *  获取锁详细信息通过uid
 *
 *  @param keyUid 钥匙唯一主键 KeyUid
 *
 *  @return 钥匙钥匙实体
 */
+(TerminusKeyBean *) getUserKeyByUid:(NSString *) keyUid;


/*!
 *  删除用户钥匙通过锁唯一标示KeyUid
 *
 *  @param keyUid 钥匙唯一主键 KeyUid
 */
+(BOOL) deleteUserKeyByUid:(NSString *) keyUid;


/*!
 *  修改锁别名
 *
 *  @param keyUid      钥匙唯一主键 KeyUid
 *  @param tempKeyName 需要修改锁的名称
 */
+(void) updateKeyNameWithUid:(NSString *) keyUid
                     KeyName:(NSString *) tempKeyName;


/*!
 *  获取远程授权密文
 *
 *  @param keyUid 钥匙唯一主键 KeyUid
 *
 *  @return 远程授权密文
 */
+(NSString *) getRemoteAuthorzationCipherByUid:(NSString *) keyUid;


/*!
 *  获取永久授权密码 －－ 通过按键密码开门
 *
 *  @param keyUid 钥匙唯一主键 KeyUid
 *
 *  @return 六位按键开门密码
 */
+(NSString *) getPermanentAuthorzationByUid:(NSString *) keyUid;


/*!
 *  获取单次授权密码 -- 通过按键密码开门（只有一次有效）
 *
 *  @param keyUid 钥匙唯一主键 KeyUid
 *
 *  @return 十位按键开门密码
 */
+(NSString *) getOnetimeAuthorzationByUid:(NSString *) keyUid;


/*!
 *  获取恢复出厂设置的数据
 *
 *  @param uid     钥匙唯一主键 KeyUid
 *  @param userPwd 用户密码
 *
 *  @return 加密恢复出厂设置的数据
 */
+(NSString *) getResetData:(NSString *)uid
                   UserPwd:(NSString *) userPwd;

+(NSString *) getResetDataBean:(TerminusKeyBean *)tempKeyBean
                       UserPwd:(NSString *) userPwd NS_AVAILABLE_IOS(2_0);


/*!
 *  修改钥匙本地密码
 *
 *  @param keyUid 钥匙唯一主键 KeyUid
 *  @param pwd    配对密码
 *
 *  @return 是否成功
 */
+(BOOL) updateKeyPasswordWithUid:(NSString *) keyUid
                        Password:(NSString *) pwd;



/*!
 *  获取公租房启用公租房数据
 *
 *  @param adminPwd 配对密码
 *
 *  @return 加密后公租房启用的数据
 */
+(NSString *) getEnableDataByPrhAdmin:(NSString *) adminPwd;



/*!
 *  获取公租房禁用公租房数据
 *
 *  @param adminPwd  配对密码
 *
 *  @return 加密后公租房禁用公租房数据
 */
+(NSString *) getDisableDataByPrhAdmin:(NSString *) adminPwd;



/*!
 *  获取修改公租房管理员密码公租房数据
 *
 *  @param adminPwd 配对密码
 *  @param newPwd   新密码
 *
 *  @return 加密后修改公租房管理员密码公租
 */
+(NSString *) getUpdatePasswordDataByPrhAdmin:(NSString *) adminPwd
                                  NewPassword:(NSString *) newPwd;


/*!
 *  获取设置门禁开门密码
 *
 *  @param uid         钥匙唯一主键 KeyUid
 *  @param adminPwd    配对密码
 *  @param openDoorPwd 开门密码
 *
 *  @return 加密后设置门禁开门密码的数据
 */
+(NSString *) getSetEntranceOpenDoorPwd:(NSString *)uid
                          AdminPassword:(NSString *) adminPwd
                       OpenDoorPassword:(NSString *) openDoorPwd;

+(NSString *) getSetEntranceOpenDoorPwdBean:(TerminusKeyBean *)tempKeyBean
                           OpenDoorPassword:(NSString *) openDoorPwd NS_AVAILABLE_IOS(2_0);

/*!
 *  通过密文得到mac
 *
 *  @param ciphers 开门密文集合
 *
 *  @return mac地址集合
 */
+(NSMutableArray *) getKeyMacByCipher:(NSMutableArray *) ciphers;


/*!
 *  获取老化测试数据
 *
 *  @param uid     钥匙唯一主键 KeyUid
 *  @param userPwd 用户密码
 *
 *  @return 加密老化测试的数据
 */
+(NSString *) getAgingTestData:(NSString *)uid
                   UserPwd:(NSString *) userPwd;

/*!
 *  获取初始化NFC数据
 *
 *  @param uid     钥匙唯一主键 KeyUid
 *  @param userPwd 用户密码
 *
 *  @return 加密初始化NFC的数据
 */
+(NSString *) getResetNFCData:(NSString *)uid
                       UserPwd:(NSString *) userPwd
                       nfcType:(NSString*)nfcType
                       villageId:(NSString *)villageId
                       buildingId:(NSString *)buildingId
                       houseId:(NSString *)houseId;


/*!
 *  获取NFC信息数据
 *
 *  @param uid     钥匙唯一主键 KeyUid
 *  @param userPwd 用户密码
 *
 *  @return 加密NFC信息的数据
 */
+(NSString *) getNFCInfoData:(NSString *)uid
                       UserPwd:(NSString *) userPwd;

@end

/*!
 *  远程蓝牙底层通信私钥
 */
extern NSString * const ClIENT_BLUE_REMOTE;

