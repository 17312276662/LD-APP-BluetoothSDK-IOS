//
//  BLElib.h
//  BLElib
//
//  Created by fankyo on 13-3-27.
//  Copyright (c) 2013年 fankyo. All rights reserved.
//

#import <Foundation/Foundation.h>




extern NSString * const SERVICE_UUID;

@protocol BLEDoorDelegate <NSObject>
- (BOOL)checkShouldFenBao;
@optional
- (void) didFoundPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI operation:(BluetoothOperation)operation;

- (void) didConnectPeripheral:(CBPeripheral *)peripheral;
- (void) didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error operation:(BluetoothOperation)operation;
- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral;
- (void) didRecieveData:(NSData *)data blueOperation:(BluetoothOperation)operation;
- (void) didSendData:(NSData *)data Bluetooth:(BluetoothOperation)operation;

- (void) didBluetoothError:(BluetoothErrorCodes)code  operation:(BluetoothOperation)operation error:(NSError*)error;

- (void)didHaveSeverDataToSendData;

@end


@interface BLElib: NSObject 

@property (nonatomic, weak) id<BLEDoorDelegate> BLEDelegate;


@property (nonatomic, retain)   CBCentralManager            *centralManager;
@property (nonatomic, retain)   CBPeripheral                *connectedPeripheral;
@property (nonatomic, retain)   CBCharacteristic            *msgCharacteristic;
@property (nonatomic, retain)   CBService                   *connectedService;
@property (nonatomic, assign)   UIBackgroundTaskIdentifier  backgroundRecordingID;


@property (nonatomic, assign) BluetoothOperation operation;


//fuctions of discovery
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;

//fuctions of conn & disconn
- (void) connectPeripheral:(CBPeripheral*)peripheral;

- (void) disconnectPeripheral;

//fuction of sending
- (BOOL) sendData:(NSData *)data;

//utility
- (BOOL) isConnected;
- (BOOL) isConnectedWithPeripheral:(CBPeripheral*)peripheral;
- (void) enterBackground;
- (void) enterForeground;
- (void) cleanApplicationIconBadgeNumber;
- (void) pushNotificationWithMessage:(NSString *)messageString
                         buttonTitle:(NSString *)buttonTitle
                           inSeconds:(NSInteger )delaySeconds;


@end
