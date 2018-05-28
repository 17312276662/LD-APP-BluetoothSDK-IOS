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
typedef void (^CheckDeviceBlock)(NSString *phoneNumber,NSString *buildingId);
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *buildinfIdText;
@property (weak, nonatomic) IBOutlet UIButton *btnInit;
@property (weak, nonatomic) IBOutlet UIButton *searchDeviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *macOpenDoor;
@property (weak, nonatomic) IBOutlet UIButton *firstFloorBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondFloorBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdFloorBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *TSLText;
@property (weak, nonatomic) IBOutlet UIButton *TSLBtn;
@property (nonatomic ,copy)  CheckDeviceBlock checkDeviceBlock;


@end

