//
//  TerminusVillageModel.h
//  Terminus
//
//  Created by tom on 11/15/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ColumnPropertyMappingDelegate.h"

@interface TerminusVillageModel : NSObject <ColumnPropertyMappingDelegate>


/**
 大厦或小区Id
 */
@property (nonatomic,copy) NSString * Id;

/**
 公司或小区名称
 */
@property (nonatomic,copy) NSString * Name;
/**
 类型 大厦或小区类型区别
 0:小区, 1:公租房, 2:写字楼, 3:工厂, 4:公司
 */
@property (nonatomic,assign) NSInteger Type;


/**
 城市名字
 */
@property (nonatomic,copy) NSString * CityName;


/**
 省名字
 */
@property (nonatomic,copy) NSString * ProvinceName;

/**
 数据库更新标志
 */
@property (nonatomic,assign) NSInteger Mark;


/**
 经度
 */
@property (nonatomic,strong) NSNumber *Longitude;

/**
 纬度
 */
@property (nonatomic,strong) NSNumber *Latitude;

/**
 详细地址
 */
@property (nonatomic,copy) NSString * Address;

/**
 物业联系电话
 */
@property (nonatomic,copy) NSString * ContactNumber;


/**
 是否是小区

 @return YES OR NO
 */
- (BOOL)isVillage;

@end
