//
//  HelpView.m
//  车圣U宝
//
//  Created by 冥皇剑 on 15/11/3.
//  Copyright © 2015年 朱鹏的Ma. All rights reserved.
//

#import "HeaderView.h"
#import "QuestionModel.h"

@interface HeaderView ()

@property(nonatomic,strong)UIButton *btn;
/**
 *  headerView分割线
 */
@property(nonatomic,strong)UIView *line;

@end

@implementation HeaderView

+(instancetype)headerViewWithTableView:(UITableView *)tableView{

        //ios8重用时用dequeueReusableHeaderFooterViewWithIdentifier:方法会导致按钮图片混乱,高亮状态混乱,dequeueReusableCellWithIdentifier则不会
        static NSString *ID = @"headerView";
        HeaderView *HV = (HeaderView *)[tableView dequeueReusableCellWithIdentifier:ID];
        if (HV == nil) {
            HV = [[HeaderView alloc]initWithReuseIdentifier:ID];
        }
        return HV;

}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _btn = [[UIButton alloc]init];
        _btn.backgroundColor = IWColor(238, 238, 238);
        [_btn setTitleColor:IWColor(150, 150, 150) forState:UIControlStateNormal];
//        _btn.imageView.backgroundColor = [UIColor cyanColor];
        
        _btn.imageView.contentMode = UIViewContentModeCenter;
        //设置超出部分不剪掉
        _btn.imageView.clipsToBounds = NO;
        [_btn setImage:[UIImage imageNamed:@"未触发"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"触发时"] forState:UIControlStateSelected];
        _btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 设置按钮的内容左对齐
        _btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _btn.showsTouchWhenHighlighted = YES;
        _btn.imageEdgeInsets = UIEdgeInsetsMake(0, KSCREEWIDTH - 30, 0, 0);
 
        [self addSubview:_btn];
        
        //分割线
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor whiteColor];
        self.line = line;
        [self addSubview:line];
    }
    return self;
}

//点击事件
-(void)btnOnClick:(UIButton *)btn{
    
    self.questionGroup.open = !self.questionGroup.open;

    if ([self.delegate respondsToSelector:@selector(headerViewDidClickHeaderView:)]) {
        [self.delegate headerViewDidClickHeaderView:self];
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.btn.frame = self.bounds;
    
    CGFloat w = self.width;
    CGFloat h = 1;
    CGFloat x = 15;
    CGFloat y = self.height - h;
    self.line.frame = CGRectMake(x, y, w, h);
}

-(void)setQuestionGroup:(QuestionModel *)questionGroup{
    
    _questionGroup = questionGroup;
    [self.btn setTitle:_questionGroup.question forState:UIControlStateNormal];
}

#pragma mark - 当一个控件被添加到其它视图上的时候会调用以下方法
// 已经被添加到父视图上的时候会调用
-(void)didMoveToSuperview{
    
        if (self.questionGroup.open) {
            self.btn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
            [self.btn setTitleColor:kColor forState:UIControlStateNormal];
            [self.btn setImage:[UIImage imageNamed:@"触发时"] forState:UIControlStateNormal];
        }
}
// 将要添加到父视图上的时候会调用
-(void)willMoveToSuperview:(UIView *)newSuperview{

}


@end
