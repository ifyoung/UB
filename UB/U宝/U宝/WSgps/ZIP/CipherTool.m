//
//  CipherTool.m
//  Saige4SRemoteDiagnoise
//
//  Created by mac on 13-5-9.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CipherTool.h"
#import "LFCGzipUtility.h"

static int EN_KEY[] = { 7, 2, 5, 4, 0, 1, 3, 6 };
static int DE_KEY[] = { 4, 5, 1, 6, 3, 2, 7, 0 };

char* MakeStringCopy (const char* string)
{
    if (string == NULL)
        return NULL;
    
    char* res = (char*)malloc(strlen(string) + 1);
    strcpy(res, string);
    return res;
}

@implementation CipherTool

+(Byte)byteDecryption:(Byte)nSrc {
    Byte nDst = 0;
    Byte nBit = 0;
    int i;
    for (i = 0; i < 8; i++) {
        nBit = (Byte) (1 << DE_KEY[i]);
        if ((nSrc & nBit) != 0)
            nDst |= (1 << i);
    }
    return nDst;
}

+(Byte)byteEncryption:(Byte)nSrc {
    Byte nDst = 0;
    Byte nBit = 0;
    int i;
    for (i = 0; i < 8; i++) {
        nBit = (Byte) (1 << EN_KEY[i]);
        if ((nSrc & nBit) != 0)
            nDst |= (1 << i);
    }
    return nDst;
}

/**
 * 加密，返回加密后的字符串
 *
 * @param source
 *            原字符
 * @return 加密后二进制值的字符串（48.12.30）
 * @throws UnsupportedEncodingException
 */

+(NSString *)getCipherString:(NSString*)source{
    if (!source) {
        return NULL;
    }
    //    NSString *temp =[source stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    Byte *t = (Byte *)[data bytes];
    NSMutableString *newString = [[NSMutableString alloc] init];
    //unichar  %C   char %c
    for (int i = 0; i<[data length]; i++) {
        //        unichar b = (unichar)[self byteEncryption:t[i]];
        //        printf("  %d",(unsigned int)t[i]);
        //        printf("  %d\n",(unsigned int)b);
        
        [newString appendFormat:@"%C",(unichar)[self byteEncryption:t[i]]];
    }
    return newString;
}
/**
 * 解密，传入原先保存的二进制值字符串，返回原字符串
 *
 * @param cipherString
 * @return
 * @throws UnsupportedEncodingException
 */

+(NSString *)getOriginString:(NSString*)source{
    if (!source) {
        return NULL;
    }
    //    NSString *temp =[source stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    Byte* decompressedBytes = (Byte*) malloc(source.length);
    NSString *tempStr = [NSString stringWithString:source];
    for (int i=0;i<source.length;i++){
        decompressedBytes[i] = [self byteDecryption:[tempStr characterAtIndex:i]];
    }
    NSString *ret = [[NSString alloc] initWithBytes:decompressedBytes length:source.length encoding:NSUTF8StringEncoding];
    free(decompressedBytes);
    return ret;
}
/**
 * 加密，返回加密后的字符串
 * 本地保存数据时使用
 *
 * @param source
 *            原字符
 * @return 加密后二进制值的字符串（48.12.30）
 * @throws UnsupportedEncodingException
 */
+(NSString *)getCipherStringForPerference:(NSString *)source {
    
    NSString *s = [NSString stringWithFormat:@"%@",source];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(NSUTF16BigEndianStringEncoding);
    NSData *data = [s dataUsingEncoding:enc];
    Byte *sb = (Byte *)[data bytes];
    
    NSMutableString *sbb = [[NSMutableString alloc] init];
    
    for (int i = 0; i < data.length; i++) {
        Byte t[] = {[self byteEncryption:sb[i]]};
        NSString * c = [[NSString alloc] initWithData:[NSData dataWithBytes:t length:1] encoding:NSUTF8StringEncoding];
        [sbb appendString:c];
        [sbb appendString:@","];
    }
    return sbb;
}

/**
 * 解密，传入原先保存的二进制值字符串，返回原字符串
 * 本地保存数据时使用
 *
 * @param cipherString
 * @return
 * @throws UnsupportedEncodingException
 */
+(NSString *)getOriginStringForPerference:(NSString *)cipherString
{
    
    if (!cipherString)
        return @"";
    NSString *drr = [NSString stringWithFormat:@"%@",cipherString];
    
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(NSUTF16BigEndianStringEncoding);
    //    NSData *data = [drr dataUsingEncoding:enc];
    //    Byte *drrByte = (Byte *)[data bytes];
    NSMutableString *sbb = [[NSMutableString alloc] init];
    NSArray *ary = [drr componentsSeparatedByString:@",\\s*"];
    for (int i = 0; i < [ary count]; i++) {
        Byte t[] = {[self byteDecryption:(Byte)[ary objectAtIndex:i]]};
        [sbb appendString:[[NSString alloc] initWithData:[NSData dataWithBytes:t length:1] encoding:NSUTF8StringEncoding]];
    }
    
    return sbb;
}

