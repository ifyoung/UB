//
//  SeekparamModel.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/6/17.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "SeekparamModel.h"

@implementation SeekparamModel

+ (SeekparamModel *)shareInstance{
    
    static SeekparamModel *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)init{

    self =  [super init];
    if(self){
      
        
         NSString *str = [SFHFKeychainUtils getPasswordForUsername:@"UserLocationCity" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
        
         NSString *str1 = [SFHFKeychainUtils getPasswordForUsername:@"UserProvinceNickName1" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
      
        
         self.city =  str == nil? KLocationCity:str;
         self.cityNickName = str1 == nil? KCityNikeName:str1;
      
        
         self.plateNo =  @"";   //@"BK17X0";
         self.vin =      @"";   //@"178677";
         self.engineNo = @"";   //@"586W";
    }
    
    return self;
}

@end
