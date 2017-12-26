//
//  LFOpenDoor.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "LFOpenDoor.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "LFDeviceScan.h"
@implementation LFOpenDoor

- (NSMutableArray *)devices;
{
    if (!_devices) {
        _devices =  [NSMutableArray array];
    }
    return _devices;
}

//开门
- (void)openDoor{
    LFDeviceScan *deviceScan = [LFDeviceScan new];
    _devices = [deviceScan showDevice];
    [RfmSession sharedManager].delegate = self;
    if (_devices.count > 0)
        {
        u_int16_t Time = (u_int16_t)time;
        RfmActionError error = [[RfmSession sharedManager]openDoorCheckedWithMac:[_mac stringToHexData] deviceKey:_deviceKey outputActiveTime:Time isRfmDevice:YES];
    
        if (error == RfmActionErrorNone)
        {
            [self showMessage:@"认证中..." time:kShowTimeLong];
        }
        else if (error == RfmActionErrorParam)
        {
            [self showMessage:@"输入参数有误" time:kShowTimeLong];
        }
        else if (error == RfmActionErrorNoDevice)
        {
            [self showMessage:@"指定设备不再范围内" time:kShowTimeLong];
        }
        else if (error == RfmActionErrorPoweredOff)
        {
        [self showMessage:@"蓝牙开关未开启" time:kShowTimeLong];
        }
                    /*
                     else if (error == RfmActionErrorUnsupported)    //当前版本不会进入此处
                     {
                     [self showMessage:@"手机不支持" time:kShowTimeLong];
                     }
                     */
        else if (error == RfmActionErrorUnauthorized)
        {
            [self showMessage:@"用户未授权" time:kShowTimeLong];
        }
        else if (error == RfmActionErrorBusy)
        {
            [self showMessage:@"操作忙" time:kShowTimeLong];
        }
        else if (error == RfmActionErrorOther)
        {
            [self showMessage:@"其他异常" time:kShowTimeLong];
        }
    
                    // [actionSheet addButtonWithTitle:[device.mac dataToHexString]];
                    /*
                    _devices = [NSArray arrayWithObject:device.mac];
    
                    NSLog(@" device.mac --> %@",device.mac);
    
                    NSLog(@" stringToHexData --> %@",[[device.mac dataToHexString] stringToHexData]);
                     */
        }
    }
    
//    LFBasicStateCheck *basicStateCheck = [LFBasicStateCheck new];
//    if ([basicStateCheck basicStateCheck])
//    {
//        _devices = [[RfmSession sharedManager] discoveredDevices];
//        [RfmSession sharedManager].delegate = self;
//        if (_devices.count > 0)
//        {
//
//           // for (RfmSimpleDevice *device in _devices)
//           // {
//                u_int16_t Time = (u_int16_t)time;
//                RfmActionError error = [[RfmSession sharedManager]openDoorCheckedWithMac:[_mac stringToHexData] deviceKey:_deviceKey outputActiveTime:Time isRfmDevice:YES];
//
//                if (error == RfmActionErrorNone)
//                {
//                    [self showMessage:@"认证中..." time:kShowTimeLong];
//                }
//                else if (error == RfmActionErrorParam)
//                {
//                    [self showMessage:@"输入参数有误" time:kShowTimeLong];
//                }
//                else if (error == RfmActionErrorNoDevice)
//                {
//                    [self showMessage:@"指定设备不再范围内" time:kShowTimeLong];
//                }
//                else if (error == RfmActionErrorPoweredOff)
//                {
//                    [self showMessage:@"蓝牙开关未开启" time:kShowTimeLong];
//                }
//                /*
//                 else if (error == RfmActionErrorUnsupported)    //当前版本不会进入此处
//                 {
//                 [self showMessage:@"手机不支持" time:kShowTimeLong];
//                 }
//                 */
//                else if (error == RfmActionErrorUnauthorized)
//                {
//                    [self showMessage:@"用户未授权" time:kShowTimeLong];
//                }
//                else if (error == RfmActionErrorBusy)
//                {
//                    [self showMessage:@"操作忙" time:kShowTimeLong];
//                }
//                else if (error == RfmActionErrorOther)
//                {
//                    [self showMessage:@"其他异常" time:kShowTimeLong];
//                }
//
//                // [actionSheet addButtonWithTitle:[device.mac dataToHexString]];
//                /*
//                _devices = [NSArray arrayWithObject:device.mac];
//
//                NSLog(@" device.mac --> %@",device.mac);
//
//                NSLog(@" stringToHexData --> %@",[[device.mac dataToHexString] stringToHexData]);
//                 */
//            }
//        }
//        else
//        {
//            [self showMessage:@"未搜索到蓝牙控制器" time:kShowTimeLong];
//        }
//


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
    [self showMessage:@"指定设备不再范围内" time:kShowTime];
}

#pragma mark - RfmSessionDelegate
///门禁系统会话完成事件回调
- (void)rfmSessionDidFinishedEvent:(RfmSessionEvent)event mac:(NSData *)mac error:(RfmSessionError)error
{
    NSInteger result = 1;
    NSString *message;
    //
    if (event == RfmSessionEventOpenDoor || event == RfmSessionEventElevator || event == RfmSessionEventHallBtn)   //开门
    {
        [self.timer invalidate];
        self.timer=nil;
        switch (error)
        {
            case RfmSessionErrorNone:
            {
                result = 0;
                message = @"开门成功";
                break;
            }
            case RfmSessionErrorNoDevice:
            {
                message = @"未搜索到蓝牙控制器";
                break;
            }
            case RfmSessionErrorDeviceInteraction:
            {
                message = @"蓝牙通讯异常";
                break;
            }
            case RfmSessionErrorDeviceTimeOut:
            {
                message = @"蓝牙通讯超时";
                break;
            }
            case RfmSessionErrorDeviceRespError:    //蓝牙控制器拒绝请求，通常就是动态开门密码错误
            {
                message = @"动态开门密码错误!!!";
                break;
            }
            default:
                break;
        }
        //
        [self showMessage:message time:kShowTime];
    }
    else if (event == RfmSessionEventSetDeviceKey)   //设置设备密码
    {
        switch (error)
        {
            case RfmSessionErrorNone:
            {
                result = 0;
                message = @"设置成功";
                break;
            }
            case RfmSessionErrorDeviceRespError:
            {
                message = @"设备拒绝请求";
                break;
            }
            default:
            {
                message = @"设置失败";
                break;
            }
        }
        //
        [self showMessage:message time:kShowTime];
    }
}
@end
