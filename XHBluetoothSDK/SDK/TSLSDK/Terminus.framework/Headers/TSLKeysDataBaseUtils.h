//
//  TSLKeysDataBaseUtils.h
//  TSLHotel
//
//  Created by huangdroid on 15-1-20.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FMDatabase.h"
#import "TerminusKeyBean.h"
#import "TerminustKeyLogModel.h"
@class FMEncryptDatabaseQueue;

@interface TSLKeysDataBaseUtils : NSObject


@property (nonatomic,readonly,strong) FMEncryptDatabaseQueue * dbQueue;

/*!
 *  钥匙数据库操作单例
 *
 *  @return 返回当前单例对象
 */
+ (TSLKeysDataBaseUtils *)sharedInstance;


+ (FMEncryptDatabaseQueue * )getKeyQuen;

/*!
 *  插入单个数据实体
 *
 *  @param userBean 钥匙实体
 *
 *  @return 返回是否插入成功
 */
-(BOOL) insertOneData:(TerminusKeyBean *) userBean;


/*!
 *  插入多个数据实体
 *
 *  @param userBeans 钥匙实体数组
 *
 *  @return 返回是否插入成功
 */
-(BOOL) insertListData:(NSArray *) userBeans;


/*!
 *  更新数据
 *
 *  @param userBean 更新一个钥匙实体
 *
 *  @return 返回是否修改成功
 */
-(BOOL) updateData:(TerminusKeyBean *) userBean;


/*!
 *  更新数据
 *
 *  @param userBean       钥匙实体
 *  @param userSettingMac 更新的Macdress地址
 *
 *  @return 返回是否修改成功
 */
-(BOOL) updateData:(TerminusKeyBean *) userBean UserSetingMac:(NSString *) userSettingMac;


/*!
 *  查询单个数据
 *
 *  @param keyUid 钥匙实体的唯一标示
 *
 *  @return 返回查询的钥匙实体
 */
-(TerminusKeyBean *) selectOneData:(NSString *) keyUid;


/*!
 *  查询所有数据
 *
 *  @return 返回查询所有的钥匙尸体
 */
-(NSMutableArray *) selectAllData;


/*!
 *  根据唯一标示KeyUid删除钥匙实体
 *
 *  @param keyUid 钥匙的唯一标示（主键）
 *
 *  @return 返回是否删除成功
 */
-(BOOL) deleteOneData:(NSString *) keyUid;


/*!
 *  删除所有数据
 *
 *  @return 是否删除成功
 */
-(BOOL) deleteAllData;

@end


/*!
 *  数据库名称
 */
extern NSString * const DBNAME;
extern NSString * const dbNewName;


