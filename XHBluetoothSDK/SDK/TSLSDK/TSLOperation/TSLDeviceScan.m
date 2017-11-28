//
//  TSLDeviceScan.m
//  XHBluetoothSDK
//
//  Created by Leo on 2017/11/23.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "TSLDeviceScan.h"
#import <Terminus/TerminusApi.h>
@class TSLDeviceScan;
@interface TSLDeviceScan () <TerminusBleDelegate>;
@property (nonatomic,strong) NSMutableArray *deviceArr;
@property (nonatomic,weak) TerminusBleCommunicationManager *blueManger;
@end

@interface blueModel : NSObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic) NSNumber * rssi;
@end

@implementation blueModel

@end

@implementation TSLDeviceScan

- (NSMutableArray *)showDevice{
    
    [[TerminusBleCommunicationManager shareManagerInstance] ClearBleConnectCache];
    self.deviceArr = [NSMutableArray array];
    self.blueManger = [TerminusBleCommunicationManager shareManagerInstance];
    [self.blueManger startScanDevice:nil];
    self.blueManger.TBLEDelegate = self;
    return _deviceArr;
}

#pragma mark - TerminusBleDelegate
- (void)didFoundBleDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString * deviceLocalName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if (!deviceLocalName) {
        deviceLocalName = peripheral.name;
    }
    for (blueModel * model in self.deviceArr) {
        if ([model.name isEqualToString:deviceLocalName]){
            model.rssi = RSSI;
            return;
        }
    }
    blueModel * newModel = [blueModel new];
    newModel.name = deviceLocalName;
    newModel.rssi = RSSI;
    [self.deviceArr addObject:newModel];
    
}

- (void)didBluetoothReaceivedErrorCode:(BluetoothErrorCodes)code operation:(BluetoothOperation)operation error:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)didReceiveData:(id)data {
    
}
@end