+(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

#pragma mark - Inroduced first in GBOSS

static long crcList[256];
static BOOL crcListInited = NO;

+ (long *)CRCList
{
    if( !crcListInited )
    {
        for (uint n = 0; n < 256; n++){
            uint c = n;
            for (int k = 8; --k >= 0;){
                if ((c & 1) != 0)
                    c = 0xedb88320 ^ (c >> 1);
                else
                    c = c >> 1;
            }
            crcList[n] = c;
        }
        crcListInited = YES;
    }
    
    return crcList;
}

+ (long *)CRCList2
{
    static long *crcList = nil;
    
    if( !crcList )
    {
        long crc_table[256];
        for (uint n = 0; n < 256; n++){
            uint c = n;
            for (int k = 8; --k >= 0;){
                if ((c & 1) != 0)
                    c = 0xedb88320 ^ (c >> 1);
                else
                    c = c >> 1;
            }
            crc_table[n] = c;
        }
        crcList = crc_table;
    }
    
    return crcList;
}

+ (unsigned int)CRC32C:(Byte *)buf start:(NSInteger)start length:(NSInteger)length
{
    long dwCRC32 = 0L;
    for(NSInteger i = start; i < start + length; i++){
        dwCRC32 = (dwCRC32<<8) ^ [self CRCList][(int) (((dwCRC32>>24) ^ buf[i]) & 0xFFL)];
    }
    
    return dwCRC32 & 0xFFFFFFFFL;
}

+ (long)CRC32C:(Byte *)buf length:(int)length
{
    return [self CRC32C:buf start:0 length:length];
}

+ (NSData *)encryption:(NSData *)source
{
    Byte *dst = (Byte *)[source bytes];
    for(int i = 0; i < source.length; i++) {
        dst[i] = [self byteEncryption:dst[i]];
    }
    return [NSData dataWithBytes:dst length:source.length];
}

+ (NSData *)decryption:(NSData *)source
{
    Byte *dst = (Byte *)[source bytes];
    for(int i = 0; i < source.length; i++) {
        dst[i] = [self byteDecryption:dst[i]];
    }
    return [NSData dataWithBytes:dst length:source.length];
}

+ (NSData *)encodeData:(NSData *)data compress:(BOOL)compress encrypt:(BOOL)encrypt
{
    if (data == nil || data.length == 0)
        return nil;
    
    if (data.length < 256)
        compress = false;
    
    NSData *source = [[NSData alloc] initWithData:data];
    
    if (compress)
        source = [LFCGzipUtility zipData:source];
    if (encrypt)
        source = [self encryption:source];
    
    NSInteger totallength = source.length + 12;
    Byte *sourceBytes = (Byte *)[source bytes];
    Byte destBytes[totallength];
    
    destBytes[0] = (Byte)0xFE;
    destBytes[1] = (Byte)0x10;
    destBytes[2] = (Byte)(compress ? 1 : 0);
    destBytes[3] = (Byte)(encrypt ? 1 : 0);
    destBytes[4] = (Byte)((totallength >> 8) & 0xFF);
    destBytes[5] = (Byte)(totallength & 0xFF);
    destBytes[6] = (Byte)0x00;
    destBytes[7] = (Byte)0x00;
    memcpy(&destBytes[8], sourceBytes, source.length);
    
    //    uint32_t crc = crc32(0, NULL, 0);
    //    unsigned long creValue1 = crc32(crc, destBytes, totallength - 4);
    unsigned int creValue = [self CRC32C:destBytes start:0 length:totallength - 4];
    
    //    NSData *test = [[NSData alloc] initWithBytes:destBytes length:totallength];
    
    destBytes[source.length + 8] = (Byte)((creValue >> 24) & 0xFF);
    destBytes[source.length + 9] = (Byte)((creValue >> 16) & 0xFF);
    destBytes[source.length + 10] = (Byte)((creValue >> 8) & 0xFF);
    destBytes[source.length + 11] = (Byte)(creValue & 0xFF);
    return [[NSData alloc] initWithBytes:destBytes length:totallength];
}

+ (NSData *)decodeData:(NSData *)data
{
    if (data == nil || data.length == 0 || data.length <= 12)
        return nil;
    
    Byte *source = (Byte *)[data bytes];
    if (source[0] != (Byte)0xFE)
        return nil;
    
    int nlen = [self getShort:source start:4];
    if (nlen != data.length)
        return nil;
    
    unsigned int creValue = [self CRC32C:source start:0 length:data.length - 4];
    unsigned int crc32s = [self getInt:source start:data.length - 4];
    if (creValue != crc32s)
        return nil;
    
    NSData *dest;
    Byte destBytes[data.length - 12];
    memcpy(destBytes, &source[8], data.length - 12);
    dest = [[NSData alloc] initWithBytes:destBytes length:data.length - 12];
    
    if (source[3] == 1) {
        dest = [self decryption:dest];
    }
    
    if (source[2] == 1) {
        dest = [LFCGzipUtility unzipData:dest];
    }
    return dest;
}

+ (short)getShort:(Byte *)buff start:(int)start
{
    int a1 = buff[start] & 0xff;
    int a2 = buff[start + 1] & 0xff;
    
    return (short) ((a1 << 8) + (a2 << 0));
}

+ (unsigned int)getInt:(Byte *)buff start:(NSInteger)start
{
    int a1 = buff[start] & 0xff;
    int a2 = buff[start + 1] & 0xff;
    int a3 = buff[start + 2] & 0xff;
    int a4 = buff[start + 3] & 0xff;
    
    return (a1 << 24) + (a2 << 16) + (a3 << 8) + (a4 << 0);
}

@end
