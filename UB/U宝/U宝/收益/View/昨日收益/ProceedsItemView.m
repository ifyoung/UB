//
//  ProceedsItemView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/26.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "ProceedsItemView.h"
#import "ProceedsYesturdayVC.h"
#import "SafeDrivingDetailVC.h"
#import "CarMileageViewController.h"

@interface ProceedsItemView (){
 
    UIImageView *middleImg;
    UILabel *leftLabel;
    UILabel *rightLabel;
}

@end
@implementation ProceedsItemView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
            middleImg = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:middleImg];
            
            leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            leftLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:leftLabel];
            
            rightLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            rightLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:rightLabel];

    }
    return self;
}

- (void)setRightTitle:(NSString *)rightTitle{
   
    _rightTitle = rightTitle;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
   
    middleImg.frame = CGRectMake(0, self.height - 50, 50, 50);
    middleImg.center = CGPointMake(self.center.x, middleImg.center.y);
    middleImg.image = [UIImage imageNamed:self.middleImgName];
    
    
    leftLabel.frame = CGRectMake(0, 0, middleImg.left - 10, 20);
    leftLabel.center = CGPointMake(leftLabel.center.x, middleImg.center.y);
    leftLabel.text = @"里程奖励";
    leftLabel.text = self.leftTitle;
    
    rightLabel.frame = CGRectMake(middleImg.right + 10, 0,self.width -  middleImg.right - 10, 20);
    rightLabel.center = CGPointMake(rightLabel.center.x, middleImg.center.y);
    rightLabel.text = @"里程奖励";
    rightLabel.textColor = IWColor(89,90,91);
    rightLabel.text = self.rightTitle;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    [self drawDashLine];
}


/*
 *   drawDashLine
 */
- (void)drawDashLine{
  
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    const CGFloat length[] = {2, 2};
    CGContextSetLineDash(context, 0, length, 1);
    
    CGPoint point1 = CGPointMake(self.width / 2.0, 0);
    CGPoint point2 = CGPointMake(self.width / 2.0, self.height - 50);
    CGContextMoveToPoint(context, point1.x, point1.y);
    CGContextAddLineToPoint(context, point2.x,point2.y);
    
    CGContextStrokePath(context);
    CGContextClosePath(context);
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

    __weak   ProceedsYesturdayVC *yes = (ProceedsYesturdayVC *)self.viewController;
    if([self.leftTitle isEqualToString:@"安全驾驶奖励"]){
    
        SafeDrivingDetailVC *safeDriving = [[SafeDrivingDetailVC alloc]init];
        safeDriving.title = @"安全驾驶明细";
        
        if(self.proceedsModel.income == 1){
            safeDriving.safeDrivingType =   SafeDrivingDetailTypeGreen;
        }else if(self.proceedsModel.score == 0){
            safeDriving.safeDrivingType =   SafeDrivingDetailTypeNoTenKM;
        }else{
            safeDriving.safeDrivingType =   SafeDrivingDetailTypeNormoal;
        }
        [yes.navigationController pushViewController:safeDriving animated:YES];
        
    }else if ([self.leftTitle isEqualToString:@"里程奖励"]){
        
        CarMileageViewController *mile = [[CarMileageViewController alloc]init];
        mile.isYesturday = YES;
        mile.proceedsModel = self.proceedsModel;
        [yes.navigationController pushViewController:mile animated:YES];
        
    }else if([self.leftTitle isEqualToString:@"绿色奖励"]){
    
        SafeDrivingDetailVC *safeDriving = [[SafeDrivingDetailVC alloc]init];
        safeDriving.title = @"绿色收益";
        if(self.proceedsModel.income == 1){
            safeDriving.safeDrivingType =   SafeDrivingDetailTypeGreen;
        }else {
            safeDriving.safeDrivingType =   SafeDrivingDetailTypeGreenNo;
        }
        [yes.navigationController pushViewController:safeDriving animated:YES];
    }
}
@end
