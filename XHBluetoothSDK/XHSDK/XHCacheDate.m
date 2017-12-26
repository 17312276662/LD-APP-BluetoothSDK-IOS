//
//  XHCacheDate.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/15.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "XHCacheDate.h"
#import "JWHttpTool.h"
#import "MJExtension.h"
#import "ContentModel.h"
#import "ResourceDatasModel.h"
#import "ResourceKeyModel.h"
#import <CommonCrypto/CommonDigest.h>
#define HTTP_CONECT(x,y)            [NSString stringWithFormat:@"%@%@",x,y]
#define BASE_URL                    @"http://auth.greenlandjs.com:8099/LD-PermissionSystem/appApi"
@implementation XHCacheDate

- (void)loadAlleviceWithMobile:(NSString *)mobile BuildingId:(NSString *)buildingId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *key =@"123qweASDzxc";
    NSString *str = [NSString stringWithFormat:@"mobile=%@&%@",mobile,key];
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *token = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [token appendFormat:@"%02x", digest[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    params[@"buildingId"] = buildingId;
    params[@"mobile"] = mobile;
    params[@"token"] = token;
//    params[@"token"] = @"508b2483832f141306c43459b9199bbe";
    
    [JWHttpTool get:HTTP_CONECT(BASE_URL,@"/queryAvaiableResByMobile") params:params success:^(id json) {
        NSArray *list = [ContentModel mj_objectArrayWithKeyValuesArray:json[@"content"]];
        self.typeNameArr = [NSMutableArray new];
        self.macArr = [NSMutableArray new];
        self.passWordArr = [NSMutableArray new];
        self.manufacturerIdArr = [NSMutableArray new];
        self.typeIdArr = [NSMutableArray new];
        self.buildingNameArr = [NSMutableArray new];
        for (ContentModel *contentModel in list) {
            for (NSDictionary *dict in contentModel.resourceDatas) {
                ResourceDatasModel *resourceDatasModel = [ResourceDatasModel mj_objectWithKeyValues:dict];
                [self.buildingNameArr addObject:resourceDatasModel.buildingName];
                [self.typeNameArr addObject:resourceDatasModel.typeName];
                [self.typeIdArr addObject:@(resourceDatasModel.typeId)];
                for (NSDictionary *dict in resourceDatasModel.resourceKeys) {
                    ResourceKeyModel *resourceKeyModel = [ResourceKeyModel mj_objectWithKeyValues:dict];
                    [self.macArr addObject:resourceKeyModel.mac];
                    [self.manufacturerIdArr addObject:@(resourceKeyModel.manufacturerId)];
                    [self.passWordArr addObject:resourceKeyModel.password];
                }
            }
        }
        self.deviceArr = [NSMutableArray new];
        for (int i = 0; i < self.macArr.count; i ++) {
            NSDictionary *dict  = @{@"mac" : self.macArr[i],
                                    @"typeName" : self.typeNameArr[i],
                                    @"typeId" : self.typeIdArr[i],
                                    @"passWord" : self.passWordArr[i],
                                    @"manufacturerId" : self.manufacturerIdArr[i],
                                    @"buildingName" : self.buildingNameArr[i]
                                    };

            [self.deviceArr addObject:dict];
        }
        NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [cachePatch stringByAppendingPathComponent:@"devices.plist"];
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        [self.deviceArr writeToURL:fileUrl atomically:YES];
        NSLog(@"******%@",cachePatch);
    } failure:^(NSError *error) {
        NSLog(@"稍后再试");
    }];
}
/*
- (void)loadPublicDeviceWithBuildingId:(NSInteger)buildingId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *key =@"123qweASDzxc";
    NSString *str = [NSString stringWithFormat:@"buildingId=%ld&%@",buildingId,key];
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *token = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [token appendFormat:@"%02x", digest[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    params[@"buildingId"] = @(buildingId);
    params[@"token"] = token;
    [JWHttpTool get:HTTP_CONECT(BASE_URL,@"/queryPubResByBuildingId") params:params success:^(id json) {
        NSArray *list = [ContentModel mj_objectArrayWithKeyValuesArray:json[@"content"]];
        self.typeNameArr = [NSMutableArray new];
        self.macArr = [NSMutableArray new];
        self.passWordArr = [NSMutableArray new];
        self.manufacturerIdArr = [NSMutableArray new];
        for (ContentModel *contentModel in list) {
            [self.typeNameArr addObject:contentModel.typeName];
            for (NSDictionary *dict in contentModel.resourceKeys) {
                ResourceKeyModel *resourceKeysModel = [ResourceKeyModel mj_objectWithKeyValues:dict];
                [self.macArr addObject:resourceKeysModel.mac];
                [self.passWordArr addObject:resourceKeysModel.password];
                [self.manufacturerIdArr addObject:@(resourceKeysModel.manufacturerId)];
            }
        }
        NSLog(@"联网加载的公有设备json:%@",json);
    } failure:^(NSError *error) {
        NSLog(@"稍后再试");
    }];
}

- (void)loadPrivateDeviceWithMobile:(NSString *)mobile BuildingId:(NSInteger)buildingId{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *key =@"123qweASDzxc";
    NSString *str = [NSString stringWithFormat:@"buildingId=%ld&mobile=%@&%@",buildingId,mobile,key];
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *token = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [token appendFormat:@"%02x", digest[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    params[@"mobile"] = mobile;
    params[@"buildingId"] = @(1);
    params[@"token"] = token;
    
    [JWHttpTool get:HTTP_CONECT(BASE_URL,@"/queryPrivateResByBIdAndMobile") params:params success:^(id json) {
        //contentModel *model = [contentModel mj_objectWithKeyValues:json];
        //self.mac = model.content.mac;
        //self.deviceKey = model.content.password;
        //self.manufacturerId = model.content.manufacturerId;
        NSLog(@"联网加载的私有设备json:%@",json);
    } failure:^(NSError *error) {
        NSLog(@"稍后再试");
    }];
}
*/

@end
