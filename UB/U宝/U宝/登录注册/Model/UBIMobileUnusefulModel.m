//
//  UBIMobileUnusefulModel.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBIMobileUnusefulModel.h"

@implementation UBIMobileUnusefulModel
+ (UBIMobileUnusefulModel *)shareInstance{
    
    static UBIMobileUnusefulModel *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)init{
    
    self =  [super init];
    if(self){
        
        
        NSString *str1 = [SFHFKeychainUtils getPasswordForUsername:@"UserProvinceNickName1" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
        self.mobile =   @"";         //@"";
        self.cityNickName = str1 == nil? KCityNikeName:str1;
        self.plateNo =  @"";              //@"";
        self.vin =     @"";    //@"";
        self.engineNo =  @"";            //@"";
    }
    
    return self;
}

@end
