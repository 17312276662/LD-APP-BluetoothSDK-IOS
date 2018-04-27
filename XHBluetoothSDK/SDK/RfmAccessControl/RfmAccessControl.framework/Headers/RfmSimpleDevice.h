//
//  RfmSimpleDevice.h
//  RfmAccessControlDemo
//
//  Created by yeyufeng on 15/5/22.
//  Copyright (c) 2015年 REFORMER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RfmSimpleDevice : NSObject

///门禁模块唯一标识符
@property (nonatomic, copy) NSData *mac;

///信号强度指示器
@property (nonatomic, assign) NSInteger rssi;

///构造方法
- (instancetype)initWithMac:(NSData *)mac rssi:(NSInteger)rssi;

@end
