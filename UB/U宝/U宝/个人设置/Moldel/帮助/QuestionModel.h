//
//  QuestionModel.h
//  车圣U宝
//
//  Created by 冥皇剑 on 15/11/3.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property(nonatomic,copy)NSString *question;
@property(nonatomic,copy)NSString *answers;


// 记录当前组是否需要打开
@property(nonatomic,assign,getter=isOpen)BOOL open;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)questionGroupWithDict:(NSDictionary *)dict;

@end
