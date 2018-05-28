//
//  XHBluetoothDevicesView.m
//  XHBluetoothSDK
//
//  Created by Leo on 2018/5/21.
//  Copyright © 2018年 xujw. All rights reserved.
//

#import "XHBluetoothDevicesView.h"
#import <Terminus/TerminusApi.h>
#import "BlueModel.h"
#import "XHCacheDate.h"
#import "XHDeviceScan.h"
#import "XHOpenDoor.h"
#import "ViewController.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define bluetoothDeviceIdentifier @"bluetoothDeviceIdentifier"
#define WeakSelf __weak typeof(self) weakSelf = self;
@interface blueModel : NSObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic) NSNumber * rssi;
@end
@implementation blueModel

@end

@interface XHBluetoothDevicesView () <TerminusBleDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)  NSMutableArray *macArr;
@property (nonatomic,weak) TerminusBleCommunicationManager *blueManger;
@property (nonatomic ,strong)  NSString *blueName;
@property (nonatomic ,strong)  UITableView *bluetoothDeviceView;
@property (nonatomic ,strong)  CBPeripheral *peripheral;
@property (nonatomic ,strong)  UIView *backgroundView;

@property (nonatomic ,strong)  XHCacheDate *date;
@property (nonatomic ,assign)  NSString *buildingId;
@property (nonatomic ,strong)  NSString *token;
@property (nonatomic ,strong)  NSString *deviceKey;
@property (nonatomic ,strong)  NSString *factory;

@property (nonatomic ,strong)  NSMutableArray *passWordArr;
@property (nonatomic ,strong)  NSMutableArray *manufacturerIdArr;
@property (nonatomic ,strong)  NSMutableArray *typeNameArr;
@property (nonatomic ,strong)  NSMutableArray *typeIdArr;
@property (nonatomic ,strong)  NSMutableArray *buildingNameArr;


@property (nonatomic ,strong)  NSMutableArray *canUseMac;
@property (nonatomic ,strong)  NSMutableArray *canUsePassWord;
@property (nonatomic ,strong)  NSMutableArray *canUseBuilding;
@property (nonatomic ,strong)  NSMutableArray *canUseTypeName;
@property (nonatomic ,strong)  NSMutableArray *canUseManufacturerIdArr;

@property (nonatomic ,strong)  NSMutableArray *loadMac;
@property (nonatomic ,strong)  NSMutableArray *tslMacArr;
@property (nonatomic ,strong)  NSMutableArray *lfMacArr;

//设备名称
@property (nonatomic ,strong)  NSString *deviceName;
@property (nonatomic ,strong)  NSMutableArray *cellArr;
@property (nonatomic ,strong)  NSMutableArray *arr;
@property (nonatomic ,strong)  NSMutableArray *dataSource;

@property(nonatomic,strong) TerminusKeyBean * keyBean;
@property (nonatomic ,strong)  NSString *keyUid;
@property (nonatomic ,strong)  NSString *phoneName;
@property (nonatomic ,strong)  NSMutableArray *keyUidArr;
@property (nonatomic ,strong)  NSMutableArray *tslMacAddress;

@property (nonatomic ,strong)  ViewController *vc;


@end

@implementation XHBluetoothDevicesView

- (NSMutableArray *)dataSource;
{
    if (!_dataSource) {
        _dataSource =  [NSMutableArray array];
    }
    return _dataSource;
}

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

- (NSMutableArray *)cellArr;
{
    if (!_cellArr) {
        _cellArr =  [NSMutableArray array];
    }
    return _cellArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    NSLog(@"1");
    if (self = [super initWithFrame:frame]) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBluetoothView)];
        [_backgroundView addGestureRecognizer:tapGesture];
        [self addSubview:_backgroundView];
        
        _bluetoothDeviceView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.frame.size.width, screenHeight - 150) style:UITableViewStylePlain];
        _bluetoothDeviceView.backgroundColor = [UIColor whiteColor];
        _bluetoothDeviceView.delegate = self;
        _bluetoothDeviceView.dataSource  = self;
        [self.bluetoothDeviceView registerClass:[UITableViewCell class] forCellReuseIdentifier:bluetoothDeviceIdentifier];
        [self addSubview:_bluetoothDeviceView];
        
        XHDeviceScan *scan = [XHDeviceScan new];
        [scan initSDK];
    }
    return self;
}

- (void)findDeviceWith:(NSString *)mobile withBuildingId:(NSString *)buildingId{
    NSLog(@"2");
    self.mobile = mobile;
    self.buildingId = buildingId;
    [self findDevices];
}

- (void)findDevices{
    NSLog(@"3");
    self.tslMacArr = [NSMutableArray array];
    self.lfMacArr = [NSMutableArray array];
    self.macArr = [NSMutableArray array];
    
    XHDeviceScan *scan = [XHDeviceScan new];
    [scan showDevice];
    [_lfMacArr addObjectsFromArray:(NSArray *)scan.macArr];
    [_macArr addObjectsFromArray:(NSArray *)self.lfMacArr];
    
    _date = [XHCacheDate new];
//    self.buildingId = @"";
//    self.mobile = @"13813486976";
    [_date loadAlleviceWithMobile:self.mobile BuildingId:self.buildingId];
    
    [[TerminusBleCommunicationManager shareManagerInstance] ClearBleConnectCache];
    self.blueManger = [TerminusBleCommunicationManager shareManagerInstance];
    self.blueManger.TBLEDelegate = self;
    [self.blueManger startScanDevice:nil];
    
    
}

