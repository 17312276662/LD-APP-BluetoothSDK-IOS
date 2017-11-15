//
//  ResourceDatasModel.h
//  XHBluetoothSDK
//
//  Created by Leo on 2017/11/10.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceDatasModel : NSObject
@property (nonatomic ,copy)  NSString *typeName;
@property (nonatomic ,copy)  NSArray *resourceKeys;
@property (nonatomic ,assign)  NSInteger  typeId;
@property (nonatomic ,copy)  NSString *buildingName;
@end
