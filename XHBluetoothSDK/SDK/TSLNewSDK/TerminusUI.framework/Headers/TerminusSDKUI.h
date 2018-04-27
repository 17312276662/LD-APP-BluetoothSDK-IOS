//
//  TerminusSDKUI.h
//  TerminusUI
//
//  Created by tom on 16/11/19.
//  Copyright © 2016年 LL. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 @class 调用搜索界面
 */
@interface TerminusSDKUI : NSObject

/**
 跳转界面

 @param navigationController 当前界面的UINavigationController
 */
+ (void)pushTerminusVCFromNav:(id/*UINavigationController*/)navigationController;


+ (void)presentTerminusVCFromVC:(id/*UIViewController*/)viewController;
@end
