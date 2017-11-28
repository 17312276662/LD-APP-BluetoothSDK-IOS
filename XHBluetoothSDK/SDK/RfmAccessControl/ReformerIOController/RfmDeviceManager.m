//
//  RfmDeviceManager.m
//  RFM_IOCTL
//
//  Created by yeyufeng on 14-10-11.
//  Copyright (c) 2014年 REFORMER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "RfmDeviceManager.h"
#import "RfmConfig.h"
#import "RfmDevice.h"
#import "YYCategory.h"

//
#import "zlib.h"

#define RFM_IOCTL_SERVICE_UUID0              @"FDE6"     //立方门禁模块服务号
#define RFM_IOCTL_SERVICE_UUID1              @"FDEB"     //立方门禁模块服务号
#define RFM_IOCTL_CHAR_OUT_UUID             @"FDC7"     //立方门禁模块流传输输出特征值, 手机向模块写数据
#define RFM_IOCTL_CHAR_IN_UUID              @"FDC8"     //立方门禁模块流传输输入特征值, 模块通过indicate向手机发数据
//
#define RFM_DEFAULT_CONNECTABLE_RSSI        -93         //上个版本
//
//协议负载和格式
#define ECI_HEAD_LEN                        5           //协议包头长度
#define ECI_MAX_MTU                         20
#define bMagicNumber                        0xFE
#define bVer                                0x01
//协议命令
#define ECI_req_ctrl                        105         //控制请求
#define ECI_resp_ctrl                       205         //控制应答
#define ECI_req_setDeviceKey                107         //设置设备密码请求
#define ECI_resp_setDeviceKey               207         //设置设备密码应答
#define ECI_req_TK                          108         //梯控指令，0x6C
#define ECI_resp_TK                         208         //0xD0
#define ECI_req_HT                          109         //呼梯指令，0x6D
#define ECI_resp_HT                         209         //0xD1
#define ECI_error_decode                    0xFF        //解密失败，放在命令字段的特殊错误代码
//错误代码
#define ECI_error_none                      0x00
//
#define kConnectFailedAllowedRetryTimes     3           //内部重试

typedef NS_ENUM(NSInteger, RfmCharType)
{
    RfmCharTypeIn = 1,
    RfmCharTypeOut,
};

@interface RfmDeviceManager () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    NSInteger _connectableRssi;
    NSUInteger _connectFailedRetry;
    NSTimer *_scanTimer;
}

@property (nonatomic, strong) dispatch_queue_t rfmQueue;
@property (atomic, strong) RfmDevice *currentDev;

@end

@implementation RfmDeviceManager

#pragma mark - 单例模型，设备管理

static RfmDeviceManager *sharedManager = nil;
+ (RfmDeviceManager*)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//必要的初始化
- (void)setUpAndStart
{
    if (_rfmQueue == nil)
        _rfmQueue = dispatch_queue_create("rfmQueue", DISPATCH_QUEUE_SERIAL);
    if (_deviceList == nil)
        _deviceList = [[NSMutableArray alloc] initWithCapacity:10];
    if (_connectableRssi > -15)
        _connectableRssi = RFM_DEFAULT_CONNECTABLE_RSSI;
    //
    // Start up the CBCentralManager
    if (_centralManager == nil)
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_rfmQueue];     //_rfmQueue
}

//扫描定时器计时时间到
- (void)scanTimerUpdateHandle
{
    if (self.centralManager.state == CBCentralManagerStatePoweredOn)
    {
        [self.centralManager stopScan];
    }
    //
    NSUInteger count1, count2;
    count1 = self.deviceList.count;
    //
    //清理上次扫描没有发现的设备
    for (int i=0; i<self.deviceList.count; i++)
    {
        RfmDevice *dev = self.deviceList[i];
        if ((dev.peripheral.state == CBPeripheralStateDisconnected) && (dev.removeCnt == 0))
        {
            [self.deviceList removeObject:dev];
        }
    }
    //如果变化，通知代理对象
    count2 = self.deviceList.count;
    if ((count1 > 0) && (count2 == 0))
    {
        if ([self.changedDelegate respondsToSelector:@selector(rfmDeviceManagerDeviceListDidChanged:)])
        {
            [self.changedDelegate rfmDeviceManagerDeviceListDidChanged:0];
        }
    }
    //重置标志位
    for (RfmDevice *dev in self.deviceList)
    {
        dev.removeCnt = 0;
    }
    // 发起一轮新的扫描
    if (self.centralManager.state == CBCentralManagerStatePoweredOn)
    {
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:RFM_IOCTL_SERVICE_UUID0], [CBUUID UUIDWithString:RFM_IOCTL_SERVICE_UUID1]]
                                                options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];
    }
}

