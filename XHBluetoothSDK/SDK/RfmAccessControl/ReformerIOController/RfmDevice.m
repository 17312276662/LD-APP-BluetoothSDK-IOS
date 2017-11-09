//
//  RfmDevice.m
//  RFM_IOCTL
//
//  Created by yeyufeng on 14-10-11.
//  Copyright (c) 2014年 REFORMER. All rights reserved.
//

#import "RfmDevice.h"
#import "RfmConfig.h"

@implementation RfmDevice

- (instancetype)initWithMac:(NSData *)mac peripheral:(CBPeripheral *)peripheral rssi:(NSInteger)rssi ttl:(NSUInteger)ttl
{
    self = [super init];
    if (self)
    {
        self.mac = mac;
        self.peripheral = peripheral;
        self.rssi = rssi;
        self.removeCnt = ttl;
        self.inData = [[NSMutableData alloc] initWithCapacity:60];
        self.nSeq = 1;
    }
    return self;
}

@end
