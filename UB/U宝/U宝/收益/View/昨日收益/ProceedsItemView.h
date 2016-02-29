//
//  ProceedsItemView.h
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/26.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProceedsModel.h"

@interface ProceedsItemView : UIView

@property (copy, nonatomic)  NSString *leftTitle;

@property (copy, nonatomic)  NSString *middleImgName;

@property (copy, nonatomic)  NSString *rightTitle;

@property (nonatomic,strong)ProceedsModel *proceedsModel;

@end