//
- (void)startWork
{
    // Start up the CBCentralManager
    if (_centralManager.state == CBCentralManagerStatePoweredOn)
        [self scanDevice];
}

//停止工作，停止扫描，并断开所有连接
- (void)stopWork
{
    [self.centralManager stopScan];
    //断开连接
    for (RfmDevice *dev in self.deviceList)
    {
        if (dev.peripheral.state != CBPeripheralStateDisconnected)
        {
            YYLog(@"执行断开连接");
            [self.centralManager cancelPeripheralConnection:dev.peripheral];
        }
    }
    if ([_scanTimer isValid])
    {
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
    YYLog(@"停止扫描并断开已连接的外设");
}

//扫描设备
- (void)scanDevice
{
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:RFM_IOCTL_SERVICE_UUID0], [CBUUID UUIDWithString:RFM_IOCTL_SERVICE_UUID1]]
                                                options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_scanTimer isValid])
        {
            [_scanTimer invalidate];
        }
        _scanTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scanTimerUpdateHandle) userInfo:nil repeats:YES];
    });
    YYLog(@"蓝牙开始扫描外设");
}

//设置允许连接的RSSI阈值
- (BOOL)setConnectableRssiThreshold:(NSInteger)rssi
{
    if (rssi > -15) return false;
    _connectableRssi = rssi;
    return true;
}

//在设备列表里检索设备
- (RfmDevice *)retreveDevice:(CBPeripheral *)peripheral
{
    for (RfmDevice *dev in self.deviceList)
    {
        if (dev.peripheral == peripheral)
        {
            return dev;
        }
    }
    return nil;
}

//在设备列表里检索设备, 根据MAC
- (RfmDevice *)retreveDeviceWithMac:(NSData *)mac
{
    for (RfmDevice *dev in self.deviceList)
    {
        if ([dev.mac isEqualToData:mac])
        {
            return dev;
        }
    }
    return nil;
}

//外设断开时清理
- (void)devDisconnectClear:(CBPeripheral *)peripheral
{
    RfmDevice *dev = [self retreveDevice:peripheral];
    if (dev != nil)
    {
        dev.isConfiguredOK = NO;
        [self transClearInData:dev];
        [self transClearOutData:dev];
    }
}

//保存RSSI
- (void)devSaveRssi:(CBPeripheral *)peripheral rssi:(NSInteger)rssi
{
    RfmDevice *dev = [self retreveDevice:peripheral];
    if (dev != nil)
    {
        dev.rssi = rssi;
        dev.removeCnt = 1;
    }
}

//获得当前操作的设备
- (RfmDevice *)devGetCurrentDevice
{
    NSInteger rssi = -200;
    RfmDevice *currentDev = nil;
    //
    for (RfmDevice *dev in self.deviceList)
    {
        if (dev.rssi > rssi)
        {
            rssi = dev.rssi;
            currentDev = dev;
        }
    }
    //检索完毕，返回
    return currentDev;
}

//保存设备的特征值，便于使用
- (void)saveDevChar:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic type:(RfmCharType)type
{
    RfmDevice *dev = [self retreveDevice:peripheral];
    if (dev != nil)
    {
        if (type == RfmCharTypeIn)
            dev.rfmInChar = characteristic;
        else if (type == RfmCharTypeOut)
            dev.rfmOutChar = characteristic;
    }
}

//改变模块是否已经被正确配置的标志
- (void)setConfiguredOkFlag:(CBPeripheral *)peripheral flag:(BOOL)flag
{
    RfmDevice *dev = [self retreveDevice:peripheral];
    if (dev != nil)     //找到设备对象
    {
        dev.isConfiguredOK = flag;
    }
}

