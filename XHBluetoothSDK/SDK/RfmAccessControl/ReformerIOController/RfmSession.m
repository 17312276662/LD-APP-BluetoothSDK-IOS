//
//  RfmSession.m
//  RFM_IOCTL
//
//  Created by yeyufeng on 14-10-15.
//  Copyright (c) 2014年 REFORMER. All rights reserved.
//

#import "RfmSession.h"
#import "RfmConfig.h"
#import "YYCategory.h"

#import "RfmDevice.h"
#import "RfmSimpleDevice.h"
#import "RfmDeviceManager.h"
//
#import "desDLL.h"

#import <CoreBluetooth/CoreBluetooth.h>
//
//库版本号
#define kRfmSessionLibraryVersion       @"J1.0.0"
#define kRfmUseOfflineAuth              YES         //是否使用离线认证模式，布尔值
#define kDeviceKeyStringLen             32

//与设备会话状态
typedef NS_ENUM(NSInteger, RfmSessionState)
{
    RfmSessionStateIdle = 0,
    RfmSessionStateBusy
};

//const static uint8_t keyDemo[16] = {0x17,0xDB,0x42,0x7F,0x06,0x33,0x95,0x02,0xA4,0x9F,0x15,0x45,0x5A,0x13,0xE6,0x81};

@interface RfmSession () <RfmDeviceManagerDelegate, RfmDeviceManagerDataChangedDelegate>
{
    RfmSessionState _state;
    RfmSessionEvent _currentTask;
    NSTimer *_waitDeviceTimer;
    NSTimer *_stabilityTestTime;
    //
    NSData *_currentMac;
    NSData *_deviceKey;
    uint16_t _outputAcitveTime;
    NSMutableArray *_params;
}

//蓝牙通讯统计
@property (nonatomic, assign) NSUInteger statistTotal;
@property (nonatomic, assign) NSUInteger statistSuccess;
@property (nonatomic, assign) NSUInteger statistFailed;
@property (nonatomic, assign) NSUInteger statistRetry;

@end

@implementation RfmSession

#pragma mark - 单例模型和初始化
static RfmSession *sharedManager = nil;
+ (RfmSession*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (NSString *)libVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return [[NSString alloc] initWithFormat:@"J%@", version];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        RfmDeviceManager *deviceManager = [RfmDeviceManager sharedManager];
        deviceManager.delegate = self;
        deviceManager.changedDelegate = self;
        _params = [[NSMutableArray alloc] init];
    }
    return self;
}

- (CBCentralManagerState)cbState
{
    return [RfmDeviceManager sharedManager].centralManager.state;
}

#pragma mark - 设备通讯等待定时器
- (void)startWaitDeviceTimer
{
    if([_waitDeviceTimer isValid])
    {
        [_waitDeviceTimer invalidate];
    }
    _waitDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(waitDeviceTimeoutHandler) userInfo:nil repeats:NO];
}

- (void)stopWaitDeviceTimer
{
    if ([_waitDeviceTimer isValid])
    {
        [_waitDeviceTimer invalidate];
    }
}

- (void)waitDeviceTimeoutHandler
{
    YYLog(@"设备应答超时,停止交互");
    [[RfmDeviceManager sharedManager] bridgeStopInteraction];
    [self setSessionStateIdle];
    //
    if ([self.delegate respondsToSelector:@selector(rfmSessionDidFinishedEvent:mac:error:)])
    {
        [self.delegate rfmSessionDidFinishedEvent:_currentTask mac:_currentMac error:RfmSessionErrorDeviceTimeOut];
    }
}

#pragma mark - 对外接口
//初始化
- (BOOL)setupWithWhitelist:(NSArray *)whitelist delegate:(id<RfmSessionDelegate>)delegate
{
    [self refreshWhitelist:whitelist];
    [[RfmDeviceManager sharedManager] setUpAndStart];
    self.delegate = delegate;
    //
    return YES;
}

- (void)refreshWhitelist:(NSArray *)whitelist
{
    RfmDeviceManager *manager = [RfmDeviceManager sharedManager];
    if (whitelist)
    {
        manager.whiteList = whitelist;
        manager.usingWhiteList = YES;
    }
    else
    {
        manager.usingWhiteList = NO;
    }
}

