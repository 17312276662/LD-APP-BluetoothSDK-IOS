//
//  KeyCardModel.h
//  Terminus
//
//  Created by Tom on 2017/6/6.
//  Copyright © 2017年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Terminus/TerminusApi.h>



/**
 钥匙分类显示

 - DoorBuilding: 楼栋钥匙
 - DoorTK1: 梯控钥匙
 - DoorBreak: 道闸钥匙
 - DoorVisual: 可视对讲
 - DoorHomeKey: 家庭门锁
 - DoorDefaut: 其他
 - DoorVillage: 小区钥匙
 - DoorTK2: 梯控
 - DoorLandKey: 地锁
 - DoorHotel: 酒店
 - DoorCompany: 公司
 */
typedef NS_ENUM (NSUInteger,KeyShowViewType) {
    DoorBuilding,
    DoorTK1,
    DoorBreak,
    DoorVisual,
    DoorHomeKey,
    DoorDefaut,
    DoorVillage,
    DoorTK2,
    DoorLandKey,
    DoorHotel,
    DoorCompany,

};

@class KeyCardModel;



/**
 @class 道闸分组类
 */
@interface KeyBlueModel : NSObject

/**
 道闸钥匙数组
 */
@property (nonatomic,strong)NSMutableArray * keyModels;

/**
 对应分类
 */
@property (nonatomic,weak) KeyCardModel * cardModel;

/**
 是否本地钥匙
 */
@property (nonatomic,assign) BOOL isLocal;

/**
 是否被刷新
 */
@property (nonatomic,assign) BOOL isRefreshed;


/**
 是否分组
 */
@property (nonatomic,assign) BOOL isGroup;

/**
 最强信号值的mac
 */
@property (nonatomic,copy) NSString * macAdress;

@property (nonatomic,copy) NSString * KeyName;

/**
 分组ID
 */
@property (nonatomic,copy) NSString * gid;

/**
 分组名称
 */
@property (nonatomic,copy) NSString * gidName;

/**
 信号值
 */
@property (nonatomic,copy) NSNumber * RSSI;

/**
 小区（公司）信息
 */
@property (nonatomic,copy) NSString * villageId;

/**
 小区名称
 */
@property (nonatomic,copy) NSString * villageName;

/**
 楼栋ID
 */
@property (nonatomic,copy) NSString * buildingId;

/**
 楼栋名称
 */
@property (nonatomic,copy) NSString * buildingName;

/**
 钥匙类型
 */
@property (nonatomic,assign)BlueDeviceType  keyCate;

/**
 刷新时间
 */
@property (nonatomic,assign) NSTimeInterval refreshTime;

/**
 钥匙ID
 */
@property (nonatomic,copy) NSString * nomalKeyUid;

/**
 是否需要刷新数据信息
 */
@property (nonatomic,assign) BOOL blueModelChange;

/**
 最强信号值刷新的时间搓
 */
@property (nonatomic,assign)NSTimeInterval groupStrongRISSTime;

/**
 分类类型
 */
@property (nonatomic,copy) NSNumber * keyCardTye;



- (BOOL)isShowMoreCard;
@end


@interface KeyCardModel : NSObject
@property (nonatomic,strong)NSMutableArray * blueModels;
@property (nonatomic,copy)NSNumber * cardType;

@property (nonatomic,strong)NSString * villageID;
@property (nonatomic,strong)NSString * villageName;
@property (nonatomic,copy)NSNumber * rssi;
@property (nonatomic,copy)NSString * macAdrss;
@property (nonatomic,assign)BOOL isGroup;
//@property (nonatomic,assign)BOOL moreInfor;


- (int)getKeyMinRssi;



- (KeyShowViewType) getKeyCartType;
@end










