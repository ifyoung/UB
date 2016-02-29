//
//  QuestionFrameModel.m
//  车圣U宝
//
//  Created by 冥皇剑 on 15/11/3.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "QuestionFrameModel.h"
#import "QuestionModel.h"


@implementation QuestionFrameModel

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(void)setQuestionModel:(QuestionModel *)questionModel{
    _questionModel = questionModel;
    
    CGFloat answerX = 10;
    CGFloat answerY = 5;
    CGSize answerSize = [self sizeWithText:self.questionModel.answers font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(KSCREEWIDTH - 2 * answerX, MAXFLOAT)];
    _answersF = CGRectMake(answerX, answerY, answerSize.width, answerSize.height);
    
    _cellHeight = CGRectGetMaxY(_answersF) + answerY;
}

@end
