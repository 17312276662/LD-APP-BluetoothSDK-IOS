//
//  TSLKeyOpenViewController.h
//  TerminusUI
//
//  Created by Tom on 2017/6/12.
//  Copyright © 2017年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Terminus/TerminusApi.h>

/**
 @class 开锁界面
 */
@interface TSLKeyOpenViewController : UIViewController

/**
 开锁界面的开锁对象
 */
@property (nonatomic,strong)TerminusKeyBean * keybean;

/**
 设置开锁界面的蓝牙对象 （在调用present 方法之前使用的，直接开锁）

 @param bean 开锁实体
 */
- (void)setCurrentModel:(TerminusKeyBean *)bean;

/**
 present 的blok 中使用
 */
- (void) openAnimation ;
@end
