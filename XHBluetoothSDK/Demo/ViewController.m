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
#import "DeviceViewController.h"
#import "TSLDeviceScan.h"

#define kDeviceKey                  @"4c464b47396764765737336f51317936"
#define kDeviceNewKey               @"FFFFFFFFFFFFFFFF3232323232323232"
#define kCardCode                   @"013612345678"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *scanResult;
@property (nonatomic ,assign)  NSString *buildingId;
@property (nonatomic ,strong)  NSString *token;
@property (nonatomic ,strong)  NSString *deviceKey;
@property (nonatomic ,strong)  NSString *factory;
@property (nonatomic ,strong)  NSString *mobile;

@property (nonatomic ,strong)  UIAlertAction *device;

@property (nonatomic ,strong)  NSArray *macArr;

@property (nonatomic ,strong)  NSMutableArray *passWordArr;
@property (nonatomic ,strong)  NSMutableArray *manufacturerIdArr;
@property (nonatomic ,strong)  NSMutableArray *typeNameArr;
@property (nonatomic ,strong)  NSMutableArray *typeIdArr;
@property (nonatomic ,strong)  NSMutableArray *buildingNameArr;

@property (nonatomic ,strong)  XHCacheDate *date;

@property (nonatomic ,strong)  NSString *buildingName;
@property (nonatomic ,strong)  NSString *manufacturerId;
@property (nonatomic ,strong)  NSString *passWord;
@property (nonatomic ,strong)  NSString *typeId;
@property (nonatomic ,strong)  NSString *typeName;
@property (nonatomic ,strong)  NSString *mac;

@property (nonatomic ,strong)  NSMutableArray *canUseMac;
@property (nonatomic ,strong)  NSMutableArray *canUsePassWord;
@property (nonatomic ,strong)  NSMutableArray *canUseBuilding;
@property (nonatomic ,strong)  NSMutableArray *canUseTypeName;
@property (nonatomic ,strong)  NSMutableArray *canUseManufacturerIdArr;

@property (nonatomic ,strong)  NSMutableArray *loadMac;



@end
@implementation ViewController

- (NSMutableArray *)canUseManufacturerIdArr;
{
    if (!_canUseManufacturerIdArr) {
        _canUseManufacturerIdArr =  [NSMutableArray array];
    }
    return _canUseManufacturerIdArr;
}

- (NSMutableArray *)canUseBuilding;
{
    if (!_canUseBuilding) {
        _canUseBuilding =  [NSMutableArray array];
    }
    return _canUseBuilding;
}

- (NSMutableArray *)canUsePassWord;
{
    if (!_canUsePassWord) {
        _canUsePassWord =  [NSMutableArray array];
    }
    return _canUsePassWord;
}

- (NSMutableArray *)canUseTypeName;
{
    if (!_canUseTypeName) {
        _canUseTypeName =  [NSMutableArray array];
    }
    return _canUseTypeName;
}

- (NSMutableArray *)canUseMac;
{
    if (!_canUseMac) {
        _canUseMac =  [NSMutableArray array];
    }
    return _canUseMac;
}

- (NSMutableArray *)loadMac;
{
    if (!_loadMac) {
        _loadMac = [NSMutableArray array];
    }
    return _loadMac;
}

- (NSMutableArray *)buildingNameArr;
{
    if (!_buildingNameArr) {
        _buildingNameArr =  [NSMutableArray array];
    }
    return _buildingNameArr;
}

- (NSMutableArray *)manufacturerIdArr;
{
    if (!_manufacturerIdArr) {
        _manufacturerIdArr =  [NSMutableArray array];
    }
    return _manufacturerIdArr;
}

- (NSMutableArray *)passWordArr;
{
    if (!_passWordArr) {
        _passWordArr =  [NSMutableArray array];
    }
    return _passWordArr;
}

- (NSMutableArray *)typeIdArr;
{
    if (!_typeIdArr) {
        _typeIdArr =  [NSMutableArray array];
    }
    return _typeIdArr;
}

- (NSMutableArray *)typeNameArr;
{
    if (!_typeNameArr) {
        _typeNameArr =  [NSMutableArray array];
    }
    return _typeNameArr;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备初始化中......" preferredStyle:UIAlertControllerStyleAlert];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissAlertView:) userInfo:alertController repeats:NO];
   
    
}

- (void)loadDate{
    _date = [XHCacheDate new];
    self.buildingId = @"";
//    self.mobile = @"13813486976";
    self.mobile = self.phoneTextField.text;
//    self.mobile = @"";
    [_date loadAlleviceWithMobile:self.mobile BuildingId:self.buildingId];
    
}

