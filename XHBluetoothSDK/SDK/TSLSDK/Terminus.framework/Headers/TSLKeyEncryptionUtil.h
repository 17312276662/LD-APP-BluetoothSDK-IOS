//
//  TSLKeyEncryptionUtil.h
//  TSLSmartKey
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSLKeyEncryptionUtil : NSObject

/*!
 *  单次授权获取密码
 *
 *  @param remopwd    锁密码
 *  @param lockId     钥匙的ID （chipId）
 *  @param localIdStr 当前授权次数
 *  @param num        当前授权次数
 *
 *  @return 返回授权密码
 */
- (NSString *) getRemoteStr:(NSString*) remopwd :(NSString*) lockId :(NSString *) localIdStr :(int) num;
/*!
 *  永久授权获取密码
 *
 *  @param remopwd    锁密码
 *  @param lockId     钥匙的ID （chipId）
 *  @param localIdStr 当前授权次数
 *  @param num        当前授权次数
 *
 *  @return 返回永久授权密码
 */
- (NSString *) getRemoteForeverStr:(NSString*) remopwd :(NSString*) lockId :(NSString *) localIdStr :(int) num;
/*!
 *  转换16进制
 *
 *  @param tmpid 代转16进制
 *
 *  @return 返回转化后的10进制
 */
- (int) ToHex:(NSString*)tmpid;
@end
