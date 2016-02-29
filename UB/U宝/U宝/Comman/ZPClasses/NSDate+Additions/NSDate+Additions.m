//
//  NSDate+Additions.m
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/23.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

//日期
+ (NSDate *)dateFromString:(NSString *)datestring formate:(NSString *)formate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSLocale *local1 = [NSLocale currentLocale];
    //[dateFormatter setLocale:local1];
    //[dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:formate];
       NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [dateFormatter dateFromString:datestring];
    return date;
}
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:formate];
    //dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    NSString *datestring = [dateFormatter stringFromDate:date];
    return datestring;
}
+ (NSString *)fomateString:(NSString *)datestring fromFormate:(NSString *)fromFormate toFormate:(NSString *)toFormate{
    NSDate *createDate = [NSDate dateFromString:datestring formate:fromFormate];
    NSString *text = [NSDate stringFromDate:createDate formate:toFormate];
    return text;
}

+ (NSDate *)getNowSystemDate:(NSDate *)anyDate{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: anyDate];
    NSDate *localeDate = [anyDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

/*
 *  获取某天起点 凌晨
 */
+ (NSDate *)getZeroDateFromDate:(NSDate *)anyDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |NSMinuteCalendarUnit  | NSSecondCalendarUnit;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:anyDate];
    comps.year = comps.year;
    comps.month = comps.month;
    comps.day = comps.day;
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    
    //零时区时间  2015-10-22 16:00:00 +0000
    NSDate *date = [calendar dateFromComponents:comps];
    
    //时间相同，但时区还是没变 2015-10-23 00:00:00 +0000
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    //时间相同，时区对应,2015-10-23 00:00:00 +0800
    
    
    return localeDate;
}

- (long long)timeIntervalSince1970GMT8{
  
     long long interval  = [self timeIntervalSince1970] * 1000 - 8 * 60 * 60 * 1000;
     return interval;
}


/*!
 *   获取星期几
 */
+ (NSArray *)getWeekdays:(NSArray *)dateNames{
    NSArray *weekArr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSMutableArray *arrays = [NSMutableArray array];
    for(NSObject *obj in dateNames){
        NSString *formate = @"yyyy-MM-dd";
        NSDate *createDate = [NSDate dateFromString:(NSString *)obj formate:formate];
        NSCalendar *Calendar = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSGregorianCalendar];
        NSTimeZone *timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
        [Calendar setTimeZone:timeZone];
        NSDateComponents *weekdayComponents = [Calendar components:NSWeekdayCalendarUnit fromDate:createDate];
        NSInteger weekday = [weekdayComponents weekday] - 1;
        if(weekday == 0){
            weekday = 7;
        }
        [arrays addObject:weekArr[weekday - 1]];
    }
    return  arrays;
}
+(NSString *)getWeekDayFromDate:(NSDate *)date{
    NSArray *weekArr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSCalendar *Calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    [Calendar setTimeZone:timeZone];
    NSDateComponents *weekdayComponents = [Calendar components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekday = [weekdayComponents weekday] - 1;
    if(weekday == 0){
        weekday = 7;
    }
    return   weekArr[weekday - 1];
}

/*
 *  获取今天
 */
+ (NSString *)getTodayDateString{
    NSDate *date = [NSDate date];
    NSString *dateString =  [NSDate stringFromDate:date formate:@"yyyy-MM-dd"];
    return dateString;
}
/*
 *  获取昨天
 */
+ (NSString *)getYesturdayDateString{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];
    NSString *dateString =  [NSDate stringFromDate:date formate:@"yyyy-MM-dd"];
    return dateString;
}
/*
 *  获取前天
 */
+ (NSString *)getThedaybeforeYesturday{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-24*60*60*2];
    NSString *dateString =  [NSDate stringFromDate:date formate:@"yyyy-MM-dd"];
    return dateString;
}

+ (NSDate *)weekTools{
    NSInteger year,month,day,week;
    NSString *weekStr = nil;
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:now];
    year = [comps year];
    week = [comps weekday];
    month = [comps month];
    day = [comps day];
    if(week==1){weekStr=@"星期天";week = 8;
    }else if(week==2){weekStr=@"星期一";
    }else if(week==3){weekStr=@"星期二";
    }else if(week==4){weekStr=@"星期三";
    }else if(week==5){weekStr=@"星期四";
    }else if(week==6){weekStr=@"星期五";
    }else if(week==7){weekStr=@"星期六";
    }else {NSLog(@"error!");}
    NSDate  *date =  [NSDate dateWithTimeIntervalSinceNow:(0 + -24*60*60 * (week - 2))];
    return date;
}
/*
 *  获取本周  （以周一为第一天，周日为最后一天）
 */
