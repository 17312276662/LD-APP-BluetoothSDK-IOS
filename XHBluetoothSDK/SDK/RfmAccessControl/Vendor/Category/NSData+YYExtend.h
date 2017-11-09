//
//  NSData+YYExtend.h
//  AccessController
//
//  Created by yeyufeng on 15/3/12.
//  Copyright (c) 2015年 REFORMER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YYExtend)

- (NSString *)dataToHexString;
- (instancetype)initWithUint32_t:(uint32_t)dataInt;

@end
