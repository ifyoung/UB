//
//  UBIRegisterView.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/20.
//  Copyright (c) 2015年 朱鹏的Mac. All rights reserved.
//

#import "UBIRegisterView.h"

@interface UBIRegisterView ()<UITextFieldDelegate>{
 
    
}

@end
@implementation UBIRegisterView

- (id)initWithFrame:(CGRect)frame{
    
    CGRect rect = CGRectMake(0, 10, KSCREEWIDTH, 200);
    self = [super initWithFrame:rect];
    if(self){
        
        [self createSubView];
    }
    return  self;
}


+ (UBIRegisterView *)shareUBIRegisterView{
    
    UBIRegisterView *registerView = [[self alloc]init];
    registerView.backgroundColor = [UIColor whiteColor];
    return registerView;
}


- (void)createSubView{
    
    NSArray *imgs =  @[@"手机号",@"短信",@"密码",@"密码"];
    NSArray *titles = @[@"请输入您的手机号码",@"您收到的短信验证码",@"请输入密码",@"请确认密码"];
    for(NSInteger i=0;i < 4;i++){
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10 + 50 * i , 30, 30)];
        image.image = [UIImage imageNamed:imgs[i]];
        [self addSubview:image];
        
        UITextField *textField =  [[UITextField alloc]initWithFrame:CGRectMake(image.right + 10, 50 * i, self.width - image.right - 10,50)];
        textField.tag = 1000 + i;
        textField.font = [UIFont systemFontOfSize:12.0f];
        textField.delegate = self;
        
        textField.placeholder = titles[i];
        [self addSubview:textField];
        if(i > 1){
            textField.secureTextEntry = YES;
            textField.returnKeyType = UIReturnKeyDone;
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }else{
         
            textField.secureTextEntry = NO;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int kMaxLength = 11;
    
    if(textField.tag == 1001) kMaxLength =  4;
    
    if(textField.tag > 1001) kMaxLength =  16;
 
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    
    return (strLength <= kMaxLength);
}
- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    textField.enablesReturnKeyAutomatically = YES;
    
    // your code here
    
    return YES;
    
}



- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, .2);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    for(NSInteger i =0;i < 4;i++){
    
        CGContextMoveToPoint(context, 20, 50 * (i + 1));
        CGContextAddLineToPoint(context, self.width - 10,50 * (i + 1));
        CGContextStrokePath(context);
    }
    
    CGContextClosePath(context);
}
@end
