//
//  ProceedsModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/29.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProceedsModel : NSObject

@property (nonatomic,assign)double score;        //昨日得分
@property (nonatomic,assign)double totalIncome;  //累计收益
@property (nonatomic,assign)double income;       //昨日收益


@property (nonatomic,assign)double mileageMoney; //里程奖励
@property (nonatomic,assign)double greenMoney;   //绿色奖励
@property (nonatomic,assign)double safeMoney;    //安全驾驶奖励


@property (nonatomic,assign)double mileage;      //里程
@property (nonatomic,assign)double safeScore;    //安全驾驶得分


@end
