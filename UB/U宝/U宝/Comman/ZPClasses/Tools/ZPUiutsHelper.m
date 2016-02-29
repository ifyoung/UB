
#import "ZPUiutsHelper.h"

#define SF_COLOR(RED, GREEN, BLUE, ALPHA)	[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA]


@interface ZPUiutsHelper ()

@end
@implementation ZPUiutsHelper : NSObject

/* Create a Foundation object from JSON data. Set the NSJSONReadingAllowFragments option if the parser should allow top-level objects that are not an NSArray or NSDictionary. Setting the NSJSONReadingMutableContainers option will make the parser generate mutable NSArrays and NSDictionaries. Setting the NSJSONReadingMutableLeaves option will make the parser generate mutable NSString objects. If an error occurs during the parse, then the error parameter will be set and the result will be nil.
 The data must be in one of the 5 supported encodings listed in the JSON specification: UTF-8, UTF-16LE, UTF-16BE, UTF-32LE, UTF-32BE. The data may or may not have a BOM. The most efficient encoding to use for parsing is UTF-8, so if you have a choice in encoding the data passed to this method, use UTF-8.
 
+ (id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error;
说的很明白的阿，当参数不是一个数组，或者字典的时候，opt才会传0阿。。。。
 */
//json字符串----> 字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingAllowFragments
                         
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//字典----->json字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+ (UIColor *)colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    //if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    ////NSLog(@"%f:::%f:::%f",((float) r / 255.0f),((float) g / 255.0f),((float) b / 255.0f));
    
    return SF_COLOR(((float) r / 255.0f),((float) g / 255.0f),((float) b / 255.0f), 1);
}


//弹出UIAlertView
+ (UIAlertView *)showAlertView:(NSString *)title Message:(NSString *)message delegate:(id)delegate{
    UIAlertView *aletView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aletView show];
    return aletView;
}


+ (void)deletelastMobileMessage{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[SFHFKeychainUtils getPasswordForUsername:KCSUBUSERACCOUNT andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)storeNowMobileLoginResult:(NSDictionary *)result{
    if(result && [result objectForKey:@"data"]){
        NSString *days = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"days"]];
        NSString *lastLogin = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"lastLogin"]];
        NSDictionary *dic = @{@"days": days,@"lastLogin": lastLogin};
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:[SFHFKeychainUtils getPasswordForUsername:KCSUBUSERACCOUNT andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:KFirtsLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getdaysFromNowMobile{
    NSUserDefaults *userdic = [[NSUserDefaults standardUserDefaults] objectForKey:[SFHFKeychainUtils getPasswordForUsername:KCSUBUSERACCOUNT andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL]];
    NSString *days = [NSString stringWithFormat:@"%@",[userdic objectForKey:@"days"]];
    return days;
}

+ (NSString *)getlastLoginTimeFromNowMobile{
    
    NSUserDefaults *userdic = [[NSUserDefaults standardUserDefaults] objectForKey:[SFHFKeychainUtils getPasswordForUsername:KCSUBUSERACCOUNT andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL]];
    NSString *lastLogin = [NSString stringWithFormat:@"%@",[userdic objectForKey:@"lastLogin"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shenzhen"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:lastLogin.doubleValue / 1000];
    NSString *LastLoginTime = [formatter stringFromDate:confromTimesp];
  return LastLoginTime;
}

@end


