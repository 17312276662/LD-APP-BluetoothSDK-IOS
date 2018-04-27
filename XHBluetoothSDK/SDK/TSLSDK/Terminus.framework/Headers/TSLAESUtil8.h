//
//  TSLAESUtil8.h
//  TSLSmartKey
//
//  Created by huangdroid on 14-11-13.
//  Copyright (c) 2014年 重庆市特斯联科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    dmEncry,
    dmDecry,
}TDesMode ;
@interface TSLAESUtil8 : NSObject


+ (instancetype)sharedInstance;

///////////////////////加密逻辑//////////////////////////
-(void) initPermutation:(int[])inData;


-(void) conversePermutation:(int[])inData;

-(void) makeKey:(int[])inKey;

-(void) desData:(int)desMode inData:(int[])inData outData:(int[])outData;

-(int) HexToInt:(NSString *)S;

-(int) StrToIntDef:(NSString *)Str Def:(int)Def;

-(NSString *) EncryStr:(NSString *)Str key:(NSString *)Key;

-(NSString *) EncryStrHex:(NSString *)Str key:(NSString *)Key;

-(NSString *) IntToHex:(int)Value;

-(BOOL) IsNumber:(NSString *)str;

-(NSString *) DecryStrHex:(NSString *)Str key:(NSString *)Key;

-(int)getByte:(int) b;
@end
