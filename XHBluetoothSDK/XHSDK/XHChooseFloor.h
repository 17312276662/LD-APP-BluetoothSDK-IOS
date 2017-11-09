//
//  XHChooseFloor.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/13.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHChooseFloor : NSObject
//选择楼层
- (void)openElevator:(NSString *)mac deviceKey:(NSString *)deviceKey code:(NSString *)code floor:(NSString *)floor;
@end
