
#import <Foundation/Foundation.h>

@interface ZPUiutsHelper : NSObject

//json字符串----> 字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//
////字典----->json字符串

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (UIColor *)colorWithHexString:(NSString *) stringToConvert;

//弹出UIAlertView
+ (UIAlertView *)showAlertView:(NSString *)title Message:(NSString *)message delegate:(id)delegate;

+ (void)deletelastMobileMessage;

+ (void)storeNowMobileLoginResult:(NSDictionary *)result;

+ (NSString *)getdaysFromNowMobile;

+ (NSString *)getlastLoginTimeFromNowMobile;
    
@end
