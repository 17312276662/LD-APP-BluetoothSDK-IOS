//
//  ResourceKeyModel.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/15.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ResourceKeyModel : NSObject
@property (nonatomic ,copy)  NSString *mac;
@property (nonatomic ,copy)  NSString *password;
@property (nonatomic ,assign)  NSInteger manufacturerId;
@end