- (void)showDevice{
    NSLog(@"4");
    
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
    [self initTSLDevice];
}

- (void)showBluetoothView{
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = !self.isHidden;
        self.backgroundView.alpha = 0.3;
        self.bluetoothDeviceView.frame = CGRectMake(0, 150, self.frame.size.width, screenHeight - 150);
    }];
}

- (void)hideBluetoothView {
    NSLog(@"5");
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = !self.isHidden;
        self.backgroundView.alpha = 0;
        self.bluetoothDeviceView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self.bluetoothDeviceView removeFromSuperview];
    }];
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"6");
    return self.canUseMac.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"7");
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:bluetoothDeviceIdentifier];
    for (int i = 0; i < self.canUseMac.count; i ++) {
        self.deviceName = [NSString stringWithFormat:@"%@的%@，mac:%@",_canUseBuilding[i],_canUseTypeName[i],_canUseMac[i]];
        [self.cellArr addObject:self.deviceName];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = self.cellArr[indexPath.row];
    return cell;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"8");
//    [self TSLOpenDoor];
    if ([self.canUseManufacturerIdArr[indexPath.row] isEqualToString:@"1"]) {
        
        NSString *str = self.canUseMac[indexPath.row];
        for (int i = 0; i < self.tslMacAddress.count; i ++) {
            NSString *str1 = [str substringFromIndex:4];
            if ([str1 isEqualToString:self.tslMacAddress[i]]) {
                self.keyUid = self.keyUidArr[i];
                [self TSLOpenDoorWith:self.keyUid];
            }
        }
        
    }else{
        XHOpenDoor *openDoor = [XHOpenDoor new];
        [openDoor openDoorCheckedWithMac:self.canUseMac[indexPath.row] deviceKey:self.canUsePassWord[indexPath.row] manufacturerId:self.canUseManufacturerIdArr[indexPath.row]];
        NSLog(@"立方开门成功");
    }
    self.bluetoothDeviceView.separatorStyle = NO;
}

- (void)initTSLDevice{
    NSLog(@"9");
    //是否是管理员
    BOOL isAdmin = NO;
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
    self.phoneName = phoneName;
    for (int i = 0; i < self.canUseManufacturerIdArr.count; i ++) {
        if ([self.canUseManufacturerIdArr[i] isEqualToString:@"1"]) {
            if (isAdmin) {
                [self.blueManger setPierWithPierPwd:self.canUsePassWord[i] NewPwd:@"123456" IsAdmin:YES UserName:phoneName];
            }else{
                [self.blueManger setPierWithPierPwd:self.canUsePassWord[i] NewPwd:nil IsAdmin:NO UserName:phoneName];
            }
            
            if (isAdmin) {
                [self.blueManger StartCommonCommunication:nil MacAddress:self.blueName UUID:nil ControlID:BluetoothOperationPierUpdatePWD LockCode:nil KeyCate:-1];
            }else{
                [self.blueManger StartCommonCommunication:nil MacAddress:self.blueName UUID:nil ControlID:BluetoothOperationPierUnupdatePWD LockCode:nil KeyCate:-1];
            }
        }
    }
    
}

- (void)TSLOpenDoorWith:(NSString *)keyUid{
    NSLog(@"10");
    NSDictionary *dic = [NSDictionary dictionary];
    dic = @{
            TerminusKeyUid:keyUid,
            TerminusKeyUserPhone:self.phoneName, //可选参数
            };
    [self.blueManger StartCommonCommunicationWithData:dic operation:BluetoothOperationHandleOpenDoor LockCode:nil KeyCate:-1];
    NSLog(@"特斯联开门成功");
}

#pragma mark - TerminusBleDelegate
- (void)didFoundBleDevice:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"11");
    NSString * deviceLocalName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if (!deviceLocalName) {
        deviceLocalName = peripheral.name;
    }
    for (BlueModel *model in self.tslMacArr) {
        if ([model.name isEqualToString:deviceLocalName]){
            model.rssi = RSSI;
            [self.bluetoothDeviceView reloadData];
            return;
        }
    }
    BlueModel * newModel = [BlueModel new];
    self.blueName = deviceLocalName;
    newModel.rssi = RSSI;
    [self.tslMacArr addObject:self.blueName];
    [_macArr addObjectsFromArray:(NSArray *)self.tslMacArr];
    [self showDevice];
    [self.bluetoothDeviceView reloadData];
}

- (void)didBluetoothReaceivedErrorCode:(BluetoothErrorCodes)code operation:(BluetoothOperation)operation error:(NSError *)error {
    NSLog(@"12");
    NSLog(@"%@", error);
}

- (void)didReceiveData:(id)data {
    NSLog(@"13");
    self.keyUidArr = [NSMutableArray array];
    self.tslMacAddress = [NSMutableArray array];
    TerminusReceiveBean *tempResData = data;
    TerminusKeyBean *tempKey = tempResData.receiveBean;
    self.keyUid = tempKey.keyUid;
    [self.tslMacAddress addObject:tempKey.macAddress];
    [self.keyUidArr addObject:self.keyUid];
}


@end
