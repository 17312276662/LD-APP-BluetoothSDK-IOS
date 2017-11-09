//
//  RfmDeviceManager.h
//  RFM_IOCTL
//
//  Created by yeyufeng on 14-10-11.
//  Copyright (c) 2014年 REFORMER. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RfmDevice;

///模块底层通讯管理事件
typedef NS_ENUM(NSInteger, RfmDeviceManagerEvent)
{
    RfmDeviceManagerEventPrepareInteraction = 0,//准备交互
    RfmDeviceManagerEventGetCtrlPara,
    RfmDeviceManagerEventCtrlOK,
    RfmDeviceManagerEventSetDeviceKey,
    RfmDeviceManagerEventElevator,          //梯控指令完成
    RfmDeviceManagerEventHallBtn,           //呼梯指令完成
    RfmDeviceManagerEventRetry
};

///模块底层通讯错误类型
typedef NS_ENUM(NSInteger, RfmDeviceManagerError)
{
    RfmDeviceManagerErrorNone = 0,
    RfmDeviceManagerErrorNoDevice,
    RfmDeviceManagerErrorPrepare,
    RfmDeviceManagerErrorDataTrans,
    RfmDeviceManagerErrorDeviceRespError       //设备返回错误
};

///模块底层通讯事件委托协议
@protocol RfmDeviceManagerDelegate <NSObject>
@optional
- (void)rfmDevice:(RfmDevice *)device didFinishedEvent:(RfmDeviceManagerEvent)event object:(id)object error:(RfmDeviceManagerError)error;
@end

///已发现的模块列表变更委托协议
@protocol RfmDeviceManagerDataChangedDelegate <NSObject>
@optional
- (void)rfmDeviceManagerDeviceListDidChanged:(unsigned char)count;
@end

@interface RfmDeviceManager : NSObject

@property (nonatomic, weak) id <RfmDeviceManagerDelegate> delegate;                     ///模块底层通讯事件委托协议
@property (nonatomic, weak) id <RfmDeviceManagerDataChangedDelegate> changedDelegate;   ///已发现的模块列表变更委托协议

///新暴露
@property (nonatomic, strong) CBCentralManager *centralManager;

///是否启用白名单
@property (nonatomic, assign) BOOL usingWhiteList;

///允许连接的外设白名单
@property (nonatomic, strong) NSArray *whiteList;

///范围内存在的外设列表，里面是 RfmDevice 对象
@property (atomic, strong) NSMutableArray *deviceList;      //线程安全

// 对外接口
+ (RfmDeviceManager*)sharedManager;

///开始工作前必要的初始化,并开始工作
- (void)setUpAndStart;

///开始工作，搜索外设
- (void)startWork;

///停止工作
- (void)stopWork;

///发起模块双向通讯的交互准备
- (BOOL)bridgePrepareInteraction:(NSData *)mac;

///控制模块输出口，完成开门，控制灯光等
- (void)bridgeCtrlOutput:(unsigned char)outputID outputTime:(unsigned short)time cdata:(Byte *)cdata;

///设置设备密码
- (void)bridgeSetDeviceKey:(Byte *)cdata;

///控制梯控
- (void)bridgeCtrlElevatorWithKey:(Byte *)devKey;

///控制呼梯
- (void)bridgeCtrlHallBtnWithKey:(Byte *)key;

///停止交互
- (void)bridgeStopInteraction;

@end
