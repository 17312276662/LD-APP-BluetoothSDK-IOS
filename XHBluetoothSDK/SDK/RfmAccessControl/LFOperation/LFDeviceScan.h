//
//  LFDeviceScan.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>
//引入立方门禁模块SDK头文件
#import "RfmAccessControl.h"

//其他头文件
#import "NSData+YYExtend.h"
#import "NSString+YYExtend.h"
@interface LFDeviceScan : NSObject <CBCentralManagerDelegate,RfmSessionDelegate>
@property (nonatomic, strong) NSMutableArray *deviceArr;
@property (nonatomic, assign) int32_t taskFlag;
@property (nonatomic ,strong)  NSString *macStr;
@property (nonatomic, strong) dispatch_queue_t rfmQueue;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic,assign) BOOL isRfmDev;
@property (nonatomic,strong) NSTimer *timer;
//初始化SDK
- (void)initSDK;
//扫描设备
- (NSArray *)showDevice;
@end
