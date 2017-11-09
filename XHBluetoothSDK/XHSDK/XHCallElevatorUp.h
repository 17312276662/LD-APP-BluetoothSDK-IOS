//
//  XHCallElevatorUp.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/13.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHCallElevatorUp : NSObject
//呼梯--上
- (void)callElevatorUpWithMac:(NSString *)mac andDeviceKey:(NSString *)deviceKey andCode:(NSString *)code andDir:(NSString *)dir;
@end
