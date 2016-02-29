//
//  NSDate+Additions.h
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/23.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)


//将字符串格式化为Date对象
+ (NSDate *)dateFromString:(NSString *)datestring formate:(NSString *)formate;
//将日期格式化为NSString对象
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate;
+ (NSString *)fomateString:(NSString *)datestring fromFormate:(NSString *)fromFormate toFormate:(NSString *)toFormate;
/*
 * 世界标准时间UTC /GMT 转为当前系统时区对应的时间
 */
+ (NSDate *)getNowSystemDate:(NSDate *)anyDate;
/*
 *  获取某天起点 凌晨
 */
+ (NSDate *)getZeroDateFromDate:(NSDate *)anyDate;

- (long long)timeIntervalSince1970GMT8;

//获取周几
+ (NSArray *)getWeekdays:(NSArray *)dateNames;
+ (NSString *)getWeekDayFromDate:(NSDate *)date;
/*
 *  获取今天
 */
+ (NSString *)getTodayDateString;
/*
 *  获取昨天
 */
+ (NSString *)getYesturdayDateString;
/*
 *  获取前天
 */
+ (NSDate *)weekTools;
+ (NSString *)getThedaybeforeYesturday;
/*
 *  获取最近30天
 */
+ (NSString *)dateWithOneMonthSinceToday;
/*
 *  获取本周
 */
+ (NSArray *)getnowWeekDateString;
/*
 *  获取上周
 */
+ (NSArray *)getLastWeekDateString;
/*
 *  获取本月
 */
+ (NSArray *)getnowMonthDateString;
/*
 *  获取上月
 */
+ (NSArray *)getLastMonthDateString;


@end
