//
//  RfmDevice.h
//  RFM_IOCTL
//
//  Created by yeyufeng on 14-10-11.
//  Copyright (c) 2014年 REFORMER. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral, CBService, CBCharacteristic;

///立方门禁模块模型类
@interface RfmDevice : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *rfmInChar;
@property (nonatomic, strong) CBCharacteristic *rfmOutChar;
//
///模块MAC地址，唯一标识符
@property (nonatomic, strong) NSData *mac;

///模块无线信号强度指示器
@property (nonatomic, assign) NSInteger rssi;

///移除模块计时器，超过一定时间未再次发现该模块，将模块从外设列表中移除
@property (nonatomic, assign) NSUInteger removeCnt;

///模块已经完成交互准备，可进行数据交互的标志
@property (nonatomic, assign) BOOL isConfiguredOK;
//
///接收数据缓冲
@property (nonatomic, strong) NSMutableData *inData;

///从报文包头获取的报文长度
@property (nonatomic, assign) NSInteger inTotalLen;

///发送数据缓冲
@property (nonatomic, strong) NSData *outData;

///本次通讯报文已经发出的长度
@property (nonatomic, assign) NSInteger outDoneLen;

///报文序列号，包识别码
@property (nonatomic, assign) NSUInteger nSeq;

///构造方法
- (instancetype)initWithMac:(NSData *)mac peripheral:(CBPeripheral *)peripheral rssi:(NSInteger)rssi ttl:(NSUInteger)ttl;

@end
