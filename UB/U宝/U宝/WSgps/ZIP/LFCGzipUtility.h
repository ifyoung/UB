/**
 @file LFCGzipUtility.h
 @author Clint Harris (www.clintharris.net)
 
 Note: The code in this file has been commented so as to be compatible with
 Doxygen, a tool for automatically generating HTML-based documentation from
 source code. See http://www.doxygen.org for more info.
 */
#import <Foundation/Foundation.h>
#import "zlib.h"

@interface LFCGzipUtility : NSObject
{
    
}

+ (NSData*) zipData:(NSData*)pUncompressedData;

+ (NSData*) unzipData:(NSData *)compressedData;

+ (NSData*) gzipData:(NSData*)pUncompressedData;

+ (NSData*) ungzipData:(NSData *)compressedData;

+ (NSData*) base64Decode:(NSString *)string;

+ (NSString*) base64Encode:(NSData *)data;

+ (NSString *) zipAndEncode:(NSString *)data;

+ (NSString *) decodeAndUnzip:(NSString *)data;

@end