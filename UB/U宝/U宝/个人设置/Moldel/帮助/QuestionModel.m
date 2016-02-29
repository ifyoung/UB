//
//  QuestionModel.m
//  车圣U宝
//
//  Created by 冥皇剑 on 15/11/3.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        // 1.将字典转换成模型
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

+ (instancetype)questionGroupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}

@end
