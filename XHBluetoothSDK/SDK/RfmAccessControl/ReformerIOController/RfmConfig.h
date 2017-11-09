//
//  RfmConfig.h
//  RFM_IOCTL
//
//  Created by yeyufeng on 14-10-13.
//  Copyright (c) 2014年 REFORMER. All rights reserved.
//

#ifndef RFM_IOCTL_RfmConfig_h
#define RFM_IOCTL_RfmConfig_h

///是否打印LOG
#define __FORBIDDEN_YYLog__     //定义此行禁止LOG
//
///Release版本自动禁止LOGO
#ifdef __OPTIMIZE__
    #define YYLog(...)         {}
#elif defined __FORBIDDEN_YYLog__
    #define YYLog(...)         {}
#else
    #define YYLog(...)          YYLog(__VA_ARGS__)
#endif

#endif
