//
//  TSLDeviceScan.h
//  XHBluetoothSDK
//
//  Created by Leo on 2017/11/23.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Terminus/TerminusApi.h>
@interface TSLDeviceScan : NSObject<TerminusBleDelegate>
@property (nonatomic ,strong)  NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *deviceArr;
@property (nonatomic,weak) TerminusBleCommunicationManager *blueManger;
@property (nonatomic ,strong)  NSString *blueName;
//扫描设备
//- (NSMutableArray *)showDevice;
- (void)initAndSettingEquipment;
@end
