//
//  XHDeviceScan.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "XHDeviceScan.h"
@class XHDeviceScan;
@implementation XHDeviceScan
- (void)initSDK{
    Class class = NSClassFromString(@"LFDeviceScan");
    NSObject *scan = [[class alloc] init];
    SEL selector = NSSelectorFromString(@"initSDK");
    [scan performSelector:selector];
}

- (void)showDevice{
    _macArr = [NSMutableArray array];
    [self showLFDevice];
    [self showTSLDevice];
}

- (void)showLFDevice{
    Class class = NSClassFromString(@"LFDeviceScan");
    NSObject *scan = [[class alloc] init];
    SEL selector = NSSelectorFromString(@"showDevice");
    NSArray *arr = [scan performSelector:selector];
    [_macArr addObjectsFromArray:arr];
}

- (void)showTSLDevice{
    Class class = NSClassFromString(@"TSLDeviceScan");
    NSObject *scan = [[class alloc] init];
    
    SEL selector = NSSelectorFromString(@"showDevice");
    NSMutableArray *arr = [NSMutableArray array];
    arr = [scan performSelector:selector];
    [_macArr addObjectsFromArray:arr];
}
@end
