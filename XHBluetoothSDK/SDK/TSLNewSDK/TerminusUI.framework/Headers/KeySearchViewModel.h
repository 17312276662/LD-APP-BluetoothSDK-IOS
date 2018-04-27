//
//  KeySearchViewModel.h
//  TerminusUI
//
//  Created by Tom on 2017/6/13.
//  Copyright © 2017年 LL. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^TSLRefreshBlock)(NSMutableArray * objArray);


/**
 @class 附近蓝牙搜索处理类
 */
@interface KeySearchViewModel : NSObject

/**
 处理后数据
 */
@property (nonatomic,strong)NSMutableArray * dataSource;

/**
 成功处理数据 block 函数
 */
@property (nonatomic,strong)TSLRefreshBlock commpletBlock;


/**
 处理蓝牙的回调数据

 @param keys 待处理数据源（附近有效开锁钥匙）
 */
- (void)divideIntoGroupsFromKeys:(NSMutableArray *)keys;

@end
