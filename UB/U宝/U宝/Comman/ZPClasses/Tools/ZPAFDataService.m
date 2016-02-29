

#import "ZPAFDataService.h"
#import "UIDevice+IdentifierAddition.h"

@interface ZPAFDataService ()

@property(nonatomic,copy)NSString *loginStr;

@end
@implementation ZPAFDataService

+ (ZPAFDataService *)shareInstance{
    static ZPAFDataService *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


/*
 *   data不是一定要有值 返回0就行
 */
+ (void)requestWithURL:(NSString *)urlstring params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod block:(CompletionHandle)block{
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",BASE_URL,urlstring];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *get32bitString = [ZPAFDataService get32bitString];
    NSString *timeInterval = [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    NSString *getsignatureString = [ZPAFDataService getsignatureString:get32bitString time:timeInterval];
    [request setValue:get32bitString     forHTTPHeaderField:@"nonce"];
    [request setValue:timeInterval       forHTTPHeaderField:@"stamp"];
    [request setValue:getsignatureString forHTTPHeaderField:@"signature"];
    
    
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    NSString *paramsStr = [ZPUiutsHelper dictionaryToJson:params];
    NSData *postBody = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBody];

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if(data == nil || [data isKindOfClass:[NSNull class]]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
        
                [MBProgressHUD showError:KIndicatorError];
            });
        }else{
            
            id result =  [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingAllowFragments error:nil];
            if(result == nil || [result isKindOfClass:[NSNull class]]){
                dispatch_async(dispatch_get_main_queue(), ^{
                 
                    [MBProgressHUD showError:KIndicatorError];
                });
                
            }else{
                
                   //返回－3，登录失效
                   if([[result objectForKey:KServererrorCodeStr]  isEqual: @-3]){
                        [Interface loginUnUsefulComfirmblock:NULL];
                   }
                
                    //返回非0
                    if(![[result objectForKey:KServererrorCodeStr]  isEqual: @0] &&
                       ![[result objectForKey:KServererrorCodeStr]  isEqual: @-3]
                       ){
                        
                            if ([urlstring isEqualToString:MODIFYMOBILE] ||
                                  [urlstring isEqualToString:MODIFYPASSWORD] ||
                                  [urlstring isEqualToString:CHANGETERMINALDEVICE]) {
                                  if (block != nil){
                                      block(result);
                                  }
                            }
                            else if([urlstring isEqualToString:UBIIlegalQuery]){
                                
                                //不为0 输入违章查询时因为要提示车牌信息错误，所以丢给控制器自己处理
                                //不为0 通过车牌找回密码验证身份，同上
                                [MBProgressHUD hideHUD];
                                
                                if (block != nil){
                                    block(result);
                                }
                            }
                            else if ([urlstring isEqualToString:VERTIFYIDENTITY_URL] ||
                                     [urlstring isEqualToString:SWIPEQRCODEBINDING]
                                     ){
                              
                                if (block != nil){
                                    block(result);
                                }
                            }
                            else{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if([result objectForKey:KServererrorMsgStr] &&
                                       ![[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
                                         [MBProgressHUD showError:[result objectForKey:KServererrorMsgStr]];
                                    }
                                });

                            }
                   }else{//返回0
                         
                                 if ([urlstring isEqualToString:MODIFYMOBILE] || [urlstring isEqualToString:MODIFYPASSWORD] || [urlstring isEqualToString:SUGGEST] || [urlstring isEqualToString:CHANGETERMINALDEVICE]) {
                                     if (block != nil){
                                         block(result);
                                     }
                                 }
                    
                                //data没值的情况也行  绑定车辆、验证码、找回密码 只要返回0即可
                                if([urlstring isEqualToString:SWIPEQRCODEBINDING] ||
                                   [urlstring isEqualToString:VERTIFYIDENTITY_URL]||
                                   [urlstring isEqualToString:VERTIFYCODE] ||
                                   [urlstring isEqualToString:LOOKBACKCODE_URL]
                                  ){
                                
                                    /************************成功**********************/
                                    /************************成功**********************/
                                    if (block != nil) {
                                        block(result);
                                    }

                                }
                                else if([result objectForKey:KServerdataStr] == nil ||
                                   [[result objectForKey:KServerdataStr] isKindOfClass:[NSNull class]]){
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if([result objectForKey:KServererrorMsgStr] &&
                                           ![[result objectForKey:KServererrorMsgStr] isKindOfClass:[NSNull class]]){
                                            [MBProgressHUD showError:[result objectForKey:KServererrorMsgStr]];
                                        }
                                    });

                                }else{
                                    /************************成功**********************/
                                    /************************成功**********************/
                                    if (block != nil) {
                                        block(result);
                                    }
                                }
                  }//Code为0
                
            }//result为真
        }
    }];
}