//查询已经发现的设备
- (NSArray *)discoveredDevices
{
    RfmDeviceManager *manager = [RfmDeviceManager sharedManager];
    if (manager.deviceList.count == 0)
    {
        return nil;
    }
    NSMutableArray *simpleDevices = [[NSMutableArray alloc] init];
    for (RfmDevice *device in manager.deviceList)
    {
        RfmSimpleDevice *simpleDevice = [[RfmSimpleDevice alloc] initWithMac:device.mac rssi:device.rssi];
        [simpleDevices addObject:simpleDevice];
    }
    return simpleDevices;
}

//开门
- (BOOL)openDoorWithMac:(NSData *)mac deviceKey:(NSString *)deviceKey outputActiveTime:(uint16_t)time
{
    if ((_state == RfmSessionStateIdle) && (mac != nil) && (deviceKey.length == kDeviceKeyStringLen))
    {
        _state = RfmSessionStateBusy;
        _statistTotal ++;
        //准备通讯（含连接，找服务和特征值，订阅特征值建立双向通讯等）
        _currentTask = RfmSessionEventOpenDoor;
        _outputAcitveTime = time;
        _deviceKey = [deviceKey stringToHexData];
        if ([[RfmDeviceManager sharedManager] bridgePrepareInteraction:mac])
        {
            [self startWaitDeviceTimer];
            return YES;
        }
        //
        _state = RfmSessionStateIdle;
        return NO;
    }
    else
    {
        return NO;
    }
}

//开门，带检查蓝牙状态
//0=已接受，1=当前正处于操作门禁模块的会话中，2=输入参数异常，3=设备不支持低功耗蓝牙模式，4=用户未授权使用蓝牙，5=蓝牙开关未开启，6=指定的设备已经消失，7=其他蓝牙状态异常
- (RfmActionError)openDoorCheckedWithMac:(NSData *)mac deviceKey:(NSString *)deviceKey outputActiveTime:(uint16_t)time isRfmDevice:(BOOL)isRfm
{
    if (isRfm == YES)
    {
        if ((mac.length == 0) || (deviceKey.length != kDeviceKeyStringLen))
        {
            return RfmActionErrorParam;   //输入参数异常
        }
        if (_state != RfmSessionStateIdle)
        {
            return RfmActionErrorBusy;
        }
        //检查蓝牙底层状态
        CBCentralManagerState cbState = [RfmDeviceManager sharedManager].centralManager.state;
        if (cbState == CBCentralManagerStatePoweredOn)
        {
            _state = RfmSessionStateBusy;
            _statistTotal ++;
            //
            //准备通讯（含连接，找服务和特征值，订阅特征值建立双向通讯等）
            _currentTask = RfmSessionEventOpenDoor;
            _outputAcitveTime = time;
            _deviceKey = [deviceKey stringToHexData];
            if ([[RfmDeviceManager sharedManager] bridgePrepareInteraction:mac])
            {
                [self startWaitDeviceTimer];
            }
            else
            {
                _state = RfmSessionStateIdle;
                return RfmActionErrorNoDevice;   //指定的设备已经消失
            }
        }
        else if (cbState == CBCentralManagerStateUnsupported)
        {
            return RfmActionErrorUnsupported;
        }
        else if (cbState == CBCentralManagerStateUnauthorized)
        {
            return RfmActionErrorUnauthorized;
        }
        else if (cbState == CBCentralManagerStatePoweredOff)
        {
            return RfmActionErrorPoweredOff;
        }
        else
        {
            return RfmActionErrorOther;
        }
        //
        return RfmActionErrorNone;   //正常返回
    }
    return RfmActionErrorOther;
}

