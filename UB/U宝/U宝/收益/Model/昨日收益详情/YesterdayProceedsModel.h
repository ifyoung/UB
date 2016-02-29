//
//  YesterdayProceedsModel.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/9/29.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 data =     {
         distanceIncome = "<null>";
         greenIncome = "<null>";
         income = "<null>";
         safeIncome = "<null>";
 };
 errorCode = 0;
 errorMsg = "<null>";
 */
@interface YesterdayProceedsModel : NSObject

@property (nonatomic,assign)double distanceIncome;
@property (nonatomic,assign)double greenIncome;
@property (nonatomic,assign)double income;
@property (nonatomic,assign)double safeIncome;

@end
