//
//  LFCallElevatorUp.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/13.
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
@interface LFCallElevatorUp : NSObject<RfmSessionDelegate>
@property (nonatomic ,strong)  NSString *mac;
@property (nonatomic ,strong)  NSString *deviceKey;
@property (nonatomic ,strong)  NSString *code;
@property (nonatomic ,strong)  NSString *dir;
@property (nonatomic ,strong)  NSArray  *devices;
@property (nonatomic ,strong)  NSTimer *timer;
//呼梯---上
- (void)callElevatorUp;
@end
