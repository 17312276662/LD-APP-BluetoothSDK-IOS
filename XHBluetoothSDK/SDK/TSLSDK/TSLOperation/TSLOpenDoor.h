//
//  TSLOpenDoor.h
//  XHBluetoothSDK
//
//  Created by Leo on 2017/11/23.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Terminus/TerminusApi.h>
@interface TSLOpenDoor : NSObject <TerminusBleDelegate>
@property (nonatomic,weak)TerminusBleCommunicationManager * bleManger;
@property (nonatomic ,strong)  NSMutableArray *keysArr;
//@property (nonatomic ,strong)  NSMutableArray *dataSource;
- (void)openDoor;
@end
