//
//  ZPLocationConverter.h
//  U宝
//
//  Created by 朱鹏的Mac on 15/11/11.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPLocationConverter : NSObject


/**
 *  @brief  世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 *
 *  @param  location    世界标准地理坐标(WGS-84)
 *
 *  @return 中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location;


/**
 *  @brief  中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *  @param  location    中国国测局地理坐标（GCJ-02）
 *
 *  @return 世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location;







/**
 *  @brief  世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
 *
 *  @param  location    世界标准地理坐标(WGS-84)
 *
 *  @return 百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location;


/**
 *  @brief  中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
 *
 *  @param  location    中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  @return 百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location;


/**
 *  @brief  百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  @param  location    百度地理坐标（BD-09)
 *
 *  @return 中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location;


/**
 *  @brief  百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *  @param  location    百度地理坐标（BD-09)
 *
 *  @return 世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location;

/*
CLLocationCoordinate2D gcj02 = CLLocationCoordinate2DMake(114.21892734521,29.575429778924);
CLLocationCoordinate2D bd09 = [JZLocationConverter gcj02ToBd09:gcj02];
NSLog(@%f,%f, bd09.latitude, bd09.longitude);

// http://developer.baidu.com/map/index.php?title=webapi/guide/changeposition
// JZLocationConverter 测试数据: 114.21892734521,29.575429778924  ; 转化结果: 114.224960,29.581853
// 百度api  测试数据: 114.21892734521,29.575429778924  ; 百度api转换结果: 114.22539195429,29.581585367458
*/
@end
