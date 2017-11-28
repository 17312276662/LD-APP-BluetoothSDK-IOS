//
//  LFBasicStateCheck.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/13.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RfmAccessControl.h"
#define kShowTimeLong               2
#define kShowTime                   2
@interface LFBasicStateCheck : NSObject <RfmSessionDelegate>
@property (nonatomic ,strong)  NSTimer *timer;
//蓝牙状态检查
- (BOOL)basicStateCheck;
@end
