//
//  NSString+YYExtend.h
//  AccessController
//
//  Created by yeyufeng on 15/3/10.
//  Copyright (c) 2015年 REFORMER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YYExtend)

#pragma mark - JSON
- (NSDictionary *)jsonStringToDictionary;

#pragma mark - URL编码
- (NSString *)URLEncodedString;
- (NSString*)URLDecodedString;

#pragma mark - 二进制
// 把一个 表示十六进制数的NSString 转为NSData
- (NSData *)stringToHexData;

@end
