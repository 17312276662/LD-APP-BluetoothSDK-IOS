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
-(void)openDoorCheckedWithMac:(NSString *)mac deviceKey:(NSString *)deviceKey manufacturerId:(NSString *)manufacturerId{
    if ([manufacturerId isEqualToString:@"1"]) {
//        [self TSLOpenDoor];
    }else{
        [self LFOpenDoorWithMac:mac AndPassWord:deviceKey];
    }
}
/*
- (void)TSLOpenDoor{
    NSLog(@"TSLOpenDoor");
    Class class = NSClassFromString(@"TSLOpenDoor");
    NSObject *scan = [[class alloc] init];
    
    SEL selector = NSSelectorFromString(@"openDoor");
    NSMutableArray *arr = [NSMutableArray array];
    arr = [scan performSelector:selector];
}
*/
- (void)LFOpenDoorWithMac:(NSString *)mac AndPassWord:(NSString *)password{
    NSLog(@"LFOpenDoor");
    //开门字典
    NSString *time = @"60";
    if (mac) {
        NSDictionary *openDict = @{                               // 类名
                                   @"className" : @"LFOpenDoor",
                                   // 数据参数
                                   @"propertys" : @{@"mac": mac,
                                                    
                                                    @"deviceKey": password,
                                                    
                                                    @"time":time,
                                                    },
                                   // 调用方法名
                                   @"method" : @"openDoor"};
        
        Class class = NSClassFromString(@"LFOpenDoor");
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
