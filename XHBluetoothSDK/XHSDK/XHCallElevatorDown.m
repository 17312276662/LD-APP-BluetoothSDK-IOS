//
//  XHCallElevatorDown.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/13.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "XHCallElevatorDown.h"

@implementation XHCallElevatorDown
-(void)callElevatorDownWithMac:(NSString *)mac andDeviceKey:(NSString *)deviceKey andCode:(NSString *)code andDir:(NSString *)dir{
    if (mac) {
        //呼梯--上
        NSDictionary *openDict = @{
                                   // 类名
                                   @"className" : @"CallElevatorDown",
                                   // 数据参数
                                   @"propertys" : @{@"mac": mac,
                                                    
                                                    @"deviceKey": deviceKey,
                                                    
                                                    @"code":code,
                                                    
                                                    @"dir":dir
                                                    },
                                   // 调用方法名
                                   @"method" : @"callElevatorDown"};
        
        Class class = NSClassFromString(@"CallElevatorDown");
        NSObject *callElevatorUp = [[class alloc] init];
        // 获取参数列表，使用枚举的方式，对控制器属性进行KVC赋值
        NSDictionary *parameter = openDict[@"propertys"];
        [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            // 在属性赋值时，做容错处理，防止因为后台数据导致的异常
            if ([callElevatorUp respondsToSelector:NSSelectorFromString(key)]) {
                [callElevatorUp setValue:obj forKey:key];
            }
        }];
        // 从字典中获取方法名，并调用对应的方法
        SEL selector = NSSelectorFromString(openDict[@"method"]);
        [callElevatorUp performSelector:selector];
    }else{
        NSLog(@"请选择设备!");
    }
}
@end