//设置设备密码
- (RfmActionError)setDeviceKey:(NSData *)mac newKey:(NSString *)newKey
{
    if ((mac.length == 0) || (newKey.length != kDeviceKeyStringLen))
    {
        return RfmActionErrorParam;   //输入参数异常
    }
    if (_state != RfmSessionStateIdle)
    {
        return RfmActionErrorBusy;
    }
    //检查蓝牙底层状态
    CBCentralManagerState cbState = [RfmDeviceManager sharedManager].centralManager.state;
    if (cbState == CBCentralManagerStatePoweredOn)
    {
        _state = RfmSessionStateBusy;
        _statistTotal ++;
        //
        //准备通讯（含连接，找服务和特征值，订阅特征值建立双向通讯等）
        _currentTask = RfmSessionEventSetDeviceKey;
        _deviceKey = [newKey stringToHexData];
        if ([[RfmDeviceManager sharedManager] bridgePrepareInteraction:mac])
        {
            [self startWaitDeviceTimer];
        }
        else
        {
            _state = RfmSessionStateIdle;
            return RfmActionErrorNoDevice;   //指定的设备已经消失
        }
    }
    else if (cbState == CBCentralManagerStateUnsupported)
    {
        return RfmActionErrorUnsupported;
    }
    else if(cbState == CBCentralManagerStateUnauthorized)
    {
        return RfmActionErrorUnauthorized;
    }
    else if(cbState == CBCentralManagerStatePoweredOff)
    {
        return RfmActionErrorPoweredOff;
    }
    else
    {
        return RfmActionErrorOther;
    }
    //
    return RfmActionErrorNone;   //正常返回
}

- (RfmActionError)openElevator:(NSData *)mac deviceKey:(NSString *)deviceKey code:(NSString *)code floor:(uint8_t)floor
{
    if (mac.length == 0)
    {
        return RfmActionErrorParam;   //输入参数异常
    }
    if (_state != RfmSessionStateIdle)
    {
        return RfmActionErrorBusy;
    }
    //检查蓝牙底层状态
    CBManagerState cbState = [RfmDeviceManager sharedManager].centralManager.state;
    if (cbState == CBCentralManagerStatePoweredOn)
    {
        _state = RfmSessionStateBusy;
        _statistTotal ++;
        //
        //准备通讯（含连接，找服务和特征值，订阅特征值建立双向通讯等）
        _deviceKey = [deviceKey stringToHexData];
        if ([[RfmDeviceManager sharedManager] bridgePrepareInteraction:mac])
        {
            _currentTask = RfmSessionEventElevator;
            //暂存传递进来的参数
            [_params removeAllObjects];
            [_params addObject:code];
            [_params addObject:@(floor)];
            [self startWaitDeviceTimer];
        }
        else
        {
            _state = RfmSessionStateIdle;
            return RfmActionErrorNoDevice;   //指定的设备已经消失
        }
    }
    else if (cbState == CBCentralManagerStateUnsupported)
    {
        return RfmActionErrorUnsupported;
    }
    else if (cbState == CBCentralManagerStateUnauthorized)
    {
        return RfmActionErrorUnauthorized;
    }
    else if (cbState == CBCentralManagerStatePoweredOff)
    {
        return RfmActionErrorPoweredOff;
    }
    else
    {
        return RfmActionErrorOther;
    }
    //
    return RfmActionErrorNone;   //正常返回
}

- (RfmActionError)openHallBtn:(NSData *)mac deviceKey:(NSString *)deviceKey code:(NSString *)code dir:(HallBtnDir)dir
{
    if (mac.length == 0)
    {
        return RfmActionErrorParam;   //输入参数异常
    }
    if (_state != RfmSessionStateIdle)
    {
        return RfmActionErrorBusy;
    }
    //检查蓝牙底层状态
    CBManagerState cbState = [RfmDeviceManager sharedManager].centralManager.state;
    if (cbState == CBCentralManagerStatePoweredOn)
    {
        _state = RfmSessionStateBusy;
        _statistTotal ++;
        //
        //准备通讯（含连接，找服务和特征值，订阅特征值建立双向通讯等）
        _deviceKey = [deviceKey stringToHexData];
        if ([[RfmDeviceManager sharedManager] bridgePrepareInteraction:mac])
        {
            _currentTask = RfmSessionEventHallBtn;
            //暂存传递进来的参数
            [_params removeAllObjects];
            [_params addObject:code];
            [_params addObject:@(dir)];
            [self startWaitDeviceTimer];
        }
        else
        {
            _state = RfmSessionStateIdle;
            return RfmActionErrorNoDevice;   //指定的设备已经消失
        }
    }
    else if (cbState == CBCentralManagerStateUnsupported)
    {
        return RfmActionErrorUnsupported;
    }
    else if (cbState == CBCentralManagerStateUnauthorized)
    {
        return RfmActionErrorUnauthorized;
    }
    else if (cbState == CBCentralManagerStatePoweredOff)
    {
        return RfmActionErrorPoweredOff;
    }
    else
    {
        return RfmActionErrorOther;
    }
    //
    return RfmActionErrorNone;   //正常返回
}

