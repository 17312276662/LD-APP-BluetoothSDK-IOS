//
//  NSString+YYExtend.m
//  AccessController
//
//  Created by yeyufeng on 15/3/10.
//  Copyright (c) 2015年 REFORMER. All rights reserved.
//

#import "NSString+YYExtend.h"

@implementation NSString (YYExtend)

#pragma mark - JSON
//将JSON字符串转为字典对象，字符串需是UTF8编码
- (NSDictionary *)jsonStringToDictionary
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

#pragma mark - URL编码
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&amp;=+$,/?%#[] "),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    return result;
}

#pragma mark - 二进制
// 把一个 表示十六进制数的NSString 转为NSData
- (NSData *)stringToHexData
{
    unsigned long len = [self length] / 2; // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3];
    
    int i;
    for (i=0; i < [self length] / 2; i++)
    {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        byte_chars[2] = 0;
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free(buf);
    return data;
}

@end
