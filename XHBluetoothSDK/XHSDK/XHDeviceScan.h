//
//  xhDeviceScan.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XHDeviceScan : NSObject
@property (nonatomic ,strong)  NSMutableArray *macArr;
//初始化SDK
- (void)initSDK;
//扫描设备
- (void)showDevice;
@end
