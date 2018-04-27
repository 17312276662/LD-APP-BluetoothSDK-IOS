//
//  TerminusBleCommunicationManager+OpenKeyLog.h
//  Terminus
//
//  Created by tom on 6/30/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TerminusBleCommunicationManager.h"
#import "TslHttpStatus.h"
#import "TSLKeysDataBaseUtils+LogDb.h"
#import "TerminustKeyLogModel.h"
#import "HttpSessionManager.h"

@interface TerminusBleCommunicationManager (OpenKeyLog)

- (void)insertDBLogWith:(TerminusReceiveBean *)bean;

@end
