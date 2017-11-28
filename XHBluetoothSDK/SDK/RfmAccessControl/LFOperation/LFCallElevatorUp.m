//
//  LFCallElevatorUp.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/13.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "LFCallElevatorUp.h"
#import "LFBasicStateCheck.h"

@implementation LFCallElevatorUp
- (void)callElevatorUp{
    LFBasicStateCheck *basicStateCheck = [LFBasicStateCheck new];
    if ([basicStateCheck basicStateCheck])
    {
        _devices = [[RfmSession sharedManager] discoveredDevices];
        RfmActionError error = [[RfmSession sharedManager] openHallBtn:[_mac stringToHexData] deviceKey:_deviceKey code:_code dir:_dir];
        if (error == RfmActionErrorNone)
        {
            [self showMessage:@"进行中" time:kShowTimeLong];
            NSLog(@"上楼");
        }
        else    //具体参考开门的返回，这里不处理细节
        {
            [self showMessage:@"操作失败" time:kShowTimeLong];
        }
        }
        else
        {
            [self showMessage:@"未搜索到蓝牙控制器" time:kShowTimeLong];
        }
    
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
