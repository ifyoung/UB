//
//  PeccancyResultCell.m
//  赛格车圣
//
//  Created by 朱鹏 on 15/6/11.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "PeccancyResultCell.h"
#import "PeccancySeekResultVC.h"

@implementation PeccancyResultCell

/*
 *  overrideFrame
 */
- (void)setFrame:(CGRect)frame{
    NSInteger inset = 10;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}


/*
 *  setModel
 */
- (void)setModel:(PeccancyRecordModel *)model{
    
    _model = model;
    
    if([model.status  isEqual: @0]){
        _isHandle.text = @"未处理";
    }else if([model.status  isEqual: @1]){
        _isHandle.text = @"已处理";
    }
    
    _isHandle.textColor = [model.status isEqual:@0]? IWColor(237, 75, 77) : IWColor(43, 172, 109);
    
    _isStamp.image = [UIImage imageNamed:[model.status isEqual:@0]?@"印章logo":@"印章logo黑白"];
    
    _koufen.text   = [NSString stringWithFormat:@"%@ 分",model.point];
    
    _faqian.text   = [NSString stringWithFormat:@"%@ 元",model.fine];
    
    _time.text     = [NSString stringWithFormat:@"%@",model.time];
    
    _location.text = [NSString stringWithFormat:@"%@",model.address];
    
    _reason.text   = [NSString stringWithFormat:@"%@",model.reason];
    
    [self subViewSettins];
}


/*
 *  subViewSettins
 */
- (void)subViewSettins{
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;

    
    [_koufen setTextColor:IWColor(237, 75, 77)];
    [_koufen setTextColor:[UIColor grayColor] range:NSMakeRange(_koufen.text.length - 1, 1)];
    [_koufen setFont:[UIFont systemFontOfSize:20]];
    [_koufen setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(_koufen.text.length - 1, 1)];
    [_faqian setTextColor:IWColor(237, 75, 77)];
    [_faqian setTextColor:[UIColor grayColor] range:NSMakeRange(_faqian.text.length - 1, 1)];
    [_faqian setFont:[UIFont systemFontOfSize:20]];
    [_faqian setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(_faqian.text.length - 1, 1)];
    
    
    _kou.backgroundColor = IWColor(244, 0, 0);
    _kou.frame = CGRectMake(15, 10, 25, 25);
    _koufen.frame = CGRectMake(_kou.right + 5, _kou.top, _kou.width, _kou.height);
    [_koufen sizeToFit];
    [_kou addCornerousCircle];
    
    
    _fa.backgroundColor = IWColor(244, 0, 0);
    _fa.frame = CGRectMake(0, _koufen.top, _kou.width, _kou.height);
    _faqian.frame = CGRectMake(_fa.right + 5, _fa.top, _fa.width, _fa.height);
    [_faqian sizeToFit];
    [_fa addCornerousCircle];
    
    
    _faqian.center = CGPointMake((KSCREEWIDTH - 20) / 2.0, _faqian.center.y);
    _fa.right = _faqian.left - 5;
    

    //处理与否
    _isHandle.textAlignment = NSTextAlignmentRight;
    _isHandle.frame = CGRectMake(0, _faqian.top, _faqian.width, _faqian.height);
    [_isHandle sizeToFit];
    _isHandle.right = KSCREEWIDTH - 20 - 10;
    
    
    //违章时间
    _time.frame = CGRectMake(_koufen.left, _koufen.bottom + 10, KSCREEWIDTH - 20 - _koufen.left - 10, 20);
    

    //违章地点
    _location.frame = CGRectMake(_time.left, _time.bottom + 10, _time.width, _locaitonHeight);
    _location.font = [UIFont systemFontOfSize:14];
    
    
    //违章原因
    _reason.frame = CGRectMake(_location.left, _location.bottom + 10, _location.width, _resonHeight);
    _resonImg.top = _reason.top;
    _reason.font = [UIFont systemFontOfSize:14];

    
    //违章章
    _isStamp.frame = CGRectMake(_reason.right - 70, 0 , 70, 70);
    _isStamp.bottom = _reason.bottom;
    [self.contentView bringSubviewToFront:_isStamp];
}


/*
 *  drawRect
 */
- (void)drawRect:(CGRect)rect{
   
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    
    CGContextSaveGState(context);
    const CGFloat length[] = {3, 3};
    CGContextSetLineWidth(context, .5);
    CGContextSetLineDash(context, 0, length, 2);
    CGContextMoveToPoint(context, _kou.left,_kou.bottom + 5);
    CGContextAddLineToPoint(context,_isHandle.right ,_kou.bottom + 5);
    CGContextStrokePath(context);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    
    const CGFloat length1[] = {1, 3};
    CGContextSetLineDash(context, 0, length1, 2);
    CGContextMoveToPoint(context,     10, _reason.bottom + 10);
    CGContextAddLineToPoint(context,  _reason.right ,_reason.bottom + 10);
    CGContextStrokePath(context);
    CGContextClosePath(context);

}
@end
