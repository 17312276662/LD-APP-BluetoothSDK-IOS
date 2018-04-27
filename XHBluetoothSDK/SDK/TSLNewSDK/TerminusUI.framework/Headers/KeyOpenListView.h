//
//  KeyOpenListView.h
//  NTSLTerminus
//
//  Created by tom on 16/1/22.
//  Copyright © 2016年 tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminusUISDK.h"

typedef void(^disMissBlock)(BOOL isFinish);

@protocol seletKeyModelDelegate <NSObject>

@optional
- (void)didSelectKeyModel:(TerminusKeyBean *)model;

@end



/**
 @class 钥匙列表View
 */
@interface KeyOpenListView : UIView


/**
 delegate
 */
@property (nonatomic, weak  ) id<seletKeyModelDelegate> delegate;

/**
 显示钥匙列表界面

 @param aView 显示的View
 @param image 背景颜色
 @param animated 是否弹出动画
 */
- (void)showInView:(UIView *)aView backgroundImg:(UIImage *)image animated:(BOOL)animated;

@end

extern NSString *const kPublicKeyVersionKey;
extern const NSInteger PUBLIC_KEY_VERSION;
