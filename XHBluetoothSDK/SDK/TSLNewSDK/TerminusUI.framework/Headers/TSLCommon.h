//
//  TSLCommon.h
//  TerminusUI
//
//  Created by tom on 16/11/21.
//  Copyright © 2016年 LL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define SCREENWIDTH_TSL [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT_TSL [UIScreen mainScreen].bounds.size.height


#define kRGB(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]



NSString *getSearchImageBundlePath(NSString *filename);

/**
 @class 工具类
 */
@interface TSLCommon : NSObject


/**
 获设备高度

 @return CGFloat
 */
+ (CGFloat) getViewHeigth;

/**
 是否是Iphone4s

 @return YES or NO
 */
+ (BOOL)isIphone4S;

/**
 停止旋转动画

 @param changeIamge 停止后显示图片
 @param view 待停止旋转的View
 */
+ (void)stopInfiniteRotation:(UIImage *)changeIamge view:(UIView *)view;

/**
 控件旋转

 @param changeIamge 开始旋转的图片
 @param view 待旋转的控件
 */
+ (void)startInfiniteRotation:(UIImage *)changeIamge view:(UIView *)view;
@end

@interface UIColor (TSL)

/**
 16进制的颜色值

 @param hex 颜色值eg:0x000000
 @return UIColor
 */
+ (instancetype)colorFromHex:(int)hex;

/**
 16进制的颜色值

 @param hex 颜色值eg:0x000000
 @param alpha 透明度
 @return UIColor
 */
+ (instancetype)colorFromHex:(int)hex alpha:(CGFloat)alpha;
@end

