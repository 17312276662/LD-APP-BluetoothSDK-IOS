//
//  TerminusKeyBean.h
//  TerminusDemo
//
//  Created by huangdroid on 15-1-29.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColumnPropertyMappingDelegate.h"
#import "TerminusConstants.h"


/*
 @class: 钥匙实体
 */

@interface TerminusKeyBean : NSObject <ColumnPropertyMappingDelegate>


/**
   蓝牙唯一标示   24位
 */
@property (copy, nonatomic  ) NSString    * keyUid;
/**
 锁的别名
 */
@property (copy, nonatomic  ) NSString   * keyName;

/**
 锁授权id
 */
@property (nonatomic,copy   ) NSString   * empowerId;
/**
 锁芯片ID (配对钥匙)
 */
@property (nonatomic,copy   ) NSString   * chipId;
/**
 标示该用户配对了，是否是管理员类型
 */
@property (nonatomic ,copy  ) NSString   * isAdmin;
/**
 该用户蓝牙模块地址
 */
@property (nonatomic,copy   ) NSString   * macAddress;
/**
 钥匙密码
 */
@property (nonatomic,copy   ) NSString   * keyPwd;


/**
 锁电量（保存最后一次开门获取到的电量）
 */
@property (nonatomic,assign ) DevicePowerLevels keyBatV;

/**
 本地钥匙 用户当前授权了多少次
 */
@property (nonatomic,copy   ) NSString   * authorizationTimes;
/**
 本地钥匙
 锁底层被授权了多少次 10 － （authorizationTimes - lockAuthorizationTimes）＝ 剩余授权次数
 */
@property (nonatomic,copy   ) NSString   * lockAuthorizationTimes;

/**
 锁类别 默认为门锁类型
 */
@property (nonatomic,assign ) BlueDeviceType keyCate;

/**
 开门方式（无效字段）
 */
@property (nonatomic,copy   ) NSString   * OpenTypeMode;
/**
 配对钥匙的hash 值
 */
@property (nonatomic,copy   ) NSString   * IndexString;

/**
 门锁类型编号
 */
@property (nonatomic,copy   ) NSString   * identifier;
/**
 钥匙类型 1:本地钥匙 2:远程钥匙
 */
@property (nonatomic,assign ) KeyAuthType keyType;
/**
 授权类型：0-门锁授权，1-家人，员工授权，2-访客授权,3-门锁永久授权
 */
@property (nonatomic,assign ) NSInteger   AuthType;
/**
 分组ID
 */
@property (nonatomic,copy   ) NSString  * groupId;

/**
 分组名称
 */
@property (nonatomic,copy   ) NSString  * groupName;
/**
 远程钥匙 临时钥匙  开始时间
 */
@property (nonatomic,copy   ) NSString  * StartTime;
/**
 远程钥匙 临时钥匙   结束时间
 */
@property (nonatomic,copy   ) NSString  * EndTime;


/**
 接收人
 */
@property (nonatomic,copy   ) NSString  * UserTo;
/**
 国家代码
 */
@property (nonatomic,copy   ) NSString  * CountryCode;
/**
 授权人电话号码
 */
@property (nonatomic,copy   ) NSString  * UserFromMobile;
/**
 授权人姓名
 */
@property (nonatomic,copy   ) NSString  * UserNameFrom;
/**
 远程钥匙密文
 */
@property (nonatomic,copy   ) NSString  * Cipher;
/**
 备注
 */
@property (nonatomic,copy   ) NSString  *  Memo;
@property (nonatomic,copy   ) NSString  *  Alias;
/**
 是否可分享
 */
@property (nonatomic,assign   ) NSInteger  IsShareable;

/**
 是否在钥匙列表或开锁中显示（是否启用）
 */
@property (nonatomic,assign ) NSInteger IsShow;
/**
 分组顺序编号
 */
@property (nonatomic,assign ) NSInteger sort;
/**
 创建时间
 */
@property (nonatomic,copy) NSString * CreateTime;
@property (nonatomic,assign) NSInteger State;
@property (nonatomic,copy)NSString * UserNameTo;
/**
 小区Id
 */
@property (nonatomic,copy   ) NSString * villageId;

/**
 小区名称
 */
@property (nonatomic,copy   ) NSString * villageName;

/**
 楼栋Id
 */
@property (nonatomic,copy   ) NSString * buildingId;

/**
 楼栋名称
 */
@property (nonatomic,copy   ) NSString * buildingName;
@property (nonatomic,assign ) NSInteger flag;




#pragma mark - 搜索字段使用

/**
 搜索使用 什么时间搜索到钥匙实体时间
 */
@property (nonatomic,assign ) long int refreshTimeOverlook;

/**
 搜索到时候的信号值
 */
@property (nonatomic,assign ) int rissOverlook;

/**
 设置考勤锁

 @param needCheckin 是否需要考勤
 */
- (void)setNeedCheckin:(BOOL)needCheckin;

/**
 是否考勤锁

 @return YES or NO
 */
- (BOOL)isNeedCheckin;
/**
 是否是分组钥匙

 @return YES or NO
 */
- (BOOL)isDisplayGroup;

/**
 是否是永久钥匙

 @return YES or NO
 */
- (BOOL)isPermanentKey;

/**
 获取钥匙ID
 
 @return NSString
 */
- (NSString *)getLockCode;

/**
 是否是分享本地永久钥匙

 @return YES or NO
 */
- (BOOL)isLocalPermanentKey;

/**
 拷贝钥匙数据

 @param keyModel 其他钥匙实体
 */
- (void)coupyKeyModelData:(TerminusKeyBean *)keyModel;




- (BOOL)isGateKey ;
@end





