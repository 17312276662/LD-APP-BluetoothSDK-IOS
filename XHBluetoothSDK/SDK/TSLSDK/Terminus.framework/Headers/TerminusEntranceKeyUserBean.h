//
//  TerminusEntranceKeyUserBean.h
//  TerminusDemo
//
//  Created by huangdroid on 15-1-29.
//  Copyright (c) 2015年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TerminusEntranceKeyUserBean : NSObject

/*!
 @property
 @brief   用户真实姓名
 */
@property (retain, nonatomic)NSString *username;

/*!
 @property
 @brief   用户手机号码
 */
@property (nonatomic,retain) NSString *phone;

/*!
 @property
 @brief   小区信息
 */
@property (nonatomic ,retain) NSString *village;

/*!
 @property
 @brief   该用户蓝牙模块地址
 */
@property (nonatomic,retain) NSString *macAddress;

/*!
 @property
 @brief   用户唯一标示
 */
@property (nonatomic,retain) NSString *indexString;


/*!
 @property
 @brief   用户在底层地址
 */
@property (nonatomic,retain) NSString *enable;


/*!
 *  初始化操作
 *
 *  @param theName        用户名称
 *  @param thePhone       手机号码
 *  @param theVillage     小区信息
 *  @param theAddress     地址
 *  @param theIndexString 用户唯一标示
 *  @param theenable      是否启用
 */
- (void)setName:(NSString *) theName
       andPhone:(NSString *) thePhone
     andVillage:(NSString *) theVillage
  andMacAddress:(NSString *) theAddress
 andIndexString:(NSString *) theIndexString
         Enable:(NSString *) theenable;

@end
