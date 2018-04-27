//
//  TslHttpStatus.h
//  Terminus
//
//  Created by tom on 6/30/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface TslHttpStatus : NSObject

/**
 *  获取当前网络状态
 */
+(NetworkStatus)status;

+(BOOL)isWIFIEnable;

+(BOOL)isNETWORKEnable;




@end