#pragma mark - 对外接口

//蓝牙通讯底层错误处理，通知委托对象出错了
- (void)deviceManagerGenericError:(RfmDeviceManagerError)error
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        if ([self.delegate respondsToSelector:@selector(rfmDevice:didFinishedEvent:object:error:)])
        {
            [self.delegate rfmDevice:_currentDev didFinishedEvent:RfmDeviceManagerEventPrepareInteraction object:nil error:error];
        }
    });
}

//准备交互（含连接，找服务和特征值，订阅特征值建立双向通讯等）
//连接建立后会自动，找服务，找特征值，订阅特征值
- (BOOL)bridgePrepareInteraction:(NSData *)mac
{
    //确定当前操作对象
    if (mac)
    {
        //上层逻辑指定了操作对象，则在发现的设备列表里检索
         _currentDev = [self retreveDeviceWithMac:mac];
    }
    else
    {
        //上层逻辑未指定操作对象，自动选择信号最强的设备
        _currentDev = [self devGetCurrentDevice];
    }
    //
    if (_currentDev == nil)
    {
        return NO;
    }
    YYLog(@"准备通讯，当前操作对象 %@", _currentDev.mac);
    //
    //连接外设
    if (_currentDev.peripheral.state == CBPeripheralStateDisconnected)  //没有连接，则先连接
    {
        [self.centralManager connectPeripheral:_currentDev.peripheral options:nil];
        _connectFailedRetry = kConnectFailedAllowedRetryTimes;
        YYLog(@"$$$$ _connectFailedRetry=%d", (int)_connectFailedRetry);
    }
    else if(_currentDev.peripheral.state == CBPeripheralStateConnecting)
    {
        //暂不处理
    }
    else if((_currentDev.peripheral.state == CBPeripheralStateConnected) && [_currentDev.rfmInChar isNotifying])
    {
        if ([self.delegate respondsToSelector:@selector(rfmDevice:didFinishedEvent:object:error:)])
        {
            [self.delegate rfmDevice:_currentDev didFinishedEvent:RfmDeviceManagerEventPrepareInteraction object:nil error:RfmDeviceManagerErrorNone];
        }
    }
    return YES;
}

+ (void)ulongToByte:(unsigned long)data byte:(Byte *)out
{
    out[0] = data >> 24;
    out[1] = (data >> 16) & 0xFF;
    out[2] = (data >> 8) & 0xFF;
    out[3] = data & 0xFF;
}

//控制输出口
- (void)bridgeCtrlOutput:(unsigned char)outputID outputTime:(unsigned short)time cdata:(Byte *)cdata
{
    if (_currentDev != nil)
    {
        [self reqCtrlOutput:_currentDev outputID:outputID outputTime:time cdata:cdata];
    }
}

//设置设备密码
- (void)bridgeSetDeviceKey:(Byte *)cdata
{
    if (_currentDev != nil)
    {
        [self reqSetDeviceKey:_currentDev cdata:cdata];
    }
}

//控制梯控
- (void)bridgeCtrlElevatorWithKey:(Byte *)key
{
    if (_currentDev != nil)
    {
        [self reqCtrlTK:_currentDev key:key];
    }
}

//控制呼梯
- (void)bridgeCtrlHallBtnWithKey:(Byte *)key
{
    if (_currentDev != nil)
    {
        [self reqCtrlHT:_currentDev key:key];
    }
}

//停止交互
- (void)bridgeStopInteraction
{
    if ((_currentDev.peripheral != nil) && (_currentDev.peripheral.state != CBPeripheralStateDisconnected))
    {
        [self.centralManager cancelPeripheralConnection:_currentDev.peripheral];
    }
    _connectFailedRetry = 0;
    YYLog(@"$$$$ _connectFailedRetry=%d", (int)_connectFailedRetry);
}

#pragma mark - 收发数据管理
 //清理发送数据缓冲
- (void)transClearOutData:(RfmDevice *)dev
{
    dev.outData = nil;
    dev.outDoneLen = 0;
}

