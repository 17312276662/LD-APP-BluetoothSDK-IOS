//
//  LFOpenDoor.h
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
#define kShowTimeLong               2
#define kShowTime                   2
@interface LFOpenDoor : NSObject <RfmSessionDelegate>
@property (nonatomic, strong)  NSArray *devices;
@property (nonatomic ,strong)  NSString *deviceKey;
@property (nonatomic ,strong)  NSString *mac;
@property (nonatomic,strong)   NSString *time;
@property (nonatomic ,strong)  NSTimer *timer;
@property (nonatomic ,strong)  NSString *factoryStr;
//开门
- (void)openDoor;
@end
