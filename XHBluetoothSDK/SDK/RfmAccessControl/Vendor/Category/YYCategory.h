//
//  YYCategory.h
//  KEYFree
//
//  Created by yeyufeng on 15/3/26.
//  Copyright (c) 2015年 REFORMER. All rights reserved.
//

#ifndef KEYFree_YYCategory_h
#define KEYFree_YYCategory_h

#import "NSData+YYExtend.h"
#import "NSString+YYExtend.h"

//宏定义
#define YYColorMake(r, g, b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define YYColorMakeHexA(hex, a)     [UIColor colorWithRed:((hex>>16)&0xFF)/255.0 green:((hex>>8)&0xFF)/255.0 blue:(hex&0xFF)/255.0 alpha:a]

#endif

