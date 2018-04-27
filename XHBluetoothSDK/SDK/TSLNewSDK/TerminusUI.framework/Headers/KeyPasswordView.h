//
//  KeyPasswordView.h
//  TerminusUISDK
//
//  Created by tom on 11/18/16.
//  Copyright © 2016 LL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TerminusUISDK.h"

@protocol PasswordViewDelegate <NSObject>

-(void)didTouchupIndet:(NSString *)txt;

@end

@class ThemeButton;


@interface TextFieldWithUnderLine : UITextField

@property (nonatomic,strong)UIView *underLine;

@end
/**
 密码修改界面
 */
@interface KeyPasswordView : UIView <UITextFieldDelegate>

/**
 修改后代理
 */
@property (nonatomic,weak)id <PasswordViewDelegate>delegate;

/**
 确定按钮
 */
@property (nonatomic,strong) ThemeButton * sureBtn;

/**
 密码框
 */
@property (nonatomic,strong) TextFieldWithUnderLine *pasword;
@end
