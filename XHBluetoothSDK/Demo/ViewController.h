//
//  ViewController.h
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHDeviceScan.h"
#import "XHOpenDoor.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnInit;
@property (weak, nonatomic) IBOutlet UIButton *searchDeviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *macOpenDoor;
@property (weak, nonatomic) IBOutlet UIButton *firstFloorBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondFloorBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdFloorBtn;


@end

