//
//  PrpceedsTotailDetailModel.h
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/14.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 date = "2015-10-09";
 
 distanceIncome = "0.33";
 income = "0.33";
 
 greenIncome = 0;
 safeIncome = 0;
 */
@interface PrpceedsTotailDetailModel : NSObject

@property (nonatomic,copy)NSString *date;
@property (nonatomic,assign)double distanceIncome;
@property (nonatomic,assign)double income;
@property (nonatomic,assign)double greenIncome;
@property (nonatomic,assign)double safeIncome;

@end

/*
  {"errorCode":0,
      "errorMsg":null,
      "data":
      {"totalIncome":36.67,
          "details":[
            {"date":"2015-09-15","income":0.27,"distanceIncome":0.27,"greenIncome":0.0,"safeIncome":0.0},
            {"date":"2015-09-16","income":0.23,"distanceIncome":0.23,"greenIncome":0.0,"safeIncome":0.0}
          {"date":"2015-09-17","income":4.22,"distanceIncome":2.22,"greenIncome":0.0,"safeIncome":2.0},{"date":"2015-09-18","income":1.69,"distanceIncome":0.69,"greenIncome":0.0,"safeIncome":1.0},{"date":"2015-09-19","income":0.46,"distanceIncome":0.46,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-20","income":0.06,"distanceIncome":0.06,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-21","income":0.8,"distanceIncome":0.8,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-22","income":0.25,"distanceIncome":0.25,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-23","income":0.86,"distanceIncome":0.86,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-24","income":0.5,"distanceIncome":0.5,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-25","income":0.24,"distanceIncome":0.24,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-26","income":0.36,"distanceIncome":0.36,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-27","income":0.02,"distanceIncome":0.02,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-28","income":0.3,"distanceIncome":0.3,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-09-29","income":1.12,"distanceIncome":0.12,"greenIncome":0.0,"safeIncome":1.0},{"date":"2015-09-30","income":0.24,"distanceIncome":0.24,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-01","income":1.51,"distanceIncome":0.51,"greenIncome":0.0,"safeIncome":1.0},{"date":"2015-10-02","income":1.49,"distanceIncome":0.49,"greenIncome":0.0,"safeIncome":1.0},{"date":"2015-10-03","income":0.48,"distanceIncome":0.48,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-04","income":0.05,"distanceIncome":0.05,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-05","income":0.12,"distanceIncome":0.12,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-06","income":0.03,"distanceIncome":0.03,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-07","income":0.18,"distanceIncome":0.18,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-08","income":0.22,"distanceIncome":0.22,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-09","income":0.33,"distanceIncome":0.33,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-10","income":1.3,"distanceIncome":0.3,"greenIncome":0.0,"safeIncome":1.0},{"date":"2015-10-11","income":1.0,"distanceIncome":0.0,"greenIncome":1.0,"safeIncome":0.0},{"date":"2015-10-12","income":0.32,"distanceIncome":0.32,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-13","income":0.19,"distanceIncome":0.19,"greenIncome":0.0,"safeIncome":0.0},{"date":"2015-10-14","income":1.0,"distanceIncome":0.0,"greenIncome":1.0,"safeIncome":0.0}],"income":0.0,"distanceIncome":0.0,"greenIncome":0.0,"safeIncome":0.0}}
 */
