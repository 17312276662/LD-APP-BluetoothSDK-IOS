//
//  TerminusRemoteModel.h
//  Terminus
//
//  Created by tom on 11/14/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TerminusKeyBean.h"

@interface TerminusRemoteModel : NSObject
/**
 钥匙主键ID
 */
@property (nonatomic, copy) NSString * Id;

/**
 锁编码
 */
@property (nonatomic, copy) NSString  *LockCode;

/**
 门锁类型
 */
@property (nonatomic, assign) NSInteger  Type;

/**
 开锁密文
 */
@property (nonatomic, copy) NSString * Cipher;
/**
 授权人手机号码
 */
@property (nonatomic, copy) NSString * UserFromMobile;

/**
 钥匙别名
 */
@property (nonatomic, copy) NSString * Alias;
/**
 授权人姓名
 */
@property (nonatomic, copy) NSString * UserNameFrom;

/**
 被授权人名称
 */
@property (nonatomic, copy) NSString * UserNameTo;

/**
 被授权人国家代码
 */
@property (nonatomic, copy) NSString *  CountryCode;


/**
 授权类型：0-门锁授权，1-家人，员工授权，2-访客授权,3-门锁永久授权
 */
@property (nonatomic, assign) NSInteger  AuthType;

/**
 钥匙是否可以进行分享
 */
@property (nonatomic, assign) NSInteger IsShareable;

/**
 是否显示
 */
@property (nonatomic, assign) NSInteger IsShow;

/**
 钥匙开始时间(UTC时间戳)
 */
@property (nonatomic, copy) NSString *  StartTime;

/**
 钥匙结束时间(UTC时间戳)
 */
@property (nonatomic, copy) NSString *  EndTime;


/**
 分组钥匙排序编号
 */
@property (nonatomic, assign) NSInteger Sort;

/**
 状态：0-正常，1-撤销,2-删除，3-已过期
 */
@property (nonatomic, assign) NSInteger State;

/**
 被授权人号码
 */
@property (nonatomic, copy) NSString * UserTo;

/**
 钥匙分享时间(UTC时间戳)
 */
@property (nonatomic, copy) NSString * CreateTime;

/**
 分组ID
 */
@property (nonatomic, copy) NSString * GroupId;

/**
 分组名称
 */
@property (nonatomic, copy) NSString * GroupName;

/**
 签到锁
 */
@property (nonatomic, assign) NSInteger IsNeedCheckIn;

/**
 解析cipher 数据后得到的macAdress，名字，名称，密码
 */
@property (nonatomic, copy) NSString * tempCipher;

/**
 蓝牙模块名称的部分，蓝牙模块的地址
 */
@property (nonatomic,copy)  NSString *Name;

/**
 授权密码
 */
@property (nonatomic,copy)  NSString *Pwd;

/**
 uuid (如果是mac地址后面添加12个星号)
 */
@property (nonatomic,copy)  NSString *Mac;

/**
 index (只有门禁才用到了这个参数)
 */
@property (nonatomic,copy)  NSString *IndexString;


/**
 解析密文

 @param aChiper 待解析密文
 */
- (void)decryptionChiper:(NSString *)aChiper;

//根据当前model返回 钥匙数据实体

/**
 远程钥匙实体获取 开锁钥匙实体

 @return TerminusKeyBean 实体
 */
- (TerminusKeyBean *)getLocalKeyData;


@end