#pragma mark - 是否是立方的设备
- (BOOL)isRfmDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData
{
    //获取设备的mac
    NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
    //获取设备的mac的前两个字节
    Byte tmp[2];
    [data getBytes:tmp range:NSMakeRange(0, 2)];
    if (tmp[0] == 0x88 && tmp[1] == 0x88) {
        return YES;
    }
    return NO;
}

#pragma mark - 获取厂商的设备mac
- (NSData *)getPeripheralMacWithAdvertisementData:(NSDictionary *)advertisementData
{
    NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
    NSUInteger len = data.length - 2;
    NSData *mac = [data subdataWithRange:NSMakeRange(2, len)];
    return mac;
}

#pragma mark - 开门
- (RfmActionError)openDoorWithMac:(NSData *)mac andPassword:(NSString *)password timeout:(uint16_t)time delegate:(id<RfmSessionDelegate>)delegate
{
    if ([self setupWithWhitelist:nil delegate:delegate]) {
        
        __block BOOL isRfmDevice = NO;
        
        __block RfmActionError error = RfmActionErrorNone;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *arr = [self discoveredDevices];
            for (NSInteger i = 0; i < arr.count; i++) {
                RfmSimpleDevice *dev = arr[i];
                if ([mac isEqualToData:dev.mac]) {
                    isRfmDevice = YES;
                    YYLog(@"设备存在且已被搜索");
                    error = [self openDoorCheckedWithMac:mac deviceKey:password outputActiveTime:time isRfmDevice:isRfmDevice];
                    break;
                }
            }
            if (isRfmDevice == NO) {
                error = RfmActionErrorNoDevice;
            }
        });
        return error;
    }
    return nil;
}

#pragma mark -
//开门，外销版不提供
- (BOOL)openDoor
{
    //return [self openDoorWithMac:nil outputActiveTime:3];
    return NO;
}

//稳定性测试
- (void)testStability
{
    if ([_stabilityTestTime isValid])
    {
        [_stabilityTestTime invalidate];
    }
    else
    {
        [self openDoor];
        _stabilityTestTime = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(stabilityTestTimeoutHandler) userInfo:nil repeats:YES];
    }
}

- (void)stabilityTestTimeoutHandler
{
    [self openDoor];
}

#pragma mark - 状态机
- (void)setSessionStateIdle
{
    if (_state != RfmSessionStateIdle)
    {
        _state = RfmSessionStateIdle;
    }
}

//停止与设备的交互
- (void)stopDeviceInteraction
{
    [self stopWaitDeviceTimer];
    [[RfmDeviceManager sharedManager] bridgeStopInteraction];
    [self performSelector:@selector(setSessionStateIdle) withObject:nil afterDelay:0.5];
}

