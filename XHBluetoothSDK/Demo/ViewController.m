//
//  ViewController.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/11.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "ViewController.h"
#import "XHCallElevatorUp.h"
#import "XHCallElevatorDown.h"
#import "XHChooseFloor.h"
#import "contentModel.h"
#import "XHCacheDate.h"
#import "DeviceModel.h"
#import "MJExtension.h"
#import "TSLDeviceScan.h"
#import "XHBluetoothDevicesView.h"

#define kDeviceKey                  @"4c464b47396764765737336f51317936"
#define kDeviceNewKey               @"FFFFFFFFFFFFFFFF3232323232323232"
#define kCardCode                   @"013612345678"


#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *scanResult;
@property (nonatomic ,assign)  NSString *buildingId;
@property (nonatomic ,strong)  NSString *token;
@property (nonatomic ,strong)  NSString *deviceKey;
@property (nonatomic ,strong)  NSString *factory;
@property (nonatomic ,strong)  NSString *mobile;
@property (nonatomic ,strong)  UIAlertAction *device;
@property (nonatomic ,strong)  NSArray *macArr;
@property (nonatomic ,strong)  XHCacheDate *date;
@property (nonatomic ,strong)  NSString *buildingName;
@property (nonatomic ,strong)  NSString *manufacturerId;
@property (nonatomic ,strong)  NSString *passWord;
@property (nonatomic ,strong)  NSString *typeId;
@property (nonatomic ,strong)  NSString *typeName;
@property (nonatomic ,strong)  NSString *mac;
@end
@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)dismissAlertView:(NSTimer *)timer{
    UIAlertController *alertView = [timer userInfo];
    [alertView dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.macArr = [NSMutableArray array];
    [self.firstFloorBtn addTarget:self action:@selector(chooseFloor1) forControlEvents:UIControlEventTouchUpInside];
    [self.secondFloorBtn addTarget:self action:@selector(chooseFloor2) forControlEvents:UIControlEventTouchUpInside];
    [self.thirdFloorBtn addTarget:self action:@selector(chooseFloor3) forControlEvents:UIControlEventTouchUpInside];
}
//查设备
- (IBAction)checkDevice:(id)sender {
    NSLog(@"-1");
    XHBluetoothDevicesView *bluetoothDeviceView = [[XHBluetoothDevicesView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    NSLog(@"0");
    [bluetoothDeviceView findDeviceWith:self.phoneTextField.text withBuildingId:self.buildinfIdText.text];
    [self.view addSubview:bluetoothDeviceView];
}



//呼梯--上
- (IBAction)callElevatorUp:(id)sender {
    XHCallElevatorUp *callElevatorUp = [XHCallElevatorUp new];
    NSString *deviceKey = kDeviceKey;
    NSString *macStr = _mac;
    NSString *dir = @"HallBtnDirUp";
    NSString *code  = kCardCode;
    [callElevatorUp callElevatorUpWithMac:macStr andDeviceKey:deviceKey andCode:code andDir:dir];
    
}
//呼梯--下
- (IBAction)callElevatorDown:(id)sender {
    XHCallElevatorDown *callElevatordown = [XHCallElevatorDown new];
    NSString *deviceKey = kDeviceKey;
    NSString *macStr = _mac;
    NSString *dir = @"HallBtnDirUp";
    NSString *code  = kCardCode;
    [callElevatordown callElevatorDownWithMac:macStr andDeviceKey:deviceKey andCode:code andDir:dir];
    
}
//选择楼层--1楼
- (void)chooseFloor1{
    XHChooseFloor *chooseFloor = [XHChooseFloor new];
    NSString *deviceKey = kDeviceKey;
    NSString *macStr = _mac;
    NSString *code  = kCardCode;
    NSString *floor  = @"1";
    [chooseFloor openElevator:macStr deviceKey:deviceKey code:code floor:floor];
}
//选择楼层--2楼
- (void)chooseFloor2{
    XHChooseFloor *chooseFloor = [XHChooseFloor new];
    NSString *deviceKey = kDeviceKey;
    NSString *macStr = _mac;
    NSString *code  = kCardCode;
    NSString *floor  = @"2";
    [chooseFloor openElevator:macStr deviceKey:deviceKey code:code floor:floor];
}
//选择楼层--3楼
- (void)chooseFloor3{
    XHChooseFloor *chooseFloor = [XHChooseFloor new];
    NSString *deviceKey = kDeviceKey;
    NSString *macStr = _mac;
    NSString *code  = kCardCode;
    NSString *floor  = @"3";
    [chooseFloor openElevator:macStr deviceKey:deviceKey code:code floor:floor];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_phoneTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