+ (NSArray *)getnowWeekDateString{
    
    //本周第一天  周一
    NSString *dateString1 =  [NSDate stringFromDate:[NSDate weekTools] formate:@"yyyy-MM-dd"];
    
    //本周最后一天  周日
    NSDate *date7 = [NSDate dateWithTimeIntervalSinceNow:24*60*60 * 6];
    NSString *dateString7 =  [NSDate stringFromDate:date7 formate:@"yyyy-MM-dd"];

    
    return @[dateString1,dateString7];
}
/*
 *  获取上周  （以周一为第一天，周日为最后一天）
 */
+ (NSArray *)getLastWeekDateString{
    
    //先获取本周的第一天
    NSDate *nowWeekFirstDay  = [NSDate weekTools];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:nowWeekFirstDay];
    comps.day -= 1;
    if(comps.day == 0) {
        comps.month -= 1;
        if(comps.month == 0){
            comps.year -= 1;
        }
    }
    
    //上周最后一天
    NSDate  *lastWeekLastDay =  [cal dateFromComponents:comps];
    NSString *lastWeekLastDayString = [NSDate stringFromDate:lastWeekLastDay formate:@"yyyy-MM-dd"];
    
    //上周第一天
    comps.day -= 6;
    if(comps.day == 0) {
        comps.month -= 1;
        if(comps.month == 0){
            comps.year -= 1;
        }
    }
    NSDate  *lastWeekFirstDay = [cal dateFromComponents:comps];
    NSString *lastWeekFirstDayString = [NSDate stringFromDate:lastWeekFirstDay formate:@"yyyy-MM-dd"];
    return  @[lastWeekFirstDayString,lastWeekLastDayString];
}
/*
 *  获取本月
 */
+ (NSArray *)getnowMonthDateString{
    //本月第一天
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:now];
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    NSString *dateString1 =  [NSDate stringFromDate:firstDay formate:@"yyyy-MM-dd"];
    
    
    //当月天数
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDay];
    NSUInteger numberOfDaysInMonth = range.length;
    comps.day = numberOfDaysInMonth;
    NSDate *lastDay = [cal dateFromComponents:comps];
    NSString *lastDayString31   =  [NSDate stringFromDate:lastDay formate:@"yyyy-MM-dd"];
    
    return @[dateString1,lastDayString31];
}
/*
 *  获取上月
 */
+ (NSArray *)getLastMonthDateString{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:now];
    comps.month = comps.month - 1;
    comps.day =  1;
    if(comps.month == 0){
        comps.year = comps.year - 1;
        comps.month = 12;
    }
    NSDate *firstDay = [cal dateFromComponents:comps];
    NSString *firstDayString =  [NSDate stringFromDate:firstDay formate:@"yyyy-MM-dd"];
    
    //当月天数
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDay];
    NSUInteger numberOfDaysInMonth = range.length;
    comps.day = numberOfDaysInMonth;
    NSDate *lastDay = [cal dateFromComponents:comps];
    NSString *lastDayString   =  [NSDate stringFromDate:lastDay formate:@"yyyy-MM-dd"];
    
    return @[firstDayString,lastDayString];
}

/*
 *  获取最近30天
 */
+ (NSString *)dateWithOneMonthSinceToday{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-60*60*24 * 30];
    NSString *dateString =  [NSDate stringFromDate:date formate:@"yyyy-MM-dd"];
    return dateString;
}

//获取最近八天时间 数组
+(NSMutableArray *)latelyEightTime{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = -i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月d日"];
        //10月15日
        NSString *dateStr = [dateFormatter stringFromDate:curDate];
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];
        //星期四
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        NSString *strTime = [NSString stringWithFormat:@"%@(%@)",dateStr,weekStr];
        [eightArr addObject:strTime];
    }
    return eightArr;
}
//转换英文为中文
+(NSString *)cTransformFromE:(NSString *)theWeek{
    NSString *chinaStr;
    if(theWeek){
        if([theWeek isEqualToString:@"Monday"]){
            chinaStr = @"一";
        }else if([theWeek isEqualToString:@"Tuesday"]){
            chinaStr = @"二";
        }else if([theWeek isEqualToString:@"Wednesday"]){
            chinaStr = @"三";
        }else if([theWeek isEqualToString:@"Thursday"]){
            chinaStr = @"四";
        }else if([theWeek isEqualToString:@"Friday"]){
            chinaStr = @"五";
        }else if([theWeek isEqualToString:@"Saturday"]){
            chinaStr = @"六";
        }else if([theWeek isEqualToString:@"Sunday"]){
            chinaStr = @"七";
        }
    }
    return chinaStr;
}

/*
添加中国标准时间名称缩写

<!-- lang: cpp -->
// 设置并获取时区的缩写
NSMutableDictionary *abbs = [[NSMutableDictionary alloc] init];
[abbs setValuesForKeysWithDictionary:[NSTimeZone abbreviationDictionary]];
[abbs setValue:@"Asia/Shanghai" forKey:@"CCD"];
[NSTimeZone setAbbreviationDictionary:abbs];
NSLog(@"abbs:%@", [NSTimeZone abbreviationDictionary]);
 
 */
@end