#pragma mark - 委托协议，RfmDeviceManagerDelegate
- (void)rfmDevice:(RfmDevice *)device didFinishedEvent:(RfmDeviceManagerEvent)event object:(id)object error:(RfmDeviceManagerError)error
{
    if (error == RfmDeviceManagerErrorNone)     //无错误
    {
        switch (event)
        {
            case RfmDeviceManagerEventPrepareInteraction:
            {
                YYLog(@"session, 完成交互准备");
                //
                RfmDevice *device = object;
                _currentMac = device.mac;
                //
                if (_currentTask == RfmSessionEventSetDeviceKey)
                {
                    Byte key[16];
                    [_deviceKey getBytes:key length:16];
                    [self startWaitDeviceTimer];    //重新开始计时
                    [[RfmDeviceManager sharedManager] bridgeSetDeviceKey:key];
                }
                else if (_currentTask == RfmSessionEventOpenDoor)
                {
                    [self startWaitDeviceTimer];    //重新开始计时
                    //发送开门
                    NSData *data = [self.class calcPassword:_currentMac key:_deviceKey];
                    Byte key[16];
                    [data getBytes:key length:16];
                    [[RfmDeviceManager sharedManager] bridgeCtrlOutput:1 outputTime:_outputAcitveTime cdata:key];  //控制输出
                }
                else if (_currentTask == RfmSessionEventElevator)
                {
                    [self startWaitDeviceTimer];    
                    NSData *data = [self.class calcPhoneCode:_params[0] floot:[_params[1] intValue] key:_deviceKey];
                    Byte key[16];
                    [data getBytes:key length:16];
                    [[RfmDeviceManager sharedManager] bridgeCtrlElevatorWithKey:key];
                }
                else if (_currentTask == RfmSessionEventHallBtn)
                {
                    [self startWaitDeviceTimer];
                    NSData *data = [self.class calcPhoneCode:_params[0] floot:[_params[1] intValue] key:_deviceKey];
                    Byte key[16];
                    [data getBytes:key length:16];
                    [[RfmDeviceManager sharedManager] bridgeCtrlHallBtnWithKey:key];
                }
                
                break;
            }
            case RfmDeviceManagerEventCtrlOK:
            {
                YYLog(@"session，完成输出口控制，%d", [object unsignedCharValue]);
                [self stopWaitDeviceTimer];
                [[RfmDeviceManager sharedManager] bridgeStopInteraction];
                [self performSelector:@selector(setSessionStateIdle) withObject:nil afterDelay:1.0];
                //
                _statistSuccess ++;
                YYLog(@"总次数%ld, 成功%ld, 报错%ld, 内部重试%ld", (unsigned long)_statistTotal, (unsigned long)_statistSuccess, (unsigned long)_statistFailed, (unsigned long)_statistRetry);
                
                //通知委托对象已经开门成功
                if ([self.delegate respondsToSelector:@selector(rfmSessionDidFinishedEvent:mac:error:)])
                {
                    [self.delegate rfmSessionDidFinishedEvent:_currentTask mac:_currentMac error:RfmSessionErrorNone];
                }
                break;
            }
            case RfmDeviceManagerEventSetDeviceKey:
            {
                [self stopWaitDeviceTimer];
                [[RfmDeviceManager sharedManager] bridgeStopInteraction];
                [self performSelector:@selector(setSessionStateIdle) withObject:nil afterDelay:1.0];
                
                //通知委托对象设置设备密码成功
                if ([self.delegate respondsToSelector:@selector(rfmSessionDidFinishedEvent:mac:error:)])
                {
                    [self.delegate rfmSessionDidFinishedEvent:_currentTask mac:_currentMac error:RfmSessionErrorNone];
                }
                break;
            }
            case RfmDeviceManagerEventElevator:
            {
                [self stopWaitDeviceTimer];
                [[RfmDeviceManager sharedManager] bridgeStopInteraction];
                [self performSelector:@selector(setSessionStateIdle) withObject:nil afterDelay:1.0];
                
                //通知委托对象设置设备密码成功
                if ([self.delegate respondsToSelector:@selector(rfmSessionDidFinishedEvent:mac:error:)])
                {
                    [self.delegate rfmSessionDidFinishedEvent:_currentTask mac:_currentMac error:RfmSessionErrorNone];
                }
                break;
            }
            case RfmDeviceManagerEventHallBtn:
            {
                [self stopWaitDeviceTimer];
                [[RfmDeviceManager sharedManager] bridgeStopInteraction];
                [self performSelector:@selector(setSessionStateIdle) withObject:nil afterDelay:1.0];
                
                //通知委托对象设置设备密码成功
                if ([self.delegate respondsToSelector:@selector(rfmSessionDidFinishedEvent:mac:error:)])
                {
                    [self.delegate rfmSessionDidFinishedEvent:_currentTask mac:_currentMac error:RfmSessionErrorNone];
                }
                break;
            }
            case RfmDeviceManagerEventRetry:
            {
                _statistRetry ++;
                break;
            }
            default:
                break;
        }
    }
    else    //蓝牙通讯过程发生错误
    {
        [self stopDeviceInteraction];   //停止与设备的交互
        //
        switch (error)
        {
            case RfmDeviceManagerErrorNoDevice:     //当前版本已经不会调用此异常，通过另外的方式实现
            {
                if ([self.delegate respondsToSelector:@selector(rfmSessionDidFinishedEvent:mac:error:)])
                {
                    [self.delegate rfmSessionDidFinishedEvent:_currentTask mac:_currentMac error:RfmSessionErrorNoDevice];
                }
                break;
            }
            case RfmDeviceManagerErrorPrepare:
            case RfmDeviceManagerErrorDataTrans:
            {
                //统计
                 _statistFailed ++;
                 YYLog(@"总次数%ld, 成功%ld, 报错%ld, 内部重试%ld", (unsigned long)_statistTotal, (unsigned long)_statistSuccess, (unsigned long)_statistFailed, (unsigned long)_statistRetry);
                //
                if ([self.delegate respondsToSelector:@selector(rfmSessionDidFinishedEvent:mac:error:)])
                {
                    [self.delegate rfmSessionDidFinishedEvent:_currentTask mac:_currentMac error:RfmSessionErrorDeviceInteraction];
                }
                break;
            }
            case RfmDeviceManagerErrorDeviceRespError:
            {
                if ([self.delegate respondsToSelector:@selector(rfmSessionDidFinishedEvent:mac:error:)])
                {
                    [self.delegate rfmSessionDidFinishedEvent:_currentTask mac:_currentMac error:RfmSessionErrorDeviceRespError];
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - 委托协议，RfmDeviceManagerDataChangedDelegate
- (void)rfmDeviceManagerDeviceListDidChanged:(unsigned char)count
{
    NSMutableArray *simpleDeives;
    //
    RfmDeviceManager *deviceManager = [RfmDeviceManager sharedManager];
    if (deviceManager.deviceList.count == 0)
    {
        simpleDeives = nil;
    }
    else
    {
        simpleDeives = [[NSMutableArray alloc] init];
        NSArray *tmp = [deviceManager.deviceList copy];
        for (RfmDevice *dev in tmp)
        {
            RfmSimpleDevice *simpleDevice = [[RfmSimpleDevice alloc] initWithMac:dev.mac rssi:dev.rssi];
            [simpleDeives addObject:simpleDevice];
        }
    }
    if ([self.delegate respondsToSelector:@selector(rfmSessionDetectedDevicesChanged:)])
    {
        [self.delegate rfmSessionDetectedDevicesChanged:simpleDeives];
    }
}

#pragma mark  Tool，计算开门密码
+ (NSData *)calcPassword:(NSData *)mac key:(NSData *)key
{
    //加密使用的实际密钥
    Byte keyBuf[16];
    [key getBytes:keyBuf length:16];
    //
    //明文数据
    Byte dataIn[16];
    Byte macBuf[9];
    [mac getBytes:macBuf length:9];
    memset(dataIn, 0, 16);
    memcpy(dataIn, macBuf, 5);
    memcpy(dataIn+8, macBuf+5, 4);
    //
    //计算密文
    Byte dataOut[16];
    DES3(keyBuf, dataIn, dataOut, 0);       //3DES加密
    DES3(keyBuf, dataIn+8, dataOut+8, 0);
    NSData *result = [NSData dataWithBytes:dataOut length:16];
    //YYLog(@"密文 = %@", result);
    return result;
}

+ (NSData *)calcPhoneCode:(NSString *)code floot:(uint8_t)floot key:(NSData *)key
{
    //加密使用的实际密钥
    Byte keyBuf[16];
    [key getBytes:keyBuf length:16];
    //
    //明文数据
    Byte dataIn[16];
    
    Byte tmBuff0[4];
    tmBuff0[0] = 0x41;
    tmBuff0[1] = 0x41;
    tmBuff0[2] = 0x41;
    tmBuff0[3] = 0x41;
    
    Byte codeBuff[6];
    NSString *codeFixed;
    if (code.length % 2 != 0)
    {
        codeFixed = [@"0" stringByAppendingString:code];
    }
    else
    {
        codeFixed = code;
    }
    NSData *codeData = codeFixed.stringToHexData;
    [codeData getBytes:codeBuff length:6];  //手机号
    
    Byte flootBuff[1];
    flootBuff[0] = floot;
    
    memset(dataIn, 0, 16);
    memcpy(dataIn, tmBuff0, 4);
    memcpy(dataIn+4, codeBuff, 6);
    memcpy(dataIn+11, flootBuff, 1);
    NSData *result0000 = [NSData dataWithBytes:dataIn length:16];
    YYLog(@"明文 = %@", result0000);
    //
    //计算密文
    Byte dataOut[16];
    DES3(keyBuf, dataIn, dataOut, 0);       //3DES加密
    DES3(keyBuf, dataIn+8, dataOut+8, 0);
    NSData *result = [NSData dataWithBytes:dataOut length:16];
    YYLog(@"密文 = %@", result);
    return result;
}

@end


