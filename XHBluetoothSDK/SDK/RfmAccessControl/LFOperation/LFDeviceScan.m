//
//  LFDeviceScan.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "LFDeviceScan.h"
#import <CoreBluetooth/CoreBluetooth.h>
@implementation LFDeviceScan

//初始化SDK, 不使用白名单 新增检查设备功能
- (BOOL)setUpSDK1
{
    if (_rfmQueue == nil)
        _rfmQueue = dispatch_queue_create("rfmQueue", DISPATCH_QUEUE_SERIAL);
    
    // Start up the CBCentralManager
    if (_centralManager == nil)
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_rfmQueue];
    
    return [[RfmSession sharedManager] setupWithWhitelist:nil delegate:self];
}

//初始化SDK, 使用白名单过滤，SDK底层对不在白名单中的设备不进行处理
- (BOOL)setUpSDK2
{
    //白名单
    NSArray *macStrings = @[@"011122334455667788", @"011122334455667789"];
    NSMutableArray *macs = [[NSMutableArray alloc] init];
    for (NSString *macString in macStrings)
    {
        [macs addObject:[macString stringToHexData]];
    }
    return [[RfmSession sharedManager] setupWithWhitelist:macs delegate:self];
}

//检查状态
- (BOOL)basicStateCheck{
    CBManagerState state = *(CBManagerState *)[RfmSession sharedManager].cbState;
    BOOL stateOK = NO;
    //
    if (state == CBManagerStatePoweredOff)
    {
        [self showMessage:@"蓝牙开关未开启" time:5];
    }
    else if (state == CBManagerStateUnsupported)
    {
        [self showMessage:@"手机不支持" time:5];
    }
    else if (state == CBManagerStateUnauthorized)
    {
        [self showMessage:@"用户未授权" time:5];
    }
    else if (state != CBManagerStatePoweredOn)
    {
        [self showMessage:@"蓝牙未就绪" time:5];
    }
    else
    {
        stateOK = YES;
    }
    return stateOK;
    
}

//蓝牙硬件状态改变
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBManagerStatePoweredOn)
        return;
    [self scanDevice];
}

- (void)scanDevice {
    [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];
    NSLog(@"蓝牙开始扫描外设");
}

//初始化SDK
- (void)initSDK{
    [self setUpSDK1];
}

- (NSMutableArray *)showDevice{
    NSArray *devices = [[RfmSession sharedManager] discoveredDevices];
    self.deviceArr = [NSMutableArray arrayWithArray:devices];
   // NSString *string = [[NSString alloc] initWithFormat:@"当前附近有 %d 个门禁", (int)_devices.count];
    
    for (RfmSimpleDevice *device in self.deviceArr)
    {
        _macStr = [device.mac dataToHexString];
        NSLog(@"mac:%@ rssi:%d", _macStr, (int)device.rssi);
        _deviceArr = [NSMutableArray arrayWithObject:_macStr];
    }
    //return _deviceArr;
    [RfmSession sharedManager].delegate = self;
    NSArray *arr = @[@"3237534D4335636151",@"12524585445514",@"32676B6279724D4145"];
    self.deviceArr = [NSMutableArray arrayWithArray:arr];
    return _deviceArr;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    self.isRfmDev = [[RfmSession sharedManager] isRfmDevice:peripheral advertisementData:advertisementData];
    //YYLog(@"isRfmDev(1:YES 0:NO): %d",self.isRfmDev);
}

#pragma mark - 简单提示信息
- (void)showMessage:(NSString *)message time:(NSTimeInterval)time
{
    NSLog(@"%@", message);
   // self.messageLabel.text = message;
    //
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissMessage) object:nil];
    [self performSelector:@selector(dismissMessage) withObject:nil afterDelay:time];
}

- (void)dismissMessage
{
  //  self.messageLabel.text = @"";
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer=nil;
}

@end
