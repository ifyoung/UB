//
//  CarmileageOutModel.h
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/12.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 data =     {
     details =         (
             {
             date = "2015-10-07";
             distance = "28.18";
             driverTime = "01:39:10";
             oil = "3.6";
             },
      );
     totalDistance = "207.78";
     totalDriverTime = "12:07:37";
     totalOil = "25.6";
 };
 errorCode = 0;
 errorMsg = "<null>";

 
 */
@interface CarmileageOutModel : NSObject

@property(nonatomic,strong)NSArray *details;
@property(nonatomic,assign)double totalDistance;
@property(nonatomic,copy)NSString *totalDriverTime;
@property(nonatomic,assign)double totalOil;

@end
