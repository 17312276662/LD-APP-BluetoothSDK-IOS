//
//  XHBluetoothDevicesView.h
//  XHBluetoothSDK
//
//  Created by Leo on 2018/5/21.
//  Copyright © 2018年 xujw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBluetoothDevicesView : UIView
@property (nonatomic ,strong)  NSString *mobile;
- (void)findDeviceWith:(NSString *)mobile withBuildingId:(NSString *)buildingId;
@end