//清理接受数据缓冲
- (void)transClearInData:(RfmDevice *)dev
{
    [dev.inData resetBytesInRange:NSMakeRange(0, dev.inData.length)];
    [dev.inData setLength:0];
    dev.inTotalLen = 0;
}

//收到外设数据包处理
- (void)transInPacketDeal:(CBPeripheral *)peripheral data:(NSData *)data
{
    RfmDevice *dev = [self retreveDevice:peripheral];
    if (dev != nil)     //找到设备对象
    {
        Byte *cRevBuf = (Byte *)[data bytes];
        NSUInteger cRevLen = [data length];
        //
        if (dev.inTotalLen == 0)    //接收缓冲区空闲
        {
            if((cRevLen >= ECI_HEAD_LEN) && (cRevBuf[0] == bMagicNumber) && (cRevBuf[1] == bVer))    //是包头
            {
                //获取进行中的这次通讯的完整包长度
                dev.inTotalLen = cRevBuf[2];
                //拷贝数据
                [dev.inData appendData:data];
                //接收缓冲区数据完整性检查
                [self transInPacketCompleteCheck:dev];
            }
            else    //接收缓冲区空，但是收到的数据长度不对或不是包头，忽略
            {
                YYLog(@"接收缓冲区空，但是收到的数据长度不对或不是包头，忽略");
            }
        }
        else    //接收缓冲区已经存在数据
        {
            //拷贝数据
            [dev.inData appendData:data];
            //接收缓冲区数据完整性检查
            [self transInPacketCompleteCheck:dev];
        }
    }
}

//接收缓冲区数据完整性检查
- (void)transInPacketCompleteCheck:(RfmDevice *)dev
{
    if(dev.inData.length >= dev.inTotalLen)
    {
        //YYLog(@"收到完整数据包，mac=%@，包头指明长度=%d，实际长度=%d,内容=%@", dev.mac, (unsigned int)dev.inTotalLen, (unsigned int)dev.inData.length, dev.inData);
        //检查检验值，无
        //
        //解析和处理
        Byte *cRevBuf = (Byte *)[dev.inData bytes];
        unsigned char cmd = cRevBuf[3];
        switch (cmd)
        {
            case ECI_resp_ctrl:         //控制应答
            {
                [self dealCtrlOutput:dev cdata:cRevBuf];
                break;
            }
            case ECI_resp_setDeviceKey:     //设置设备密码应答
            {
                [self dealSetDeviceKey:dev cdata:cRevBuf];
                break;
            }
            case ECI_resp_TK:     //设置设备密码应答
            {
                [self dealCtrlTK:dev cdata:cRevBuf];
                break;
            }
            case ECI_resp_HT:     //设置设备密码应答
            {
                [self dealCtrlHT:dev cdata:cRevBuf];
                break;
            }
            default:
            {
                break;
            }
        }
        //执行清理
        [self transClearInData:dev];
    }
}

//发送数据，low layer
- (void)transOutPacketSend:(RfmDevice *)dev
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected) && (dev.rfmOutChar != nil))
    {
        //先判断是否有数据要发送
        if (dev.outData.length > 0)
        {
            //检查是否已经完成了发送
            if (dev.outDoneLen >= dev.outData.length)
            {
                //已经发送完成, 执行清理
                [self transClearOutData:dev];
            }
            else
            {
                //还有数据要发送
                NSInteger len = dev.outData.length - dev.outDoneLen;
                if (len > ECI_MAX_MTU)
                    len = ECI_MAX_MTU;
                NSData *data = [dev.outData subdataWithRange:NSMakeRange(dev.outDoneLen, len)];
                YYLog(@"即将发送 %@", data);
                [dev.peripheral writeValue:data forCharacteristic:dev.rfmOutChar type:CBCharacteristicWriteWithResponse];
                dev.outDoneLen += len;
            }
        }
    }
}

#pragma mark - 应用协议
//包序列号递增
- (void)updateDevNSeq:(RfmDevice *)dev
{
    dev.nSeq ++;
    if (dev.nSeq == 0)
        dev.nSeq = 1;
}