/*
 *   data必须有值
 */
+ (void)request:(NSString *)urlstring params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod block:(CompletionHandle)block failblock:(FailHandle)failblock{
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",BASE_URL,urlstring];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *get32bitString = [ZPAFDataService get32bitString];
    NSString *timeInterval = [NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    NSString *getsignatureString = [ZPAFDataService getsignatureString:get32bitString time:timeInterval];
    [request setValue:get32bitString     forHTTPHeaderField:@"nonce"];
    [request setValue:timeInterval       forHTTPHeaderField:@"stamp"];
    [request setValue:getsignatureString forHTTPHeaderField:@"signature"];
    
    
    [request setTimeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    NSString *paramsStr = [ZPUiutsHelper dictionaryToJson:params];
    NSData *postBody = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBody];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        
        if(data == nil || [data isKindOfClass:[NSNull class]] ){
                if(failblock != nil){
                    failblock(nil);
                }
        }else{
                id result = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingAllowFragments error:nil];
                if(result == nil || [result isKindOfClass:[NSNull class]] ||
                   ![[result objectForKey:KServererrorCodeStr]  isEqual: @0] ||
                   [result objectForKey:KServerdataStr] == nil ||
                   [[result objectForKey:KServerdataStr] isKindOfClass:[NSNull class]]){
                    
                    //登录失效
                    if([[result objectForKey:KServererrorCodeStr]  isEqual: @-3]){
                        [Interface loginUnUsefulComfirmblock:NULL];
                    }else{
                    
                        if(failblock != nil){
                            failblock(result);
                        }
                    }
                    
                }
                else if ([result objectForKey:KServerdataStr] != nil && ![[result objectForKey:KServerdataStr] isKindOfClass:[NSNull class]]){
                
                    if (block != nil) {
                        block(result);
                    }
                }else{
                    if(failblock != nil){
                        failblock(result);
                    }
                }
        }
    }];
}

//获取城市
+ (void)requestWithURL:(NSString *)urlstring  block:(CompletionHandle)block{
    NSURL *url = [NSURL URLWithString:urlstring];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data == nil || [data isKindOfClass:[NSNull class]]){
            if (block != nil) {
                block(@{});
            }
        }else{
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers  error:nil];
            if(data == nil || [data isKindOfClass:[NSNull class]] || result == nil || [result isKindOfClass:[NSNull class]]){
                if (block != nil) {
                    block(@{});
                }
            }else{
                if (block != nil) {
                    block(result);
                }
            }
        }
    }];
}


//此方法随机产生32位字符串
+ (NSString *)get32bitString{
    //char data[32];
    //for (int x = 0;x < 32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    //return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    NSString *uniqueidentifierinoneapp = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSString *timeInterval = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970] * 1000];

    if([ZPAFDataService shareInstance].loginStr.length == 0)
      [ZPAFDataService shareInstance].loginStr = [NSString stringWithFormat:@"%@%@",uniqueidentifierinoneapp,timeInterval];
    return [ZPAFDataService shareInstance].loginStr;
}
//此方法生成签名字符串
+ (NSString *)getsignatureString:(NSString *)getsignatureString time:(NSString *)time{
    NSArray *array = [NSArray arrayWithObjects:
                      @"seg-st-chinagps1999",
                      time,
                      getsignatureString,
                      nil];
//    NSArray *myary = [array sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
//        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
//    }];
    NSString *combineStr = [array componentsJoinedByString:@""];
    return  [NSString md5:combineStr];
}
@end
