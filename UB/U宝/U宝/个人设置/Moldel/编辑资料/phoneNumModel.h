//
//  phoneNumModel.h
//  车圣U宝
//
//  Created by 冥皇剑 on 15/10/30.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface phoneNumModel : NSObject

/**手机号码*/
@property(nonatomic,copy)NSString *callLetter;
/**
 *  gander
 */
@property(nonatomic,copy)NSString *gander;
/**
 *  imgUrl
 */
@property(nonatomic,copy)NSString *imgUrl;
/**
 *  nickname
 */
@property(nonatomic,copy)NSString *nickname;
/**
 *  userId
 */
@property(nonatomic,copy)NSString *userId;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)phoneWithDict:(NSDictionary *)dict;

@end
