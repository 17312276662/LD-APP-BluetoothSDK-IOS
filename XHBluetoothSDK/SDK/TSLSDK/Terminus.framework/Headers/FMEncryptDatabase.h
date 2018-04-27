//
//  FMEncryptDatabase.h
//  Terminus
//
//  Created by tom on 15/12/23.
//  Copyright © 2015年 重庆市特斯联科技有限公司. All rights reserved.
// 数据库加密

#import "FMDatabase.h"

@interface FMEncryptDatabase : FMDatabase

/** 如果需要自定义encryptkey，可以调用这个方法修改（在使用之前）*/
+ (void)setEncryptKey:(NSString *)encryptKey;

+ (NSString *)key;
@end