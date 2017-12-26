//
//  DeviceModel.h
//  XHBluetoothSDK
//
//  Created by Leo on 2017/12/8.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
/*
 mac" : self.macArr[i],
 @"typeName" : self.typeNameArr[i],
 @"typeId" : self.typeIdArr[i],
 @"passWord" : self.passWordArr[i],
 @"manufacturerId" : self.manufacturerIdArr[i],
 @"buildingName"*/
@property (nonatomic ,copy)  NSString *mac;
@property (nonatomic ,copy)  NSString *typeName;
@property (nonatomic ,copy)  NSString *typeId;
@property (nonatomic ,copy)  NSString *passWord;
@property (nonatomic ,copy)  NSString *manufacturerId;
@property (nonatomic ,copy)  NSString *buildingName;
@end