//收到控制随机数处理
- (void)dealOpenDoorPara:(RfmDevice *)dev cdata:(Byte *)cdata
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected))
    {
        if ([self.delegate respondsToSelector:@selector(rfmDevice:didFinishedEvent:object:error:)])
        {
            if (cdata[ECI_HEAD_LEN] == 0)
            {
                NSData *data = [dev.inData subdataWithRange:NSMakeRange(ECI_HEAD_LEN+1, 4)];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventGetCtrlPara object:data error:RfmDeviceManagerErrorNone];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventGetCtrlPara object:nil error:RfmDeviceManagerErrorDeviceRespError];
                });
            }
        }
    }
}

//输出口控制, outputID:输出口编号, cdata:16字节开门密码
- (void)reqCtrlOutput:(RfmDevice *)dev outputID:(unsigned char)outputID outputTime:(unsigned short)time cdata:(Byte *)cdata
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected))
    {
        unsigned char tmpBuf[60];
        unsigned short len;
        if ((outputID == 1) || (outputID == 8))
            len = 24;
        else
            len = 8;
        //
        //包头
        tmpBuf[0] = bMagicNumber;
        tmpBuf[1] = bVer;
        tmpBuf[2] = len;            //长度
        tmpBuf[3] = ECI_req_ctrl;
        tmpBuf[4] = dev.nSeq;
        //包体
        tmpBuf[ECI_HEAD_LEN] = outputID;
        tmpBuf[ECI_HEAD_LEN+1] = time>>8;
        tmpBuf[ECI_HEAD_LEN+2] = time&0xFF;
        if ((outputID == 1) || (outputID == 8))
        {
            memcpy(tmpBuf+ECI_HEAD_LEN+3, cdata, 16);  //16字节开门动态密码
        }
        //
        dev.outData = [[NSData alloc] initWithBytes:tmpBuf length:len];
        [self transOutPacketSend:dev];
    }
}

- (void)dealCtrlOutput:(RfmDevice *)dev cdata:(Byte *)cdata
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected))
    {
        if ([self.delegate respondsToSelector:@selector(rfmDevice:didFinishedEvent:object:error:)])
        {
            if (cdata[ECI_HEAD_LEN] == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventCtrlOK object:nil error:RfmDeviceManagerErrorNone];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventCtrlOK object:nil error:RfmDeviceManagerErrorDeviceRespError];
                });
            }
        }
    }
}

//设置设备密码
- (void)reqSetDeviceKey:(RfmDevice *)dev cdata:(Byte *)cdata
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected))
    {
        unsigned char tmpBuf[60];
        unsigned short len = 27;
        //
        //包头
        tmpBuf[0] = bMagicNumber;
        tmpBuf[1] = bVer;
        tmpBuf[2] = len;            //长度
        tmpBuf[3] = ECI_req_setDeviceKey;
        tmpBuf[4] = dev.nSeq;
        //包体
        memcpy(tmpBuf+ECI_HEAD_LEN, "RFM-KY", 6);
        memcpy(tmpBuf+ECI_HEAD_LEN+6, cdata, 16);  //16字节设备密码
        //
        dev.outData = [[NSData alloc] initWithBytes:tmpBuf length:len];
        [self transOutPacketSend:dev];
    }
}

- (void)dealSetDeviceKey:(RfmDevice *)dev cdata:(Byte *)cdata
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected))
    {
        if ([self.delegate respondsToSelector:@selector(rfmDevice:didFinishedEvent:object:error:)])
        {
            if (cdata[ECI_HEAD_LEN] == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventSetDeviceKey object:nil error:RfmDeviceManagerErrorNone];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventSetDeviceKey object:nil error:RfmDeviceManagerErrorDeviceRespError];
                });
            }
        }
    }
}

