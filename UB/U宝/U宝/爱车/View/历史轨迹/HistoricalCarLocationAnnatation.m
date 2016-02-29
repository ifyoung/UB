//
//  HistoricalCarLocationAnnatation.m
//  车圣U宝
//
//  Created by 朱鹏的Mac on 15/10/23.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "HistoricalCarLocationAnnatation.h"
#import "CarAnnotationModel.h"


@implementation HistoricalCarLocationAnnatation

- (void)setCarmodel:(CarAnnotationModel *)carmodel
{
    _carmodel = carmodel;
    
    self.coordinate = carmodel.coordinate;
}


@end
