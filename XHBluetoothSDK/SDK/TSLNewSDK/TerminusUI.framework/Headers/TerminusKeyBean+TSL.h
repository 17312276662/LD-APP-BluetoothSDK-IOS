//
//  TerminusKeyBean+TSL.h
//  TerminusUI
//
//  Created by Tom on 2017/6/13.
//  Copyright © 2017年 LL. All rights reserved.
//

#import <Terminus/TerminusKeyBean.h>

#import "KeyCardModel.h"


/**
 对钥匙实体增加副属性。（末尾加入Overlook 不计入钥匙数据表字段）
 */
@interface TerminusKeyBean (TSL)


/**
 对应所在分类
 */
@property (nonatomic,weak) KeyCardModel * cardModelOverlook;


/**
 是否需要强制刷新界面（数据变更eg：钥匙名称）
 */
@property (nonatomic,assign) BOOL blueModelChangeOverlook;

/**
 最强信号值搜索时间
 */
@property (nonatomic,assign)NSTimeInterval groupStrongRISSTimeOverlook;

/**
 分类类型
 */
@property (nonatomic,copy) NSNumber * keyCardTyeOverlook;


/**
 是否已刷新
 */
@property (nonatomic,assign) BOOL isRefreshedOverlook;


@end
