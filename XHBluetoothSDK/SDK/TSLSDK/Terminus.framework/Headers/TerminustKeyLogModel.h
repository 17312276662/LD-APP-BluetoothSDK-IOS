//
//  TerminustKeyLogModel.h
//  Terminus
//
//  Created by tom on 6/30/16.
//  Copyright © 2016 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TerminustKeyLogModel : NSObject

//锁编码
@property (nonatomic,copy   ) NSString  *LockCode;
//锁类型
@property (nonatomic,copy   ) NSString  *LockType;
//操作结果
@property (nonatomic,assign ) NSInteger Result;
//是否管理员
@property (nonatomic,assign ) NSInteger IsAdmin;
//是否远程开锁
@property (nonatomic,assign ) NSInteger IsRemote;
//花费时间
@property (nonatomic,assign ) NSInteger SpendTime;
//开门时间字符串
//@property (nonatomic,copy) NSString  * CreateTimeString;
//开门时间
@property (nonatomic, copy) NSString    *CreateTime;
@property (nonatomic, copy) NSString * Longitude;
@property (nonatomic, copy) NSString * Latitude;
@property (nonatomic, copy) NSString * Address;

@property (nonatomic, assign) NSInteger  TimeZone;

@property (nonatomic, copy) NSString * UserNickname;

@property (nonatomic, copy) NSString * Protocol;

@property (nonatomic, copy) NSString * IsOneButton;

@property (nonatomic, assign) NSInteger OperationType;

@property (nonatomic, copy) NSString * macAdress;

@property (nonatomic, assign) NSInteger  BlueToothIntensity;

@end
