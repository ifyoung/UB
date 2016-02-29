//
//  FeedbacksVC.m
//  UBI
//
//  Created by 冥皇剑 on 15/9/16.
//  Copyright (c) 2015年 minghuangjian. All rights reserved.
//

#import "FeedbacksVC.h"
#import "HWTextView.h"

@interface FeedbacksVC ()<UITextViewDelegate>

@property(nonatomic,strong)HWTextView *tView;
@property(nonatomic,strong)UILabel *headLabel;
@property(nonatomic,strong)UILabel *footLabel;
@property(nonatomic,strong)UIButton *Btn;
@property(nonatomic,strong)UILabel *tLabel;
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong)UIScrollView *scroll;
/**
 *  是否打开键盘
 */
@property(nonatomic,assign,getter=isOpen)BOOL open;
/**
 *  是否切换键盘
 */
@property (nonatomic, assign) BOOL switchingKeybaord;

@end

@implementation FeedbacksVC

-(UIScrollView *)scroll{
    if (_scroll == nil) {
        _scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scroll.scrollEnabled = YES;
        _scroll.delegate = self;
        //垂直滚动条不可见
        _scroll.showsVerticalScrollIndicator = NO;
        //水平滚动条不可见
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.contentSize = CGSizeMake(0, self.view.height + self.headLabel.height);
        [self.view addSubview:_scroll];
    }
    
    return _scroll;
}


-(UILabel *)tLabel{
    if (_tLabel == nil) {
        _tLabel = [[UILabel alloc]init];
        CGFloat w = 150;
        CGFloat h = 20;
        CGFloat x = self.tView.right - w - 10;
        CGFloat y = self.tView.bottom - h - 10;
        _tLabel.frame = CGRectMake(x, y, w, h);
        _tLabel.text = @"你还可以输入500字";
        _tLabel.textColor = [UIColor lightGrayColor];
        [self.scroll addSubview:_tLabel];
    }
    return _tLabel;
}


//-(UIButton *)addBtn{
//    if (_addBtn == nil) {
//        _addBtn = [[UIButton alloc]init];
//        CGFloat w = 45;
//        CGFloat h = 45;
//        CGFloat x = 20;
//        CGFloat y = self.tView.bottom - h - 10;
//        _addBtn.frame = CGRectMake(x, y, w, h);
//        [_addBtn setImage:[UIImage imageNamed:@"添加相片"] forState:UIControlStateNormal];
//        [_addBtn addTarget:self action:@selector(addphotos) forControlEvents:UIControlEventTouchUpInside];
//        [self.scroll addSubview:_addBtn];
//    }
//    return _addBtn;
//}


-(UILabel *)footLabel{
    if (_footLabel == nil) {
        _footLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.Btn.frame) + 10, KSCREEWIDTH- 40, 50)];
        _footLabel.text = @"我们将从反馈意见的客户中，不定期抽取提出优秀意见的客户给予奖励。";
        
        //自动换行
        _footLabel.numberOfLines = 0;
        [_footLabel setTextColor:[UIColor lightGrayColor]];
        [_footLabel setFont:[UIFont systemFontOfSize:17.0]];
        [self.scroll addSubview:_footLabel];
    }
    return _footLabel;
}

-(UIButton *)Btn{
    if (_Btn == nil) {
        _Btn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tView.frame) + 10, KSCREEWIDTH - 40, 44)];
        _Btn.backgroundColor = kColor;
        _Btn.showsTouchWhenHighlighted = YES;
        [_Btn setTitle:@"提交" forState:UIControlStateNormal];
        _Btn.layer.cornerRadius = 10;
        [_Btn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll addSubview:_Btn];
    }
    return _Btn;
}

-(UILabel *)headLabel{
    if (_headLabel == nil) {
        _headLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KSCREEWIDTH, 44)];
        _headLabel.text = @"您的意见和想法对我们非常重要！";
        [_headLabel setTextColor:IWColor(150, 150, 150)];
        [_headLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.scroll addSubview:_headLabel];
    }
    return _headLabel;
}

-(UITextView *)tView{
    if (_tView == nil) {
        _tView = [[HWTextView alloc]initWithFrame:CGRectMake(0, self.headLabel.height, KSCREEWIDTH, self.view.height/2.0 - 100)];
        
        //使用系统此方法创建frame时，自定义的placeholder就不会消失
//        _tView = [HWTextView alloc]initWithFrame:<#(CGRect)#> textContainer:<#(nullable NSTextContainer *)#>
        _tView.backgroundColor = [UIColor whiteColor];
        _tView.font = [UIFont systemFontOfSize:15];
        _tView.placeholder = @"    您的建议是我们进步的动力...";
        _tView.delegate = self;
        _tView.keyboardType = UIKeyboardTypeNamePhonePad;
        //光标偏移
        _tView.textContainerInset = UIEdgeInsetsMake(8, 15, 0, 0);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:_tView];
        [self.scroll addSubview:_tView];
    }
    return _tView;
}

-(void)textChange{
    long length = 500 - _tView.text.length;
    NSString *str = [NSString stringWithFormat:@"你还可以输入%ld字",length];
    _tLabel.text = str;
    [_tLabel sizeToFit];
}

-(void)addphotos{
    //此方法本身会隐藏蒙版
    [MBProgressHUD showIndicator:@"添加照片功能暂未开放，敬请期待"];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈建议";
    
    [self leftButtonItem];
    [self footLabel];
    [self addBtn];
    [self tLabel];
    [self swipeGestureRecognizer];
    self.view.backgroundColor = IWColor(238, 238, 238);
    //监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - keyboardChange
//键盘处理
-(void)keyboardDidChangeFrame:(NSNotification *)noti{
    
    //键盘退出frame
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //键盘实时y
    CGFloat keyY = frame.origin.y;
    
    //切换键盘是不要再改变view的transform
    if (self.switchingKeybaord == YES && keyY < KSCREEHEGIHT) {
        return;
    }
    
    CGFloat H = self.headLabel.height;
    
    //动画时间
    CGFloat keyDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    //执行动画
        [UIView animateWithDuration:keyDuration animations:^{
        
            if (self.open == NO) {
                
                self.view.transform = CGAffineTransformMakeTranslation(0, -H);
                self.open = YES;
                self.switchingKeybaord = YES;
            }else if (self.open == YES){
                //恢复到变形前状态
                self.view.transform = CGAffineTransformIdentity;
                self.open = NO;
                self.switchingKeybaord = NO;
            }
        
        }];
}

-(void)sendMessage{
    [self.view endEditing:YES];
    
    if(![UIDevice checkNowNetworkStatus]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showIndicator:KNetworkError];
            });
        return;
    }
    
    __weak typeof(self) this = self;
    //蒙版不能放到请求里，否则会报错
    [MBProgressHUD showMessage:@"我们已经接收到您的建议"];
    
    [Interface suggestWithContent:self.tView.text block:^(id result) {
        NSLog(@"contents == %@",result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            this.tView.text = nil;
            _tLabel.text = @"你还可以输入500字";
            [MBProgressHUD hideHUD];
        });
        
    }];
       
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    int kMaxLength = 500;
 
    NSInteger strLength = textView.text.length - range.length + text.length;
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    return (strLength <= kMaxLength);
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //退出键盘
    [self.view endEditing:YES];
    self.switchingKeybaord = NO;
}

@end
