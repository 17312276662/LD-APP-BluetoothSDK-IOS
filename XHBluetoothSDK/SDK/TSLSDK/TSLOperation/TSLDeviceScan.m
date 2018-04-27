//
//  TSLDeviceScan.m
//  XHBluetoothSDK
//
//  Created by Leo on 2017/11/23.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "TSLDeviceScan.h"
#import "BlueModel.h"
@class TSLDeviceScan;
@interface TSLDeviceScan ();
@property (nonatomic,strong) NSMutableArray *deviceArr;
@property (nonatomic,weak) TerminusBleCommunicationManager *blueManger;
@end
@implementation TSLDeviceScan

- (NSMutableArray *)showDevice{
    
    [[TerminusBleCommunicationManager shareManagerInstance] ClearBleConnectCache];
    self.deviceArr = [NSMutableArray array];
    
    self.blueManger = [TerminusBleCommunicationManager shareManagerInstance];
    self.blueManger.TBLEDelegate = self;
//    [self.blueManger startScanDevice:nil];
    NSArray *arr = @[@"64951695432649565",@"3481F40D4BD4",@"3481F40D37F9"];
    self.deviceArr = [NSMutableArray arrayWithArray:arr];
    return _deviceArr;
}

#pragma mark - TerminusBleDelegate
- (void)didFoundBleDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString * deviceLocalName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if (!deviceLocalName) {
        deviceLocalName = peripheral.name;
    }
    for (BlueModel *model in self.deviceArr) {
        if ([model.name isEqualToString:deviceLocalName]){
            model.rssi = RSSI;
            return;
        }
    }
    BlueModel * newModel = [BlueModel new];
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
