//
//  DeviceViewController.h
//  XHBluetoothSDK
//
//  Created by Leo on 2018/1/17.
//  Copyright © 2018年 xujw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceViewController : UIViewController
//设备mac
@property (nonatomic ,strong)  NSMutableArray *mac;
//设备密码
@property (nonatomic ,strong)  NSMutableArray *passWord;
//大楼名称
@property (nonatomic ,strong)  NSMutableArray *building;

@property (nonatomic ,strong)  NSMutableArray *typeName;
//厂商ID
@property (nonatomic ,strong)  NSMutableArray *manufacturerId;
@end
