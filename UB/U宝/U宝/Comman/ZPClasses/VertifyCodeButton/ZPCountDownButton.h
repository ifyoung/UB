//
//  ZPCountDownButton.h
//  ZPCountDownButton
//
//  Created by ZP on 15/9/25.
//  Copyright (c) 2015年 www.autoholy.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPCountDownButton;
typedef NSString* (^DidChangeBlock)(ZPCountDownButton *countDownButton,int second);
typedef NSString* (^DidFinishedBlock)(ZPCountDownButton *countDownButton,int second);

typedef void (^TouchedDownBlock)(ZPCountDownButton *countDownButton,NSInteger tag);

@interface ZPCountDownButton : UIButton
{
    int _second;
    int _totalSecond;
    
    NSTimer *_timer;
    NSDate *_startDate;
    
    DidChangeBlock _didChangeBlock;
    DidFinishedBlock _didFinishedBlock;
    TouchedDownBlock _touchedDownBlock;
}

@property(nonatomic,assign)BOOL isCodeSuccess;
//@property(nonatomic,strong)UIColor *changeFontColor;
//@property(nonatomic,strong)UIColor *normalFontColor;
-(void)startWithSecond:(int)second;
- (void)stop;


-(void)addToucheHandler:(TouchedDownBlock)touchHandler;
-(void)didChange:(DidChangeBlock)didChangeBlock;
-(void)didFinished:(DidFinishedBlock)didFinishedBlock;
@end
