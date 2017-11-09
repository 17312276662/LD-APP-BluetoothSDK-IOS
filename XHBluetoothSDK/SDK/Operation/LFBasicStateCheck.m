//
//  LFBasicStateCheck.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/13.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "LFBasicStateCheck.h"
#import <CoreBluetooth/CoreBluetooth.h>
@implementation LFBasicStateCheck

//检查状态
- (BOOL)basicStateCheck
{
    CBManagerState state = [RfmSession sharedManager].cbState;
    BOOL stateOK = NO;
    //
    if (state == CBManagerStatePoweredOff)
    {
        [self showMessage:@"蓝牙开关未开启" time:kShowTime];
    }
    else if (state == CBManagerStateUnsupported)
    {
        [self showMessage:@"手机不支持" time:kShowTime];
    }
    else if (state == CBManagerStateUnauthorized)
    {
        [self showMessage:@"用户未授权" time:kShowTime];
    }
    else if (state != CBManagerStatePoweredOn)
    {
        [self showMessage:@"蓝牙未就绪" time:kShowTime];
    }
    else
    {
        stateOK = YES;
    }
    return stateOK;
}


#pragma mark - 简单提示信息
- (void)showMessage:(NSString *)message time:(NSTimeInterval)time
{
    NSLog(@"%@", message);
    //self.messageLabel.text = message;
    //
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissMessage) object:nil];
    [self performSelector:@selector(dismissMessage) withObject:nil afterDelay:time];
}

- (void)dismissMessage
{
    //self.messageLabel.text = @"";
}

- (void)showError
{
    // [self showMessage:@"指定设备不再范围内" time:kShowTime];
}
@end
