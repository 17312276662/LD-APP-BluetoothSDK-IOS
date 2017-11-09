//
//  CacheDate.m
//  XHBluetoothSDK
//
//  Created by 欣华pro on 2017/10/15.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "CacheDate.h"
#import "JWHttpTool.h"
#import "MJExtension.h"
#import "ContentModel.h"
#import "ResourceKeyModel.h"
#import <CommonCrypto/CommonDigest.h>
#define HTTP_CONECT(x,y)            [NSString stringWithFormat:@"%@%@",x,y]
#define BASE_URL                    @"http://auth.greenlandjs.com:8099/LD-PermissionSystem/appApi"
@implementation CacheDate

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
@end
