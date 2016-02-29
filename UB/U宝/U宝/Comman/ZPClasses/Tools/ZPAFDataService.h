

#import <Foundation/Foundation.h>


typedef void(^CompletionHandle)(id result);
typedef void(^FailHandle)(id result);

@interface ZPAFDataService : NSObject

+ (void)requestWithURL:(NSString *)urlstring params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod block:(CompletionHandle)block;

+ (void)request:(NSString *)urlstring params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod block:(CompletionHandle)block failblock:(FailHandle)failblock;

//获取城市
+ (void)requestWithURL:(NSString *)urlstring  block:(CompletionHandle)block;

//此方法随机产生32位字符串
+ (NSString *)get32bitString;

//此方法生成签名字符串
+ (NSString *)getsignatureString:(NSString *)getsignatureString time:(NSString *)time;

@end
