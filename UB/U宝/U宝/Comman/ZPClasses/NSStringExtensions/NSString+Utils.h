

#import <Foundation/Foundation.h>


@interface NSString (Utils)

+(NSString *)removeTrashTab:(NSString *)s;

//是否含有子字符串
- (BOOL)iscontainSubString:(NSString *)substr;

//是否为nil null
- (NSString *)isNullOrNil;

//判断是否有中文
-(BOOL)IsChinese;

/**
 对url字符串进行编码，防止中文乱码
 @returns 返回经编码的url字符串
 */
- (id)urlEncoded;
- (NSString*)urlDecoded;


+ (NSString *)md5:(NSString *)str;


//字符串显示区域
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/*
 利用正则表达式检测邮箱、电话号码、身份证是否合法
 */
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidatePhone:(NSString *)phone;
+ (BOOL)judgeEmailAndPhoneForText:(NSString *)text;


@end
