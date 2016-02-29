//
//  WeatherModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/28.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 data =     {
         pm25 = 38;
         temperature = "26\U2103~32\U2103";
         washIndex = "\U8f83\U9002\U5b9c,DWDFWFWFWFWD,DWFWW";
         weather = "\U591a\U4e91";
 };
 errorCode = 0;
 errorMsg = "<null>";
*/

@interface WeatherModel : NSObject

@property(nonatomic,copy)  NSString *washIndex;
@property(nonatomic,strong)NSNumber *pm25;
@property(nonatomic,copy)  NSString *temperature;
@property(nonatomic,copy)  NSString *weather;

@end
