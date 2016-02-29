//
//  OMAMovingAnnotationView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/7/29.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "OMAMovingAnnotationView.h"
#import "HistoricalCarLocationAnnatation.h"
#import "CarAnnotationModel.h"
#define kWidth          70.f
#define kHeight         70.f


@interface OMAMovingAnnotationView (){
  
}

@end
@implementation OMAMovingAnnotationView

+ (instancetype)annotationViewWithMapView:(MAMapView *)mapView{
    
    static NSString *ID = @"OMAMovingAnnotationView";
    OMAMovingAnnotationView *annoView = (OMAMovingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil){
        
        annoView = [[OMAMovingAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}

- (id)initWithFrame:(CGRect)frame{
  
    self = [super initWithFrame:CGRectMake(0.f, 0.f, kWidth, kHeight)];
    if(self){
    
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *circle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"car-icon2-0"]];
        circle.frame = CGRectMake(0.f, 0.f, kWidth, kHeight);
        [self addSubview:circle];
        
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.size = CGSizeMake(30, 15);
        self.imageView.center = self.center;
        [self addSubview:self.imageView];
        self.imageView.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)addOMAMovingAnnotationAngleChangedNocaiton{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(angleChangeAction:) name:@"OMAMovingAnnotationAngleChangedNocaiton" object:nil];
}
- (void)removeOMAMovingAnnotationAngleChangedNocaiton{
      [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OMAMovingAnnotationAngleChangedNocaiton" object:nil];
}


- (void)angleChangeAction:(NSNotification *)notificaiton{
    float angle = [notificaiton.object floatValue];
    [UIView animateWithDuration:0.25 animations:^{
         self.imageView.transform  =  CGAffineTransformMakeRotation(angle);
    }];
}


- (void)setAnnotation:(id<MAAnnotation>)annotation{
    [super setAnnotation:annotation];
    
    if([annotation isKindOfClass:[HistoricalCarLocationAnnatation class]]){
        //没轨迹显示最后位置
      HistoricalCarLocationAnnatation *anno = (HistoricalCarLocationAnnatation *)annotation;
      self.imageView.size = CGSizeMake(15, 30);
      self.imageView.center = CGPointMake(kWidth / 2.0, kHeight / 2.0);
      self.imageView.image = [UIImage imageNamed:anno.carmodel.icon];
      self.imageView.transform = CGAffineTransformMakeRotation(M_PI_4 * anno.carmodel.direction);
    }else{
        //有轨迹
      self.imageView.image = [UIImage imageNamed:@"Pgreen-car-right"];
      [self removeOMAMovingAnnotationAngleChangedNocaiton];
      [self addOMAMovingAnnotationAngleChangedNocaiton];
    }
}
@end