//梯控
- (void)reqCtrlTK:(RfmDevice *)dev key:(Byte *)devKey
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected))
    {
        unsigned char tmpBuf[60];
        unsigned short len = 23;
        //
        //包头
        tmpBuf[0] = bMagicNumber;
        tmpBuf[1] = bVer;
        tmpBuf[2] = len;            //长度
        tmpBuf[3] = ECI_req_TK;
        tmpBuf[4] = dev.nSeq;
        memcpy(tmpBuf+5, "LF", 2);
        memcpy(tmpBuf+7, devKey, 16);
        //
        dev.outData = [[NSData alloc] initWithBytes:tmpBuf length:len];
        [self transOutPacketSend:dev];
    }
}

- (void)dealCtrlTK:(RfmDevice *)dev cdata:(Byte *)cdata
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected))
    {
        if ([self.delegate respondsToSelector:@selector(rfmDevice:didFinishedEvent:object:error:)])
        {
            if (cdata[ECI_HEAD_LEN] == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventElevator object:nil error:RfmDeviceManagerErrorNone];
                });
            }
            else
            {
                NSNumber *code = @(cdata[ECI_HEAD_LEN]);
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventElevator object:code error:RfmDeviceManagerErrorDeviceRespError];
                });
            }
        }
    }
}

//呼梯
- (void)reqCtrlHT:(RfmDevice *)dev key:(Byte *)devKey
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected))
    {
        unsigned char tmpBuf[60];
        unsigned short len = 23;
        //
        //包头
        tmpBuf[0] = bMagicNumber;
        tmpBuf[1] = bVer;
        tmpBuf[2] = len;            //长度
        tmpBuf[3] = ECI_req_HT;
        tmpBuf[4] = dev.nSeq;
        memcpy(tmpBuf+5, "LF", 2);
        memcpy(tmpBuf+7, devKey, 16);
        //
        dev.outData = [[NSData alloc] initWithBytes:tmpBuf length:len];
        [self transOutPacketSend:dev];
    }
}

- (void)dealCtrlHT:(RfmDevice *)dev cdata:(Byte *)cdata
{
    if ((dev.peripheral != nil) && (dev.peripheral.state == CBPeripheralStateConnected))
    {
        if ([self.delegate respondsToSelector:@selector(rfmDevice:didFinishedEvent:object:error:)])
        {
            if (cdata[ECI_HEAD_LEN] == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventHallBtn object:nil error:RfmDeviceManagerErrorNone];
                });
            }
            else
            {
                NSNumber *code = @(cdata[ECI_HEAD_LEN]);
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.delegate rfmDevice:dev didFinishedEvent:RfmDeviceManagerEventHallBtn object:code error:RfmDeviceManagerErrorDeviceRespError];
                });
            }
        }
    }
}


#pragma mark - 蓝牙BLE委托协议
//蓝牙硬件状态改变
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
    [self scanDevice];
}

//不过滤
//是否是SDK允许的设备
- (BOOL)sdkAllowedDevice:(NSData *)mac
{
    if (mac.length != 9)
    {
        return NO;
    }
    return YES;     //符合规则
}

//发现蓝牙外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // 强度-15超过可信范围，认为是异常，拒绝
    if (RSSI.integerValue > -15)
        return;
    
    // 信号强度太弱时拒绝连接
    if (RSSI.integerValue < _connectableRssi)
        return;
    //
    NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
    NSUInteger len = data.length - 2;
    NSData *tmpData = [data subdataWithRange:NSMakeRange(2, len)];  //厂商自定义mac
    //
    RfmDevice *dev = [self retreveDevice:peripheral];   //在已发现的设备列表里检索
    if (dev == nil)     //新外设
    {
        //外销版MAC过滤
        if (![self sdkAllowedDevice:tmpData])
        {
            return;
        }
        // 是新外设
        if(self.usingWhiteList)     //使用白名单
        {
            if([self.whiteList containsObject:tmpData])     //是允许连接的设备
            {
                RfmDevice *dev = [[RfmDevice alloc] initWithMac:tmpData peripheral:peripheral rssi:RSSI.integerValue ttl:1];
                [self.deviceList addObject:dev];

                if ([self.changedDelegate respondsToSelector:@selector(rfmDeviceManagerDeviceListDidChanged:)])
                {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.changedDelegate rfmDeviceManagerDeviceListDidChanged:self.deviceList.count];
                    });
                }
                //YYLog(@"发现新外设, 处于白名单中, Name=%@, MAC=%@, RSSI=%ld", peripheral.name, dev.mac, (long)dev.rssi);
            }
        }
        else    //不使用白名单
        {
            RfmDevice *dev = [[RfmDevice alloc] initWithMac:tmpData peripheral:peripheral rssi:RSSI.integerValue ttl:1];
            [self.deviceList addObject:dev];
            
            if ([self.changedDelegate respondsToSelector:@selector(rfmDeviceManagerDeviceListDidChanged:)])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.changedDelegate rfmDeviceManagerDeviceListDidChanged:self.deviceList.count];
                });
            }
            //YYLog(@"发现新外设, 未使用白名单, Name=%@, MAC=%@, RSSI=%ld", peripheral.name, dev.mac, (long)dev.rssi);
        }
    }
    else    //老外设
    {
        if ((self.usingWhiteList) && (![self.whiteList containsObject:tmpData]))    //不是白名单里允许的设备
        {
            return;
        }
        //不使用白名单 或 使用白名单且是白名单内的设备
        //刷新RSSI，刷新外设存在计时
        dev.rssi = RSSI.integerValue;
        dev.removeCnt = 1;      //标记在新的一轮扫描中发现过
    }
}

