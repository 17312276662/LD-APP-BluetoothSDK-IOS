//
//  CacheDate.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/15.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheDate : NSObject
@property (nonatomic ,strong)  NSMutableArray *macArr;
@property (nonatomic ,strong)  NSMutableArray *passWordArr;
@property (nonatomic ,strong)  NSMutableArray *manufacturerIdArr;
@property (nonatomic ,strong)  NSMutableArray *typeNameArr;
@property (nonatomic ,strong)  NSMutableArray *buildingNameArr;
@property (nonatomic ,strong)  NSMutableArray *typeIdArr;
@property (nonatomic ,strong)  NSMutableArray *deviceArr;
//@property (nonatomic ,strong)  NSString *mobile;
//@property (nonatomic ,strong)  NSString *;
//加载公共设备资源
//- (void)loadPublicDeviceWithBuildingId:(NSInteger)buildingId;
//加载私有设备资源
//- (void)loadPrivateDeviceWithMobile:(NSString *)mobile BuildingId:(NSInteger)building;
//加载所有可用设备
- (void)loadAlleviceWithMobile:(NSString *)mobile BuildingId:(NSString *)buildingId;
@end
