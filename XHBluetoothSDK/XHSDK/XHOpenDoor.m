//
//  XHOpenDoor.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "XHOpenDoor.h"
@implementation XHOpenDoor
//传入mac开门
-(void)openDoorCheckedWithMac:(NSString *)mac deviceKey:(NSString *)deviceKey outputActiveTime:(NSString *)time factory:(NSString *)factoryStr{
    //开门字典
    if (mac) {
    NSDictionary *openDict = @{                               // 类名
                               @"className" : @"OpenDoor",
                               // 数据参数
                               @"propertys" : @{@"mac": mac,
                                                  
                                                @"deviceKey": deviceKey,
                                                
                                                @"time":time,
                                                
                                                @"factoryStr":factoryStr
                                                },
                               // 调用方法名
                               @"method" : @"openDoor"};
    
    Class class = NSClassFromString(@"OpenDoor");
    NSObject *openDoor = [[class alloc] init];
    // 获取参数列表，使用枚举的方式，对控制器属性进行KVC赋值
    NSDictionary *parameter = openDict[@"propertys"];
    [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 在属性赋值时，做容错处理，防止因为后台数据导致的异常
        if ([openDoor respondsToSelector:NSSelectorFromString(key)]) {
            [openDoor setValue:obj forKey:key];
        }
    }];
    // 从字典中获取方法名，并调用对应的方法
    SEL selector = NSSelectorFromString(openDict[@"method"]);
    [openDoor performSelector:selector];
    }else{
        NSLog(@"请选择设备");
    }
}
@end
