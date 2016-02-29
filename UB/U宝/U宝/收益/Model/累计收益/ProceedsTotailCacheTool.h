//
//  ProceedsTotailCacheTool.h
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/22.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProceedsTotalModel.h"

@interface ProceedsTotailCacheTool : NSObject



+ (void)addProceedsTotalModel:(ProceedsTotalModel *)proceedsTotalModel vehicleId:(long)vehicleId;


+ (void)deleteProceedsTotalModelWithvehicleId:(long)vehicleId;


+ (ProceedsTotalModel *)proceedsTotalModel:(long)vehicleId;

@end
