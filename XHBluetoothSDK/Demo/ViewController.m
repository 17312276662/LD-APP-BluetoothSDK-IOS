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
#import "CacheDate.h"
#define kDeviceKey                  @"4c464b47396764765737336f51317936"
#define kDeviceNewKey               @"FFFFFFFFFFFFFFFF3232323232323232"
#define kCardCode                   @"013612345678"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *scanResult;
@property (nonatomic ,strong)  NSArray *macStr;
@property (nonatomic ,assign)  NSString *buildingId;
@property (nonatomic ,strong)  NSString *token;
@property (nonatomic ,strong)  NSString *deviceKey;
@property (nonatomic ,assign)  NSMutableArray *manufacturerId;
@property (nonatomic ,strong)  NSString *factory;
@property (nonatomic ,strong)  NSString *mobile;
@property (nonatomic ,strong)  UIAlertAction *device;
@property (nonatomic ,strong)  NSString *mac;
@property (nonatomic ,strong)  NSMutableArray *macArr;
@property (nonatomic ,strong)  NSMutableArray *passWordArr;
@property (nonatomic ,strong)  NSMutableArray *manufacturerIdArr;
@property (nonatomic ,strong)  NSMutableArray *typeName;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备初始化中......" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissAlertView:) userInfo:alertController repeats:NO];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.buildingId = @"";
    self.mobile = @"";
    //self.mobile = @"13813486976";
    //self.mobile = self.phoneTextField.text;
    CacheDate *date = [CacheDate new];
   // [date loadPublicDeviceWithBuildingId:self.buildingId];
   // [date loadPrivateDeviceWithMobile:self.mobile BuildingId:self.buildingId];
    [date loadAlleviceWithMobile:self.mobile BuildingId:self.buildingId];
    
    
}

- (void)loadDate{
    
    
    CacheDate *date = [CacheDate new];
    self.manufacturerIdArr = [NSMutableArray new];
    self.passWordArr = [NSMutableArray new];
    self.typeName = [NSMutableArray new];
    self.macArr = [[NSMutableArray alloc] initWithArray:date.macArr];
    
}

- (void)dismissAlertView:(NSTimer *)timer{
    UIAlertController *alertView = [timer userInfo];
    [alertView dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDate];
    [self initDevice];
    [self.btnInit addTarget:self action:@selector(initDevice) forControlEvents:UIControlEventTouchUpInside];
    
    [self.macOpenDoor addTarget:self action:@selector(openDoorWithMac:) forControlEvents:UIControlEventTouchUpInside];
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
    XHDeviceScan *scan = [XHDeviceScan new];
    [scan showDevice];
    _macStr = scan.macStr;
    UIAlertController *deviceActionSheet = [UIAlertController alertControllerWithTitle:@"选择需要开启的设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < _macStr.count; i ++) {
        NSString *mac = _macStr[i];
        _device = [UIAlertAction actionWithTitle:mac style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.mac = mac;
            self.scanResult.text = _mac;
            [self openDoorWithMac:_mac];
            NSLog(@"viewController里面的mac:%@",_mac);
        }];
        /*
        ^(UIAlertAction * _Nonnull action) {
        [self openDoorWithMac:_mac];
        self.mac = mac;
        self.scanResult.text = _mac;
    }*/
    
        [deviceActionSheet addAction:_device];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                   
    [deviceActionSheet addAction:cancelAction];
    
    [self presentViewController:deviceActionSheet animated:YES completion:nil];
    
}

//开门
- (void)openDoorWithMac:(NSString *)mac{
    XHOpenDoor *openDoor = [XHOpenDoor new];
    NSString *deviceKey = kDeviceKey;
   // NSString *macStr = _macStr;
    NSString *time = @"60";
    NSString *factory = @"LFDoor";
    [openDoor openDoorCheckedWithMac:_mac deviceKey:deviceKey outputActiveTime:time factory:factory];
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
