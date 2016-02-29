//
//  ProhoriFirstWeather.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/10.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "ProhoriFirstWeather.h"

@interface ProhoriFirstWeather (){

    UILabel *weather;
    UILabel *cloudLabel;
    UILabel *washcar;
    UIImageView *locaiton;
    UILabel *locationLabel;
    UILabel *pm;
    UILabel *pm25;
    UILabel *hands;
}

@end
@implementation ProhoriFirstWeather

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addShapeLayer];
        
        [self createSubViews];
    }
    return self;
}


/*
 *   createSubViews
 */
- (void)createSubViews{

    weather = [[UILabel alloc]initWithFrame:CGRectZero];
    weather.textColor = [UIColor whiteColor];
    weather.font = [UIFont boldSystemFontOfSize:22.0f];
    [self addSubview:weather];

    
    cloudLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    cloudLabel.textColor = [UIColor whiteColor];
    cloudLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:cloudLabel];
    
    washcar = [[UILabel alloc]initWithFrame:CGRectZero];
    washcar.textColor   =  [UIColor whiteColor];
    washcar.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:washcar];
    
    
    locaiton = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:locaiton];
    
    locationLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    locationLabel.textColor = [UIColor whiteColor];;
    locationLabel.font = [UIFont systemFontOfSize:15.0f];
    locationLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:locationLabel];
    

    pm = [[UILabel alloc]initWithFrame:CGRectZero];
    pm.textColor = IWColor(31, 210, 50);
    pm.font = [UIFont systemFontOfSize:15.0f];
    pm.textAlignment = NSTextAlignmentCenter;
    [self addSubview:pm];
    
    pm25 = [[UILabel alloc]initWithFrame:CGRectZero];
    pm25.textColor = [UIColor whiteColor];
    pm25.font = [UIFont systemFontOfSize:14.0f];
    pm25.textAlignment = NSTextAlignmentCenter;
    [self addSubview:pm25];
    
    hands = [[UILabel alloc]initWithFrame:CGRectZero];
    hands.textColor = [UIColor whiteColor];
    hands.font = [UIFont systemFontOfSize:17.0f];
    hands.textAlignment = NSTextAlignmentRight;
    [self addSubview:hands];
}


- (void)setModel:(WeatherModel *)model{
    _model = model;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{

    weather.text =  [NSString stringWithFormat:@"%@",self.model.temperature]; //@"2° / 3°";
    weather.frame = CGRectMake(20, 30, 20, 30);
    [weather sizeToFit];
    
    washcar.text =  [NSString stringWithFormat:@"%@",self.model.weather];
    washcar.frame = CGRectMake(weather.left, weather.bottom + 10, 20, 20);
    [washcar sizeToFit];
    
    if(self.model.washIndex.length >= 2){
       
        NSRange rang = NSMakeRange(self.model.washIndex.length - 2, 2);
        NSString *substring3 = [self.model.washIndex substringWithRange:rang];
        if([substring3 isEqualToString:@"洗车"]){
            self.model.washIndex =  [self.model.washIndex substringWithRange: NSMakeRange(0,self.model.washIndex.length - 2)];
        }
    }
    cloudLabel.text = [NSString stringWithFormat:@"%@洗车",self.model.washIndex];
    cloudLabel.frame = CGRectMake(washcar.left, washcar.bottom + 10, 20, 20);
    [cloudLabel sizeToFit];
    
    
    locationLabel.frame = CGRectMake(0, 0, 20, 30);
    locationLabel.text = [SFHFKeychainUtils getPasswordForUsername:@"UserLocationCity" andServiceName:[[NSBundle mainBundle] bundleIdentifier] error:NULL];
    [locationLabel sizeToFit];
    locationLabel.left = KSCREEWIDTH - 25 - self.height / 3.0 / 2.0;
    locationLabel.center = CGPointMake(locationLabel.center.x, self.height / 6.0);
    
    
    locaiton.frame = CGRectMake(0, 0, 15, 19);
    locaiton.image = [UIImage imageNamed:@"爱车定位"];
    locaiton.right = locationLabel.left - 5;
    locaiton.bottom = locationLabel.bottom;
    
    //locaiton.backgroundColor = [UIColor redColor];
    //locationLabel.backgroundColor = [UIColor greenColor];
    
    NSString *pm2str = [NSString stringWithFormat:@"%@",self.model.pm25];
    pm.text = self.model.pm25 == nil? @"" : pm2str;
    pm.frame = CGRectMake(0, 0, 20, self.height / 3.0 / 2.0);
    pm.bottom = self.height / 2.0;
    pm.width = self.height / 3.0 * 3 / 4.0;
    pm.center = CGPointMake(KSCREEWIDTH - 25 - self.height / 3.0 / 2.0, pm.center.y);

    
    pm25.text = @"PM2.5";
    pm25.frame = CGRectMake(0, self.height / 2.0, 20, self.height / 3.0 / 2.0 - 5);
    pm25.width = self.height / 3.0 * 3 / 4.0;
    pm25.center = CGPointMake(KSCREEWIDTH - 25 - self.height / 3.0 / 2.0, pm25.center.y);
    pm25.adjustsFontSizeToFitWidth = YES;
    
    //pm.backgroundColor = [UIColor greenColor];
    //pm25.backgroundColor = [UIColor redColor];
    
    NSString *days = [ZPUiutsHelper getdaysFromNowMobile];
    hands.text =  [NSString stringWithFormat:@"您与小U牵手已经%@天",days];
    hands.frame = CGRectMake(0, self.height - 45, 20, 20);
    [hands setFont:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(8, hands.text.length - 9)];
    [hands setTextColor:kColor range:NSMakeRange(8, hands.text.length - 9)];
    [hands sizeToFit];
    hands.right = self.width - 20;
}

- (void)addShapeLayer{

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor colorWithWhite:.5 alpha:.3].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    [shapeLayer setShadowColor:kColor.CGColor];
    [shapeLayer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [shapeLayer setShadowOpacity:1.0f];
    [shapeLayer setShadowRadius:1];
    
    // Create the larger rectangle path.
    CGMutablePathRef path = CGPathCreateMutable();
    float rudius = self.height / 3.0;
    CGRect rect =  CGRectMake(0, 0, rudius, rudius);
    rect = CGRectMoveToCenter(rect, CGPointMake(KSCREEWIDTH - 25- rudius / 2.0, self.height / 2.0));
    
    CGPathAddEllipseInRect(path, NULL,rect);
    
    CGPathMoveToPoint(path, NULL,  KSCREEWIDTH - 25 - rudius,self.height / 2.0 );
    CGPathAddLineToPoint(path, NULL,KSCREEWIDTH - 25,self.height / 2.0 );
    shapeLayer.path = path;
    [self.layer addSublayer:shapeLayer];
}
@end
