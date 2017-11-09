//
//  XHOpenDoor.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHOpenDoor : NSObject
//传入mac开门
- (void)openDoorCheckedWithMac:(NSString *)mac deviceKey:(NSString *)deviceKey outputActiveTime:(NSString *)time factory:(NSString *)factoryStr;
@end
