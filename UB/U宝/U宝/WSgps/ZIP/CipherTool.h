//
//  CipherTool.h
//  Saige4SRemoteDiagnoise
//
//  Created by mac on 13-5-9.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CipherTool : NSObject

+(NSString *)getCipherString:(NSString*)source;
+(NSString *)getOriginString:(NSString *) cipherString;
+(NSString *)getCipherStringForPerference:(NSString *)source;
+(NSString *)getOriginStringForPerference:(NSString *)cipherString;

+(NSData *)stringToByte:(NSString*)string;

+(NSData *)encodeData:(NSData *)data compress:(BOOL)compress encrypt:(BOOL)encrypt;
+(NSData *)decodeData:(NSData *)data;

@end
