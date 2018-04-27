//
//  ThemeButton.h
//  TerminusUISDK
//
//  Created by tom on 11/18/16.
//  Copyright © 2016 LL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminusUISDK.h"

@interface ThemeButton : UIButton

@property (nonatomic,strong)CALayer *customlayer;
- (id)initWithString:(NSString *)str width:(CGFloat)width;
@end
