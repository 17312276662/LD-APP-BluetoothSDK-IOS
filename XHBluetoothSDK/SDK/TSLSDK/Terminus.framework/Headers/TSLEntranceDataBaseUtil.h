//
//  TSLEntranceDataBaseUtil.h
//  TSLSmartKey
//
//  Created by huangdroid on 14-10-22.
//  Copyright (c) 2014年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TerminusEntranceKeyUserBean.h"

@interface TSLEntranceDataBaseUtil : NSObject

/*!
 *  钥匙数据库操作单例
 *
 *  @return 返回当前单例对象
 */
+ (TSLEntranceDataBaseUtil *)shareEntranceDBInstance ;


/*!
 *  插入单个数据实体
 *
 *  @param userBean 门禁实体
 *
 *  @return 返回是否插入成功
 */
-(BOOL) insertOneData:(TerminusEntranceKeyUserBean *) userBean;

/*!
 *  插入多个数据实体
 *
 *  @param userBeans 门禁实体数组
 *
 *  @return 返回是否插入成功
 */
-(BOOL) insertListData:(NSArray *) userBeans;

/*!
 *  异步线程插入多个实体
 *
 *  @param userBeans 实体对象数组
 */
-(void) insertListDataMultithread:(NSArray *) userBeans;

/*!
 *  更新数据
 *
 *  @param userBean 更新一个钥匙实体
 *
 *  @return 返回是否修改成功
 */
-(BOOL) updateData:(TerminusEntranceKeyUserBean *) userBean;


/*!
 *  根据用户唯一地址查询
 *
 *  @param indexString 该用户的地址  唯一主键
 *
 *  @return 返回门禁实体
 */
-(TerminusEntranceKeyUserBean *) selectOneData:(NSString *) indexString;


/*!
 *  查询所有门禁实体
 *
 *  @return 返回所有的门禁实体
 */
-(NSMutableArray *) selectAllData;


/*!
 *  根据该用户的唯一地址删除数据
 *
 *  @param indexString 该用户的唯一地址
 *
 *  @return 返回操作是否成功
 */
-(BOOL) deleteOneData:(NSString *) indexString;


/*!
 *  删除数据库所有的数据
 *
 *  @return 返回是否操作成功
 */
-(BOOL) deleteAllData;

@end
