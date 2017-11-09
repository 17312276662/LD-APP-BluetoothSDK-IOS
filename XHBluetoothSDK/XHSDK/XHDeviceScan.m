//
//  XHDeviceScan.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "XHDeviceScan.h"
@implementation XHDeviceScan
- (void)initSDK{
    Class class = NSClassFromString([NSString stringWithFormat:@"%@DeviceScan",@"AAAA"]);
    NSObject *scan = [[class alloc] init];
    SEL selector = NSSelectorFromString(@"initSDK");
    [scan performSelector:selector];
}

- (void)showDevice{
    Class class = NSClassFromString(@"DeviceScan");
    NSObject *scan = [[class alloc] init];
    SEL selector = NSSelectorFromString(@"showDevice");
    _macStr = [scan performSelector:selector];
}
@end