- (void)dismissAlertView:(NSTimer *)timer{
    UIAlertController *alertView = [timer userInfo];
    [alertView dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.macArr = [NSMutableArray array];
    [self initDevice];
    [self.btnInit addTarget:self action:@selector(initDevice) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.macOpenDoor addTarget:self action:@selector(openDoorWithMac:) forControlEvents:UIControlEventTouchUpInside];
    self.scanResult.placeholder = @"设备扫描结果";
    self.scanResult.enabled = NO;
    [self.firstFloorBtn addTarget:self action:@selector(chooseFloor1) forControlEvents:UIControlEventTouchUpInside];
    [self.secondFloorBtn addTarget:self action:@selector(chooseFloor2) forControlEvents:UIControlEventTouchUpInside];
    [self.thirdFloorBtn addTarget:self action:@selector(chooseFloor3) forControlEvents:UIControlEventTouchUpInside];
}

//初始化设备
- (void)initDevice{
    self.scanResult.text = @"设备扫描结果";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备初始化中......" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    XHDeviceScan *scan = [XHDeviceScan new];
    [scan initSDK];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissAlertView:) userInfo:alertController repeats:NO];
}
//查设备
- (IBAction)checkDevice:(id)sender {
//    [self loadDate];
    if ([self.phoneTextField.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号码" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAlertView:) userInfo:alertController repeats:NO];
    }else{
        [self loadDate];
    }
    
    XHDeviceScan *scan = [XHDeviceScan new];
    [scan showDevice];
//    TSLDeviceScan *newScan = [TSLDeviceScan new];
//    [newScan showDevice];
//    _macArr = scan.macArr;
    _macArr = [NSMutableArray arrayWithArray:scan.macArr];
    NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePatch stringByAppendingPathComponent:@"devices.plist"];
    NSMutableArray *devices = [NSMutableArray arrayWithContentsOfFile:filePath];
//    NSString *mac = devices[0][@"mac"];
    for (int i = 0; i < devices.count; i++) {
        [self.loadMac addObject:devices[i][@"mac"]];
        [self.buildingNameArr addObject:devices[i][@"buildingName"]];
        [self.typeNameArr addObject:devices[i][@"typeName"]];
        [self.typeIdArr addObject:devices[i][@"typeId"]];
        [self.passWordArr addObject:devices[i][@"passWord"]];
        [self.manufacturerIdArr addObject:devices[i][@"manufacturerId"]];
    }
    
    
    for (int i = 0; i < self.macArr.count; i ++) {
        for (int j = 0; j < self.loadMac.count; j ++) {
            if ([self.macArr[i] isEqualToString:self.loadMac[j]]) {
                NSString *macStr = self.loadMac[j];
                NSString *typeNameStr = self.typeNameArr[j];
                NSString *typeIdStr = self.typeIdArr[j];
                NSString *passWordStr = self.passWordArr[j];
                NSString *manufacturerIdStr = [NSString stringWithFormat:@"%@",self.manufacturerIdArr[j]];
                NSString *buildingNameStr = self.buildingNameArr[j];
                [self.canUseMac addObject:macStr];
                [self.canUseTypeName addObject:typeNameStr];
                [self.canUseBuilding addObject:buildingNameStr];
                [self.canUsePassWord addObject:passWordStr];
                [self.canUseManufacturerIdArr addObject:manufacturerIdStr];
                NSLog(@"\ndeviceMac:%@\n---typeNameStr:%@\n---typeIdStr:%@\n---passWordStr:%@\n---manufacturerIdStr:%@\n---buildingNameStr:%@\n",macStr, typeNameStr,typeIdStr,passWordStr,manufacturerIdStr,buildingNameStr);
            }
        }
    }
    DeviceViewController *deviceVC = [DeviceViewController new];
    [self presentViewController:deviceVC animated:YES completion:nil];
    deviceVC.typeName = self.canUseTypeName;
    deviceVC.building = self.canUseBuilding;
    deviceVC.mac = self.canUseMac;
    deviceVC.passWord  = self.canUsePassWord;
    deviceVC.manufacturerId = self.canUseManufacturerIdArr;
    
    
    /*
    UIAlertController *deviceActionSheet = [UIAlertController alertControllerWithTitle:@"选择需要开启的设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.canUseMac.count; i ++) {
        NSString *mac = _canUseMac                                                                            [i];
        NSString *passWord =_canUsePassWord[i];
        NSString *str = [NSString stringWithFormat:@"%@的%@，mac:%@",_canUseBuilding[i],_canUseTypeName[i],_canUseMac[i]];
        _device = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.mac = mac;
            self.deviceKey = passWord;
            self.scanResult.text = _mac;
            [self openDoorWithMac:_mac];
        }];
       
        [deviceActionSheet addAction:_device];
        
    }
     */
     
    [self.loadMac removeAllObjects];
    [self.buildingNameArr removeAllObjects];
    [self.typeNameArr removeAllObjects];
    [self.typeIdArr removeAllObjects];
    [self.passWordArr removeAllObjects];
    [self.manufacturerIdArr removeAllObjects];

//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                   
//    [deviceActionSheet addAction:cancelAction];
//    [self presentViewController:deviceActionSheet animated:YES completion:nil];

    
    
}

//开门
//- (void)openDoorWithMac:(NSString *)mac{
//    XHOpenDoor *openDoor = [XHOpenDoor new];
//    NSString *deviceKey = self.deviceKey;
//    // NSSt
//    NSString *factory = @"LFDoor";
//    [openDoor openDoorCheckedWithMac:<#(NSString *)#> deviceKey:<#(NSString *)#> manufacturerId:<#(NSString *)#>];
//    NSLog(@"%@----%@",_mac,deviceKey);
//}
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
