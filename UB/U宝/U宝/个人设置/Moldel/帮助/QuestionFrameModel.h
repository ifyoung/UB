//
//  QuestionFrameModel.h
//  车圣U宝
//
//  Created by 冥皇剑 on 15/11/3.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuestionModel;
@interface QuestionFrameModel : NSObject

@property (nonatomic, assign, readonly) CGRect answersF;

/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) QuestionModel *questionModel;

@end
