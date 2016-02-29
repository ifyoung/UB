//
//  OMAMovingAnnotationView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/29.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface OMAMovingAnnotationView : MAAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView;

@property (nonatomic, strong) UIImageView *imageView;

- (void)removeOMAMovingAnnotationAngleChangedNocaiton;

@end
