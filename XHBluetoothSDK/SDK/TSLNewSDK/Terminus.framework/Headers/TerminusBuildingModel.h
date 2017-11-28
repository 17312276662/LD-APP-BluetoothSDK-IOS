//
//  TerminusBuildingModel.h
//  Terminus
//
//  Created by tom on 11/15/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColumnPropertyMappingDelegate.h"

@interface TerminusBuildingModel : NSObject <ColumnPropertyMappingDelegate>
/**
 *关联的Id （外键） 与 KeyHousesModel中Id
 */
@property (nonatomic,copy) NSString * commpanyId;

/**
 小区（公司）名称
 */
@property (nonatomic,copy) NSString * commpanyName;
/**
 楼栋或公司Id
 */
@property (nonatomic,copy) NSString * BuildingId;

/**
 楼栋或公司名称
 */
@property (nonatomic,copy) NSString * BuildingName;

/**
 楼层或门闸ID
 */
@property (nonatomic,copy) NSString * FloorId;

/**
 楼层名称
 */
@property (nonatomic,copy) NSString * FloorName;

/**
 非空	楼层Id
 */
@property (nonatomic,copy) NSString * Id;
/**
 非空	Name
 */
@property (nonatomic,copy) NSString * Name;
/**
 是否可邀请
 */
@property (nonatomic,assign) NSInteger  IsInviting;

/**
 是否为户主(家人/员工，访客邀请)
 */
@property (nonatomic,assign) NSInteger  IsAdmin;

/**
 钥匙数量
 */
@property (nonatomic,assign) NSInteger  KeyCount;

/**
 数据库更新标志
 */
@property (nonatomic,assign) NSInteger Mark;


@property (nonatomic, copy) NSString * keys;
/**
 详细地址
 */
@property (nonatomic,copy) NSString * Address;

@end
