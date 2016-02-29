//
//  ProceedsCirclePathView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/24.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "ProceedsCirclePathView.h"
#import "ProceedsYesturdayVC.h"
#import "SafeDrivingDetailVC.h"
#import "ProceedsVC.h"


@interface ProceedsCirclePathView (){

    UILabel *yesturdayLabel;
    UILabel *totalLabel;
    UILabel *yesturdayScoreLabel;
    UILabel *yesturdayMoney;
    UILabel *yesturdayScore;
    UILabel *totalMoney;
    
    UIControl   *control;
    UIImageView *contentImg;
    UIButton    *cancleButton;
    CGRect yesMonneframe;
    NSArray *titles;
    NSInteger indecatorIndex;
}

@end

@implementation ProceedsCirclePathView

- (id)initWithFrame:(CGRect)frame{
  
    self = [super initWithFrame:frame];
    if(self){
    
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{

    float font;
    float fontB;
    if(KSCREEHEGIHT <= 1136 / 2.0){
        font = 9.0;
    }else{
        font = 13.0;
    }
    fontB = font + 3.0;
    
    yesturdayLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    yesturdayLabel.textColor = IWColor(31, 208, 53);
    yesturdayLabel.font = [UIFont systemFontOfSize:font];
    yesturdayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:yesturdayLabel];
    
    yesturdayMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    yesturdayMoney.textColor = IWColor(31, 208, 53);
    yesturdayMoney.font = [UIFont systemFontOfSize:fontB];
    yesturdayMoney.textAlignment = NSTextAlignmentCenter;
    [self addSubview:yesturdayMoney];
    
    yesturdayScore = [[UILabel alloc]initWithFrame:CGRectZero];
    yesturdayScore.textColor = [UIColor orangeColor];
    yesturdayScore.font = [UIFont systemFontOfSize:fontB];
    yesturdayScore.textAlignment = NSTextAlignmentCenter;
    [self addSubview:yesturdayScore];

    yesturdayScoreLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    yesturdayScoreLabel.textColor = [UIColor orangeColor];
    yesturdayScoreLabel.font = [UIFont systemFontOfSize:font];
    yesturdayScoreLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:yesturdayScoreLabel];
    
    totalMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    totalMoney.textColor = kColor;
    totalMoney.font = [UIFont systemFontOfSize:fontB];
    totalMoney.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalMoney];
    
    totalLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    totalLabel.textColor = kColor;
    totalLabel.font = [UIFont systemFontOfSize:font];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalLabel];
}


- (void)setModel:(ProceedsModel *)model{
    _model = model;

    [self setNeedsLayout];

    [self.layer setNeedsDisplay];
    
    [self.layer displayIfNeeded];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGPoint centerPoint = CGPointMake(self.width / 2.0f, self.height / 2.0f);
    CGFloat radius = (MIN(self.height, self.width) / 2.0f - 40) * 0.9;
    float dash2oriX = radius - radius * cos(M_PI_2 / 3.0) ;
    
    float yesturdayLabelTop       = centerPoint.y - radius + dash2oriX;
    
    yesturdayLabel.frame = CGRectMake(0, yesturdayLabelTop+ 10, 20, 20);
    yesturdayLabel.text  = @"昨日收益(元)";
    [yesturdayLabel sizeToFit];
    yesturdayLabel.center = CGPointMake(self.width / 2.0, yesturdayLabel.center.y);
    
    yesturdayMoney.frame = CGRectMake(0, yesturdayLabel.bottom, 20, 30);
    yesturdayMoney.text = [NSString stringWithFormat:@"%g",self.model.income];
    [yesturdayMoney sizeToFit];
    yesturdayMoney.center = CGPointMake(yesturdayLabel.center.x, yesturdayMoney.center.y);
    
    yesturdayScore.frame = CGRectMake(0, self.height / 2.0, 20, 30);
    yesturdayScore.text  = [NSString stringWithFormat:@"%g",self.model.score];
    [yesturdayScore sizeToFit];
    
    yesturdayScoreLabel.frame = CGRectMake(0, yesturdayScore.bottom, 20, 20);
    yesturdayScoreLabel.text = @"昨日得分(分)";
    [yesturdayScoreLabel sizeToFit];
    yesturdayScoreLabel.left = centerPoint.x - radius * cos(M_PI_2 / 3.0) + 5;
    yesturdayScore.center = CGPointMake(yesturdayScoreLabel.center.x, yesturdayScore.center.y);
   
    totalMoney.frame = CGRectMake(0, self.height / 2.0, 20, 30);
    totalMoney.text = [NSString stringWithFormat:@"%g",self.model.totalIncome];
    [totalMoney sizeToFit];
    
    totalLabel.frame = CGRectMake(0, totalMoney.bottom, 20, 20);
    totalLabel.text = @"累计收益(元)";
    [totalLabel sizeToFit];
    totalLabel.right = centerPoint.x + radius * cos(M_PI_2 / 3.0) - 5;
    totalMoney.center = CGPointMake(totalLabel.center.x, totalMoney.center.y);
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:KFirtsLaunchMain]){
    
        [self createInterfaceView];
        
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:KFirtsLaunchMain];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint benginPoint = [touch locationInView:self];
    
    CGFloat width =  MIN(self.bounds.size.width, self.bounds.size.height );
    CGRect tophalfrect = CGRectMake(40, 40,width - 80 ,width / 2.0 - 40 );
    CGRect lefthalfrect = CGRectMake(40,width /  2.0 , width / 2.0, width/ 2.0);
    CGRect righthalfrect = CGRectMake(width/2.0, width/2.0, width/2.0, width/2.0);
    
    ProceedsVC  *provc =  (ProceedsVC *)self.viewController;
    if(CGRectContainsPoint(tophalfrect, benginPoint)){
        
        ProceedsYesturdayVC *yesturday = [[ProceedsYesturdayVC alloc]init];
        yesturday.proceedsModel =  self.model;
        [provc.navigationController pushViewController:yesturday animated:YES];
        
    }else if(CGRectContainsPoint(lefthalfrect, benginPoint)){
        
        SafeDrivingDetailVC *safeDriving = [[SafeDrivingDetailVC alloc]init];
        safeDriving.title = @"安全驾驶明细";
        if(self.model.income == 1){
            safeDriving.safeDrivingType =   SafeDrivingDetailTypeGreen;
        }else if(self.model.score == 0){
            safeDriving.safeDrivingType =   SafeDrivingDetailTypeNoTenKM;
        }else{
            safeDriving.safeDrivingType =   SafeDrivingDetailTypeNormoal;
        }
        [self.viewController.navigationController pushViewController:safeDriving animated:YES];
    }else if (CGRectContainsPoint(righthalfrect, benginPoint)){
        [provc pushToViewController:@"ProceedsTotalVC"];
    }
}

