//
//  TSLDeviceScan.m
//  XHBluetoothSDK
//
//  Created by Leo on 2017/11/23.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "TSLDeviceScan.h"

#import "BlueModel.h"
#import <UIKit/UIKit.h>


@class TSLDeviceScan;
@interface TSLDeviceScan () <TerminusBleDelegate>;
@property (nonatomic,strong) NSMutableArray *deviceArr;
@property (nonatomic,weak) TerminusBleCommunicationManager *blueManger;
@property (nonatomic ,strong)  NSString *blueName;
@end

@implementation TSLDeviceScan

- (void)showDevice{

    [[TerminusBleCommunicationManager shareManagerInstance] ClearBleConnectCache];
    self.dataSource = [NSMutableArray array];
    self.blueManger = [TerminusBleCommunicationManager shareManagerInstance];
    self.blueManger.TBLEDelegate = self;
    [self.blueManger startScanDevice:nil];
}
/*
- (NSMutableArray *)showDevice
{
 
    [self initAndSettingEquipment];
    
    NSString * phoneName = nil;
    UIDevice *myDevice = [UIDevice currentDevice];
    NSRange rangeNameSucc =[myDevice.name.lowercaseString rangeOfString:@"succ"];
    NSRange rangeNameFail =[myDevice.name.lowercaseString rangeOfString:@"fail"];
    
    // userName lenth 10
    if (rangeNameSucc.location == NSNotFound || rangeNameFail.location == NSNotFound) {
        if (phoneName.length > 10) {
            phoneName = [myDevice.name substringWithRange:NSMakeRange(1, 10)];
        }else {
            phoneName = myDevice.name;
        }
        
    }else {
        phoneName = @"ErrorUser";
    }
    
    
    [self.blueManger setPierWithPierPwd:@"123456" NewPwd:@"654321" IsAdmin:YES UserName:phoneName];
    
//        [self.bleManger setPierWithPierPwd:_txtPwd.text NewPwd:nil IsAdmin:NO UserName:phoneName];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.blueManger.TBLEDelegate = self;
    
    [self.blueManger StartCommonCommunication:nil MacAddress:self.blueName UUID:nil ControlID:BluetoothOperationPierUpdatePWD LockCode:nil KeyCate:-1];
    self.dataSource = [NSMutableArray array];
    self.dataSource = [TerminusApiManager getUserAllKeys];
    self.deviceArr  = [NSMutableArray array];
    [self.deviceArr addObject:self.blueName];
 
    return self.deviceArr;
     
}
*/

#pragma mark - TerminusBleDelegate
- (void)didFoundBleDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString * deviceLocalName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if (!deviceLocalName) {
        deviceLocalName = peripheral.name;
    }
    for (BlueModel *model in self.dataSource) {
        if ([model.name isEqualToString:deviceLocalName]){
           
            
        }
    }
    BlueModel * newModel = [BlueModel new];
    newModel.name = deviceLocalName;
    
    self.blueName = newModel.name;
    [self.dataSource addObject:self.blueName];
}

- (void)didBluetoothReaceivedErrorCode:(BluetoothErrorCodes)code operation:(BluetoothOperation)operation error:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)didReceiveData:(id)data {
    
}

@end
