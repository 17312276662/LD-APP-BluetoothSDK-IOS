//
//  TSLDeviceScan.h
//  XHBluetoothSDK
//
//  Created by Leo on 2017/11/23.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Terminus/TerminusApi.h>
@interface TSLDeviceScan : NSObject <TerminusBleDelegate>
//扫描设备
- (NSMutableArray *)showDevice;
@end