- (void)createInterfaceView{
    
    if(control == nil)
    control = [[UIControl alloc]initWithFrame:CGRectZero];
    control.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [control addTarget:self
             action:@selector(dismiss)
   forControlEvents:UIControlEventTouchUpInside];
    
    if(contentImg == nil)
    contentImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    if(cancleButton == nil)
    cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectZero;
    
     titles = @[@"查看昨日收益",@"查看累计收益",@"查看昨日得分",@"查看个人中心"];
    indecatorIndex = 0;
    [self showIndicator:[titles objectAtIndex:indecatorIndex]];
}

- (void)showIndicator:(NSString *)title{
    
     UIImage *image = [UIImage imageNamed:title];
     float width = image.size.width;
     float height = image.size.height;
    
    if([title isEqualToString:@"查看昨日收益"]){
    
        yesMonneframe =  CGRectMake(yesturdayLabel.left - width / 2.0, 64 + TopPercent + yesturdayLabel.top -  20, width, height);
    }
    else if ([title isEqualToString:@"查看累计收益"]){
   
       yesMonneframe =  CGRectMake(totalLabel.right - width + 20, 64 + TopPercent + totalLabel.bottom - height + 20, width, height);
       
    }else if ([title isEqualToString:@"查看昨日得分"]){
    
       yesMonneframe =  CGRectMake(yesturdayScoreLabel.left - 20, 64 + TopPercent + yesturdayScoreLabel.bottom - height + 15 , width, height);
    }else if([title isEqualToString:@"查看个人中心"]){

       yesMonneframe =  CGRectMake(KSCREEWIDTH - width, 15,width , height);
    }
    
    
    UIWindow *keywindow = [[UIApplication sharedApplication] windows][0];
    contentImg.frame = yesMonneframe;
    contentImg.image = image;
    //contentImg.backgroundColor = [UIColor redColor];
    [control addSubview:contentImg];

    cancleButton.frame = CGRectMake(KSCREEWIDTH - 75 - 100, KSCREEHEGIHT - 75, 100, 40);
    [cancleButton setImage:[UIImage imageNamed:@"知道了"] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [control addSubview:cancleButton];
    
    control.frame = keywindow.bounds;
    [keywindow addSubview:control];
}

- (void)dismiss{

    [UIView animateWithDuration:.35 animations:^{
        
        if(indecatorIndex > 4)
          control.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        indecatorIndex ++;
        
        [control removeAllSubviews];
        
        if(indecatorIndex <= 3){
            
          [self showIndicator:[titles objectAtIndex:indecatorIndex]];
            
        }else{
        
            [control removeFromSuperview];
            control = nil;
        }
        
    }];
}
@end
