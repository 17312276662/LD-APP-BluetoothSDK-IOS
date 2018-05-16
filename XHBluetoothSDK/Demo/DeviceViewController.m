//
//  DeviceViewController.m
//  XHBluetoothSDK
//
//  Created by Leo on 2018/1/17.
//  Copyright © 2018年 xujw. All rights reserved.
//

#import "DeviceViewController.h"
#import "BlueModel.h"
#import "MBProgressHUD.h"
#import "ViewController.h"
#import "XHOpenDoor.h"
@interface DeviceViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)   NSMutableArray * dataSource;
@property (nonatomic,weak)     MBProgressHUD * HUB;
@property (nonatomic ,strong)  NSMutableArray *cellArr;
@property (nonatomic ,strong)  UITableView *tableView;
//设备名称
@property (nonatomic ,strong)  NSString *deviceName;
@end

@implementation DeviceViewController

- (NSMutableArray *)manufacturerId;
{
    if (!_manufacturerId) {
        _manufacturerId =  [NSMutableArray array];
    }
    return _manufacturerId;
}

- (NSMutableArray *)cellArr;
{
    if (!_cellArr) {
        _cellArr =  [NSMutableArray array];
    }
    return _cellArr;
}

- (NSMutableArray *)building;
{
    if (!_building) {
        _building =  [NSMutableArray array];
    }
    return _building;
}

- (NSMutableArray *)passWord;
{
    if (!_passWord) {
        _passWord =  [NSMutableArray array];
    }
    return _passWord;
}

- (NSMutableArray *)typeName;
{
    if (!_typeName) {
        _typeName =  [NSMutableArray array];
    }
    return _typeName;
}

- (NSMutableArray *)mac;
{
    if (!_mac) {
        _mac =  [NSMutableArray array];
    }
    return _mac;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 375, 600)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(150, 600, 80, 40)];
    btn.backgroundColor = [UIColor purpleColor];
    [btn setTitle:@"收起" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)dissMissView{
    [self dismissViewControllerAnimated:self completion:nil];
    [self.mac removeAllObjects];
    [self.typeName removeAllObjects];
    [self.building removeAllObjects];
    [self.passWord removeAllObjects];
    [self.manufacturerId removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mac.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    for (int i = 0; i < self.mac.count; i ++) {
        self.deviceName = [NSString stringWithFormat:@"%@的%@，mac:%@",_building[i],_typeName[i],_mac[i]];
        [self.cellArr addObject:self.deviceName];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = self.cellArr[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XHOpenDoor *openDoor = [XHOpenDoor new];
    [openDoor openDoorCheckedWithMac:self.mac[indexPath.row] deviceKey:self.passWord[indexPath.row] manufacturerId:self.manufacturerId[indexPath.row]];
    self.tableView.separatorStyle = NO;
    

}
@end
