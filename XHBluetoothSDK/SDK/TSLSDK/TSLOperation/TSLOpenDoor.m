//
//  TSLOpenDoor.m
//  XHBluetoothSDK
//
//  Created by Leo on 2017/11/23.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "TSLOpenDoor.h"
#import <Terminus/TerminusApi.h>
#import <UIKit/UIKit.h>
#import "BlueModel.h"
@implementation TSLOpenDoor

- (void)openDoor{
    self.keysArr = [NSMutableArray array];
    self.bleManger = [TerminusBleCommunicationManager shareManagerInstance];
    self.keysArr = [TerminusApiManager getUserAllKeys];
    
    
    TerminusKeyBean *bean = (TerminusKeyBean *)self.keysArr;
    NSString *phoneName = nil;
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
    
    NSDictionary * data = @{
                            TerminusKeyUid:bean.keyUid,
//                            TerminusKeyUid:@"657363547fdg6557ddh3658584svxg65",
                            TerminusKeyUserPhone:phoneName, //可选参数
                            };
    
    self.bleManger.TBLEDelegate  = self;
//    [self.bleManger StartCommonCommunicationWithData:data operation:BluetoothOperationHandleOpenDoor LockCode:bean.chipId KeyCate:bean.keyCate];
    [self.bleManger StartCommonCommunicationWithData:data operation:BluetoothOperationHandleOpenDoor LockCode:nil KeyCate:-1];
}


#pragma mark - TerminusBleDelegate
- (void)didFoundBleDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *deviceLocalName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if (!deviceLocalName) {
        deviceLocalName = peripheral.name;
    }
    for (BlueModel *model in self.keysArr) {
        if ([model.name isEqualToString:deviceLocalName]){
            model.rssi = RSSI;
            return;
        }
    }
    BlueModel * newModel = [BlueModel new];
    newModel.name = deviceLocalName;
    newModel.rssi = RSSI;
    [self.keysArr addObject:newModel];
}

- (void) didReceiveData:(id)data {
    NSLog(@"_________________________");
    NSLog(@"-=++++++++++++++++++++++——");
    NSLog(@"_________________________");
//    [self.HUB hide:YES];
    TerminusReceiveBean *tempResData = data;
    if (tempResData.errorCode == BluetoothOperationSuccess) {
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Success open door" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
        [alertview show];
    }else if(tempResData.errorCode == 5001){
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Message" message:@"error password open door" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
        [alertview show];
    }else{
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Message" message:@"error open door" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
        [alertview show];
    }
}
- (void) didBluetoothReaceivedErrorCode:(BluetoothErrorCodes)code operation:(BluetoothOperation)operation error:(NSError *)error {
    NSLog(@"%d",code);
}

#pragma mark - deleteDateDelegate
- (void)successDelegate:(TerminusKeyBean *)bean{
    [self.keysArr removeObject:bean];
}

@end
