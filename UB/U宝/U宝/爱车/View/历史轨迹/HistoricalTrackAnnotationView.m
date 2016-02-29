//
//  HistoricalTrackAnnotationView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/13.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "HistoricalTrackAnnotationView.h"
#import "CarHomeAnnotaton.h"
#import "CarAnnotationModel.h"

@implementation HistoricalTrackAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView{
    
    static NSString *ID = @"HistoricalTrackAnnotationView";
    HistoricalTrackAnnotationView *annoView = (HistoricalTrackAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[HistoricalTrackAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}

- (void)setAnnotation:(id<MAAnnotation>)annotation{
    [super setAnnotation:annotation];
    
    CarHomeAnnotaton *anno = (CarHomeAnnotaton *)annotation;
    
    self.image = [UIImage imageNamed:anno.carmodel.icon];
    
    self.centerOffset = CGPointMake(0, -self.image.size.height  / 2.0);
}
@end
