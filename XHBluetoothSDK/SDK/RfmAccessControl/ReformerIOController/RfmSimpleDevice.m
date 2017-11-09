//
//  RfmSimpleDevice.m
//  RfmAccessControlDemo
//
//  Created by yeyufeng on 15/5/22.
//  Copyright (c) 2015年 REFORMER. All rights reserved.
//

#import "RfmSimpleDevice.h"

@implementation RfmSimpleDevice

- (instancetype)initWithMac:(NSData *)mac rssi:(NSInteger)rssi
{
    self = [super init];
    if (self)
    {
        self.mac = mac;
        self.rssi = rssi;
    }
    return self;
}

@end
