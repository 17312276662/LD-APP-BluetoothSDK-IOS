//
//  DDFileReader.h
//  Terminus
//
//  Created by YuHeng bing on 16/6/27.
//  Copyright © 2016年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDFileReader : NSObject {
    NSString * filePath;
    
    NSFileHandle * fileHandle;
    unsigned long long currentOffset;
    unsigned long long totalFileLength;
    
    NSString * lineDelimiter;
    NSUInteger chunkSize;
}

@property (nonatomic, copy) NSString * lineDelimiter;
@property (nonatomic) NSUInteger chunkSize;

- (id) initWithFilePath:(NSString *)aPath;

- (NSString *) readLine;
- (NSString *) readTrimmedLine;

- (NSSet *) readLines;

#if NS_BLOCKS_AVAILABLE
- (void) enumerateLinesUsingBlock:(void(^)(NSString*, BOOL *))block;
#endif

@end