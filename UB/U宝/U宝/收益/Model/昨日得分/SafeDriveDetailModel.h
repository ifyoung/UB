//
//  SafeDriveDetailModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/29.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 data =     {
         bestScore = "<null>";
         score = 62;
         dayDate = "2015-10-12";
 
         fatigueTime = 0;
         mileage = 49303;
         nightTime = 0;
 
         speedDown = 1;
         speedDownSVG = 0;
 
         speedLowTime = 33;
 
         speedSVG = 20;
         speedUp = 13;
         speedUpSVG = 0;
 };
 errorCode = 0;1
 errorMsg = "<null>";
 */


@interface SafeDriveDetailModel : NSObject

@property (nonatomic,strong)NSNumber   *score;
@property (nonatomic,strong)NSNumber   *bestScore;

@property (nonatomic,strong)NSNumber   *speedUp;     //急加速次数
@property (nonatomic,strong)NSNumber   *speedUpSVG;  //急加速次数/百公里
@property (nonatomic,strong)NSNumber   *speedDown;
@property (nonatomic,strong)NSNumber   *speedDownSVG;

@property (nonatomic,strong)NSNumber   *fatigueTime;  //疲劳驾驶时长
@property (nonatomic,strong)NSNumber   *speedLowTime; //怠速时长

@property (nonatomic,strong)NSNumber   *speedSVG;   //平均速度u
@property (nonatomic,strong)NSNumber   *nightTime;

@end
