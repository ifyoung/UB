//
//  UBILogView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/20.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBILogView.h"


@interface UBILogView ()<UITextFieldDelegate>

    
@end

@implementation UBILogView
- (id)initWithFrame:(CGRect)frame{
  
    CGRect rect = CGRectMake(0, 100, KSCREEWIDTH, 100);
    self = [super initWithFrame:rect];
    if(self){
    
        [self createSubView];
    }
    return  self;
}


+ (UBILogView *)shareUBILogView{

    UBILogView *ublogView = [[self alloc]init];
    ublogView.backgroundColor = [UIColor whiteColor];
    return ublogView;
}

- (void)setUser:(NSString *)user{
    _user = user;
    [self setNeedsLayout];
}
- (void)setCode:(NSString *)code{
    _code = code;
    [self setNeedsLayout];
}



- (void)createSubView{
    
    NSArray *imgs =  @[@"手机号",@"密码"];
    NSArray *titles = @[@"请输入您的手机号码",@"请输入您的密码"];
    for(int i=0;i < 2;i++){
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
        image.tag = 200 + i;
        image.image = [UIImage imageNamed:imgs[i]];
        [self addSubview:image];
        
        UITextField *textField =  [[UITextField alloc]initWithFrame:CGRectZero];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.tag = 300 + i;
        textField.delegate = self;
        textField.placeholder = titles[i];
        [self addSubview:textField];
        
         [textField addTarget:self action:@selector(textFieldWithTex:) forControlEvents:UIControlEventEditingChanged];
        
        if(i == 1){
        
            textField.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.placeholder = @"请输入6-16位密码";
        }else{
        
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"请输入11位手机号码";
        }
    }
}


- (void)textFieldWithTex:(UITextField *)textField{
    if(textField.tag == 300){
        _user = textField.text;
    }else{
        _code = textField.text;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int kMaxLength = 11;
    if(textField.tag != 300){
        kMaxLength = 16;
    }
    NSInteger strLength = textField.text.length - range.length + string.length;
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+ 替换的字符长度（一般为0）
    return (strLength <= kMaxLength);
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



- (void)layoutSubviews{
    [super layoutSubviews];
  
    for(int i=0;i < 2;i++){
        UIImageView *imageView = (UIImageView *)[self viewWithTag:200 + i];
        imageView.frame = CGRectMake(20, 10 + 50 * i , 30, 30);
        
        UITextField *textFeld  = (UITextField *)[self viewWithTag:300 + i];
        textFeld.frame = CGRectMake(imageView.right + 10, 50 * i, self.width - imageView.right - 10,50);
        textFeld.text = i == 0? _user:_code;
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .2);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGContextMoveToPoint(context, 20, 50);
    CGContextAddLineToPoint(context, self.width - 10,50);
    CGContextStrokePath(context);
   
    CGContextClosePath(context);
}
@end