//连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    YYLog(@"连接外设失败 %@. (%@)", peripheral, [error localizedDescription]);
    [self deviceManagerGenericError:RfmDeviceManagerErrorPrepare];
    //[self cleanup:peripheral];
}

//连接外设成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //YYLog(@"成功连接外设 MAC=%@", [self retreveDevice:peripheral].mac);
    //
    YYLog(@"成功连接外设");
    
    // 停止扫描
    //[self.centralManager stopScan];
    //YYLog(@"Scanning stopped");
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
   
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:RFM_IOCTL_SERVICE_UUID0],[CBUUID UUIDWithString:RFM_IOCTL_SERVICE_UUID1]]];
}

//与外设的连接断开
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //外设断开执行缓冲和状态清理
    [self devDisconnectClear:peripheral];
    if (error)
    {
        if (error.code == 7)
        {
            YYLog(@"外设主动断开");
            //
            if (_currentDev != nil)
            {
                _currentDev = nil;
            }
        }
        else
        {
            YYLog(@"外设因错误而断开连接，%@，%@", error, peripheral);
            if (_connectFailedRetry > 0)
            {
                YYLog(@"####### 内部重试连接 #######");
                _connectFailedRetry --;
                [self.centralManager connectPeripheral:_currentDev.peripheral options:nil];
                //
                if ([self.delegate respondsToSelector:@selector(rfmDevice:didFinishedEvent:object:error:)])
                {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.delegate rfmDevice:_currentDev didFinishedEvent:RfmDeviceManagerEventRetry object:nil error:RfmDeviceManagerErrorNone];
                    });
                }
            }
            else
            {
                //
                if (_currentDev != nil)
                {
                    _currentDev = nil;
                }
                [self deviceManagerGenericError:RfmDeviceManagerErrorPrepare];
            }
        }
        return;
    }
    //
    if (_currentDev != nil)
    {
        _currentDev = nil;
    }
    YYLog(@"外设正常断开, %@\n-----------------------", peripheral.name);
}

#pragma mark - 蓝牙外设委托协议
//发现外设的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        if (_connectFailedRetry > 0)
        {
            YYLog(@"####### 内部重试 搜索服务时出错，外设=%@，错误=%@", peripheral, [error localizedDescription]);
        }
        else
        {
            YYLog(@"搜索服务时出错，外设=%@，错误=%@", peripheral, [error localizedDescription]);
            [self deviceManagerGenericError:RfmDeviceManagerErrorPrepare];
        }
        return;
    }
    YYLog(@"发现服务");
    // 查找所有的服务中的特征值
    for (CBService *service in peripheral.services)
    {
        if([service.UUID isEqual: [CBUUID UUIDWithString:RFM_IOCTL_SERVICE_UUID0]] || [service.UUID isEqual: [CBUUID UUIDWithString:RFM_IOCTL_SERVICE_UUID1]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:RFM_IOCTL_CHAR_OUT_UUID], [CBUUID UUIDWithString:RFM_IOCTL_CHAR_IN_UUID]] forService:service];
        }
    }
}

