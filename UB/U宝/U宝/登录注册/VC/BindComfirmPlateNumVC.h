//
//  BindComfirmPlateNumVC.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "ZPBaseController.h"

@interface BindComfirmPlateNumVC : ZPBaseController

@property(nonatomic,copy)NSString *qrcode;
@property (nonatomic,assign)BOOL isAddMoreCar;
@end

@interface ProvinceButton : UIButton

@end

@interface ProvinceTextField : UITextField

@end