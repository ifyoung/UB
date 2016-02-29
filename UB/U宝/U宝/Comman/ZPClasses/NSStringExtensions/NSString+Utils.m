

#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#define _IPHONE80_ 80000

@implementation NSString (Utils)

+ (NSString *)removeTrashTab:(NSString *)s{
  //只能删除首尾的空格和回车
  s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去空格
    
    return s;
}

//是否含有子字符串 
- (BOOL)iscontainSubString:(NSString *)substr{

        NSRange range = [self rangeOfString:substr];
        if (range.location!=NSNotFound) {
            return YES;
        }else {
            return NO;
        }
}

//是否为nil null
- (NSString *)isNullOrNil{
    if(self == nil || [self isKindOfClass:[NSNull class]]){
        return @"";
    }
    return self;
}


//判断是否有中文
- (BOOL)IsChinese{
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
}


// 处理url中含有中文乱码的问题
- (id)urlEncoded{
    
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,
                                                                             NULL,
                                                                             (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                             kCFStringEncodingUTF8);
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

- (NSString*)urlDecoded
{
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8));
	return result;
}


- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}


//系统的base64编码
/*
- (void)bse64:(NSString *)originStr{
    
    //不能中文啊！！  Man
    NSData* originData = [originStr dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSLog(@"encodeResult:%@",encodeResult);//encodeResult:TWFu
    
    
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:encodeResult options:0];
    
    NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
    
    NSLog(@"decodeStr:%@",decodeStr);//decodeStr:Man
}
*/

+ (NSString *)md5:(NSString *)str {
    if (str == nil) {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)md5:(NSString *)sourceContent {
    if (self == nil || [sourceContent length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([sourceContent UTF8String], (int)[sourceContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}


//字符串显示区域
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


/*
 * 利用正则表达式检测邮箱、电话号码是否合法
 */
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)isValidatePhone:(NSString *)phone{
    NSString *phoneRegex = @"\\b(1)[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@" , phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
+ (BOOL)judgeEmailAndPhoneForText:(NSString *)text{
    NSString* phoneOrEmail = [text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]];
    BOOL isEmail = [self isValidateEmail:phoneOrEmail];
    BOOL isPhone = [self isValidatePhone:phoneOrEmail];
    if(isEmail == YES || isPhone == YES){
        return YES;}
    return NO;
}
@end