//发现外设服务下的特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        if (_connectFailedRetry > 0)
        {
            YYLog(@"####### 内部重试 搜索特征值时出错 #######");
        }
        else
        {
            YYLog(@"搜索特征值时出错，外设=%@，服务=%@，错误=%@", peripheral, service, [error localizedDescription]);
            [self deviceManagerGenericError:RfmDeviceManagerErrorPrepare];
        }
        return;
    }
    //
    for (CBCharacteristic *characteristic in service.characteristics)
    {
         if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:RFM_IOCTL_CHAR_IN_UUID]])
         {
             [self saveDevChar:peripheral characteristic:characteristic type:RfmCharTypeIn];
             //订阅指定的特性
             [peripheral setNotifyValue:YES forCharacteristic:characteristic];
             YYLog(@"发现特征值 RFM_IOCTL_CHAR_IN_UUID, 订阅");
         }
         else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:RFM_IOCTL_CHAR_OUT_UUID]])
         {
             [self saveDevChar:peripheral characteristic:characteristic type:RfmCharTypeOut];
             YYLog(@"发现特征值 RFM_IOCTL_CHAR_OUT_UUID");
         }
    }
}

//外设更新了RSSI值
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error)
    {
        YYLog(@"外设更新RSSI值时出错, %@", [error localizedDescription]);
        [self deviceManagerGenericError:RfmDeviceManagerErrorPrepare];
        return;
    }
    //YYLog(@"外设更新了RSSI值,name=%@,rssi=%@", peripheral.name, peripheral.RSSI);
    //
    //保存RSSI值
    [self devSaveRssi:peripheral rssi:peripheral.RSSI.integerValue];
}

//执行readValueForCharacteristic后被调用或收到外设的 notification/indication 时调用
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        if (_connectFailedRetry > 0)
        {
            YYLog(@"####### 内部重试 didUpdateValueForCharacteristic时出错 #######");
        }
        else
        {
            YYLog(@"读特征值或接收notification/indication时出错,向上层报告错误,%@", [error localizedDescription]);
            [self deviceManagerGenericError:RfmDeviceManagerErrorDataTrans];
        }
        return;
    }
    YYLog(@"收到设备数据, name=%@,data=%@", peripheral.name, characteristic.value);
    //把接收数据追加到接收缓冲区
    [self transInPacketDeal:peripheral data:characteristic.value];
}

//执行写特征值时调用
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //检索该外设
    RfmDevice *dev = [self retreveDevice:peripheral];
    //
    if(error)
    {
        if (dev != nil)
        {
            [self transClearOutData:dev];
        }
        if (_connectFailedRetry > 0)
        {
            YYLog(@"####### 内部重试 didWriteValueForCharacteristic时出错 #######");
        }
        else
        {
            YYLog(@"写特征值时出错,%@", [error localizedDescription]);
            [self deviceManagerGenericError:RfmDeviceManagerErrorDataTrans];
        }
        return;
    }
    if (dev != nil)
    {
        //检查是否还有数据要发送
        [self transOutPacketSend:dev];
    }
}

//该方法是改变订阅状态是被调用，而改变后的订阅值是通过 peripheral:didUpdateValueForCharacteristic:error: 方法来获取的
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        YYLog(@"订阅状态改变异常: %@", error);
        [self deviceManagerGenericError:RfmDeviceManagerErrorPrepare];
        return;
    }
    YYLog(@"订阅状态改变, %@", characteristic.UUID);
    //
    if([characteristic isNotifying])    //是成功订阅
    {
        [self setConfiguredOkFlag:peripheral flag:YES];
        if ([self.delegate respondsToSelector:@selector(rfmDevice:didFinishedEvent:object:error:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.delegate rfmDevice:_currentDev didFinishedEvent:RfmDeviceManagerEventPrepareInteraction object:_currentDev error:RfmDeviceManagerErrorNone];
            });
        }
    }
}

@end
