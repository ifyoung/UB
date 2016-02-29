//
//  phoneNumModel.m
//  车圣U宝
//
//  Created by 冥皇剑 on 15/10/30.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "phoneNumModel.h"

@implementation phoneNumModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)phoneWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
