//
//  ColumnPropertyMappingDelegate.h
//  Terminus
//
//  Created by tom on 11/14/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ColumnPropertyMappingDelegate <NSObject>

//每个实体对象的数据库必须实现主键
@required
- (NSString *)primary;
@optional
- (NSDictionary *)columnPropertyMapping;
//数据库已经创建 但是由于后续业务增加  增加了列 则必须实现该代理 @{@"name(增加的字段)":@"type(类型)"}
- (NSDictionary *) addTableLine;
@end
