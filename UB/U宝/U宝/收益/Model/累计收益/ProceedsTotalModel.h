//
//  ProceedsTotalModel.h
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/13.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 data =     {
     details =    ();
     distanceIncome = 0;
     greenIncome = 0;
     income = 0;
     safeIncome = 0;
     totalIncome = "35.67";
 };
 errorCode = 0;
 errorMsg = "<null>";

 */
/*
{"errorCode":0,"errorMsg":null,"data":
    {   "totalIncome":35.13,
        "details":[{"date":"2015-09-27","income":1.0,"distanceIncome":0.0,"greenIncome":1.0,"safeIncome":0.0},{"date":"2015-09-28","income":0.41,"distanceIncome":0.41,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-29","income":0.38,"distanceIncome":0.38,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-30","income":0.41,"distanceIncome":0.41,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-01","income":0.08,"distanceIncome":0.08,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-02","income":0.16,"distanceIncome":0.16,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-03","income":1.0,"distanceIncome":0.0,"greenIncome":1.0,"safeIncome":0.0},{"date":"2015-10-04","income":1.0,"distanceIncome":0.0,"greenIncome":1.0,"safeIncome":0.0},{"date":"2015-10-05","income":1.0,"distanceIncome":0.0,"greenIncome":1.0,"safeIncome":0.0},{"date":"2015-10-06","income":2.31,"distanceIncome":1.31,"greenIncome":0.0,"safeIncome":1.0},{"date":"2015-10-07","income":0.7,"distanceIncome":0.7,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-08","income":0.45,"distanceIncome":0.45,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-09","income":0.39,"distanceIncome":0.39,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-10","income":0.28,"distanceIncome":0.28,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-11","income":1.0,"distanceIncome":0.0,"greenIncome":1.0,"safeIncome":0.0},{"date":"2015-10-12","income":0.2,"distanceIncome":0.2,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-13","income":1.0,"distanceIncome":0.0,"greenIncome":1.0,"safeIncome":0.0},{"date":"2015-10-14","income":0.4,"distanceIncome":0.4,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-15","income":0.44,"distanceIncome":0.44,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-16","income":0.24,"distanceIncome":0.24,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-17","income":0.07,"distanceIncome":0.07,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-18","income":1.15,"distanceIncome":0.15,"greenIncome":0.0,"safeIncome":1.0},{"date":"2015-10-19","income":0.48,"distanceIncome":0.48,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-20","income":0.12,"distanceIncome":0.12,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-21","income":0.12,"distanceIncome":0.12,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-22","income":0.17,"distanceIncome":0.17,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-23","income":0.08,"distanceIncome":0.08,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-24","income":0.1,"distanceIncome":0.1,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-25","income":1.0,"distanceIncome":0.0,"greenIncome":1.0,"safeIncome":0.0},{"date":"2015-10-26","income":0.19,"distanceIncome":0.19,"greenIncome":0.0,"safeIncome":0.0}],
        "income":0.0,
        "distanceIncome":0.0,
        "greenIncome":0.0,
        "safeIncome":0.0}}
 */
@interface ProceedsTotalModel : NSObject

@property (nonatomic,strong)NSArray  *details;

@property (nonatomic,assign)double distanceIncome;
@property (nonatomic,assign)double greenIncome;
@property (nonatomic,assign)double income;
@property (nonatomic,assign)double safeIncome;

@property (nonatomic,assign)double totalIncome;

@end
