//
//  TerminusSDK.h
//  Terminus
//
//  Created by tom on 11/15/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HttpSessionBaseManager.h"
#import "TerminusKeyBean.h"


@protocol TerminusSDKDelegate <NSObject>


/**
 *  开门成功
 *
 *  @param keyBean 钥匙对象
 */
- (void)openDoorSuccess:(TerminusKeyBean *)keyBean;

/**
 *  开门失败
 *
 *  @param msg 失败说明
 */
- (void)openDoorErrorMsg:(NSString *)msg;
/**
 *  开门提示密码错误被修改
 *
 *  @param key 钥匙对象
 */
- (void)passwordError:(TerminusKeyBean *)key;



@optional

/*! @brief  重新打开蓝牙回调  */
- (void)OpenBlueOn;

/*! @brief  蓝牙已经关闭  */
- (void)CloseBunOff;

/**
 *  进入钥匙正在开门状态
 *
 *  @param key 钥匙实体
 */
- (void)openKeyLoading:(TerminusKeyBean *)key;

@end


@protocol TerminusSDKDataSourceDelegate <NSObject>

@required


/**
 返回当前开锁有效钥匙 1s 回调一次

 @param keys 当前钥匙周围有效钥匙数组
 */
- (void)terminsSDKSearchedKeys:(NSMutableArray *)keys;

@end





@interface TerminusSDK : NSObject


/**
 当前应用的AppKey
 */
@property (nonatomic,readonly,copy) NSString * registerKey;

/**
 开锁回调
 */
@property (nonatomic,weak)id<TerminusSDKDelegate> delegate;

/**
 当前搜索回调
 */
@property (nonatomic,weak)id<TerminusSDKDataSourceDelegate> dataSourceDelegate;




/**
 注册第三方应用，第三方APP启动时调用，初始化SDK，如果处于已登录状态，同时会同步用户钥匙列表
 
 @param appKey 特斯联提供的APPKEY
 */
+ (void)registerApp:(NSString * )appKey;



/**
 整个蓝牙的单利

 @return 返回蓝牙操作对象
 */
+(TerminusSDK*)defaultTerminus;

/**
 测试环境切换
 */
+(void)enableDebugMode;

/**
 获取当前appkey 是否有效

 @return 当前的appkeys是否有效
 */
+(BOOL)getAPPKEYUseable;

/**
 第三方APP成功获取特斯联Token后调用，会同步一次用户钥匙列表（该方法只在从特斯联服务器获取到token 调用一次）

 @param token 特斯联服务器返回的Token
 @return 设置token 成功
 */
+ (BOOL)login:(NSString *)token;

/**
 退出登录需要清理当前用户钥匙信息
 */
+ (void)logout;

/**
 实现在 展示当前周围有效钥匙列表的VC的viewWillAppear 中实现

 @param VC 钥匙列表ViewController
 */
+ (void)viewWillAppear:(UIViewController *)VC;
/**
 实现在 展示当前周围有效钥匙列表的VC的viewWillDisappear 中实现
 
 @param VC 钥匙列表ViewController
 */
+ (void)viewWillDisappear:(UIViewController *)VC;



#pragma mark - 钥匙相关


/**
 扫描周围设备 在 进入viewWillAppear 中已默认扫描
 */
- (void)startScan;

/**
 停止扫描 实现了 viewWillDisappear 中 已实现停止
 */
- (void)stopScan;


/**
 设置是否一直后台搜索

 @param set 是否进行后台搜索设置
 */
+ (void)openBackgroundSearch:(BOOL)set;

/**
 返回当前是否设置为后台搜索

 @return Yes or No
 */
+ (BOOL)isBackgroundSearch;

/**
 后台搜索 获取当前周围能使用设备(当且仅当开启后台搜索)
 @return [terminuskeybean]
 */
+(NSArray *)getCanUserOpenKeys;

/**
 获取用户的钥匙列表

 @param successBlock 成功从服务器中获取到钥匙
 @param errorBlock 获取钥匙中出现错误
 */
- (void)terminusGetUserKeySuccess:(TSLSuccessBlock)successBlock errorBlock:(TSLErrorBlock)errorBlock;

/**
 钥匙实体进行开门

 @param model 钥匙实体 @see TerminusKeyBean
 */
- (void)openDoor:(TerminusKeyBean *)model;

/**
 钥匙对象密码错误 修正密码后去开门

 @param password 新密码
 @param key 钥匙对象 @see TerminusKeyBean
 */
- (void)changePwd:(NSString *)password keyBean:(TerminusKeyBean *)key;

/**
 指定keybean是否正在开锁

 @param model 钥匙实体
 @return 是否在开门
 */
- (BOOL)isOpening:(TerminusKeyBean *)model;

/**
 取消开锁

 @param model 钥匙对象
 */
- (void)cancelOpenDoor:(TerminusKeyBean *)model;

/**
 获取当前数据库中所有钥匙数据

 @return 返回钥匙实体数组
 */
- (NSArray *)getAllKeys;

/**
 获取当前钥匙的小区信息

 @return 返回当前用户所有的小区信息实体数组
 */
- (NSArray *)getAllVillageInfor;

/**
 获取当前钥匙的楼栋信息

 @return 返回当前用户所有的楼栋信息实体数组
 */
- (NSArray *)getAllVillageBuildingInfor;




#pragma mark -
#pragma mark - Ibeacon 相关

/**
 ibeacon 是否有效

 @return YES OR NO
 */
+ (BOOL)isUseAbleIbeacon;

/**
 设置成 贴近开门
 */
+ (void)immediateOpen;

/**
 设置附近开门
 */
+ (void)nearOpen;

#pragma mark -
#pragma mark - 用户相关

/**
 获取当前使用的token。

 @return 特斯联token，若未登录则为空。
 */
+ (NSString *)fetchUserToken;

/**
 获取特斯联SDK 版本

 @return 返回SDK版本
 */
+ (NSString *)getAPIVersion;

@end

/*! @remark 成功获取钥匙数据 obj 为钥匙实体数组 */
extern NSString * const TerminusDidGetKeyNotification;
/*! @remark 成功设置Token */
extern NSString * const TerminusDidLoginNotification;
/*! @remark 调用退出登录 */
extern NSString * const TerminusDidLogoutNotification;
/*! @remark 将要进行开锁 */
extern NSString * const DDNotificationOPENKEY;
/*! @remark 开锁失败 */
extern NSString * const DDNotificationOpenDoorFailed;
/*! @remark 开锁成功 */
extern NSString * const DDNotificationOpenDoorSuccess;
