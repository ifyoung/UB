//
//  BindComfirmPlateNumVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "BindComfirmPlateNumVC.h"
#import "MillegeRewardSelectVC.h"
#import "PeccancyProvinceView.h"
#import "BindTopPregress.h"

@interface BindComfirmPlateNumVC ()<PeccancyProvinceViewDelegate,UITextFieldDelegate>{

    ProvinceButton *leftB;
    ProvinceTextField *textfield;
    PeccancyProvinceView *provinceView;
    NSString *selectprovince;
}

@end

@implementation BindComfirmPlateNumVC
- (void)loadView{
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    scrollView.contentSize = CGSizeMake(KSCREEWIDTH,KSCREEHEGIHT - 64 + 1);
    scrollView.showsVerticalScrollIndicator = NO;
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定智能终端";

    [self createTopPregress];
    
    [self createPlateNumber];
    
    [self createBottomButton];
}


/*
 *   头部进度
 */
- (void)createTopPregress{
    BindTopPregress *pregress = [BindTopPregress bindTopPregress:1];
    [self.view addSubview:pregress];
}


/*
 *   填写车牌
 */
- (void)createPlateNumber{
    UIView *left = [UIView new];
    left.backgroundColor = [UIColor grayColor];
    left.frame = CGRectMake(20, 120, .5, 10);
    [self.view addSubview:left];
    UIView *bottom = [UIView new];
    bottom.backgroundColor = [UIColor grayColor];
    bottom.frame = CGRectMake(20, 129.5, KSCREEWIDTH - 40, .5);
    [self.view addSubview:bottom];
    UIView *right = [UIView new];
    right.backgroundColor = [UIColor grayColor];
    right.frame = CGRectMake(KSCREEWIDTH-20, 120, .5, 10);
    [self.view addSubview:right];

    
     leftB = [ProvinceButton buttonWithType:UIButtonTypeCustom];
    [leftB setTitle:@"粤" forState:UIControlStateNormal];
    [leftB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftB setImage:[UIImage imageNamed:@"下"] forState:UIControlStateNormal];
    [leftB addTarget:self action:@selector(selectedProVince) forControlEvents:UIControlEventTouchUpInside];
    
    textfield = [[ProvinceTextField alloc]initWithFrame:CGRectMake(60, 100, KSCREEWIDTH - 120, 30 - 1)];
    textfield.keyboardType =   UIKeyboardTypeASCIICapable;
    textfield.delegate = self;
    textfield.leftView = leftB;
    textfield.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
    textfield.placeholder = @"在此输入车牌号码";
    [self.view addSubview:textfield];
    
    UILabel *bottomL = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, KSCREEWIDTH - 40, 30)];
    bottomL.textColor = [UIColor grayColor];
    bottomL.text = @"例如：粤B12345";
    [self.view addSubview:bottomL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textfield resignFirstResponder];
    return YES;
}


/*
 *  选择省份
 */
- (void)selectedProVince{

    //弹出省简称
    provinceView = [[PeccancyProvinceView alloc]init];
    provinceView.delegate = self;
    [provinceView show];
}

#pragma mark  PeccancyProvinceViewDelegate
- (void)didSelectProvince:(NSString *)province{
    
    [leftB setTitle:province forState:UIControlStateNormal];
    selectprovince = province;
}



/*
 *  下一步按钮
 */
- (void)createBottomButton{
    
    UIButton *bobutton = [self customButton:@"下一步"];
    bobutton.frame = CGRectMake(20, KSCREEHEGIHT - 64 - 80, KSCREEWIDTH - 40, 40);
    [self.view addSubview:bobutton];
}
- (void)customButtonAction:(UIButton *)button{
    if(textfield.text.length == 0){
        
        [MBProgressHUD showIndicator:@"请输入车牌"];
        return;
    }
    if(selectprovince == nil){
      selectprovince = @"粤";
    }
    NSString *text = [NSString stringWithFormat:@"%@%@",selectprovince,textfield.text];
    [self pushToViewContrqrcode:self.qrcode plateNo:text];
}

- (void)pushToViewContrqrcode:(NSString *)qrcode plateNo:(NSString *)plateNo{
    MillegeRewardSelectVC *myObj = [[MillegeRewardSelectVC alloc] init];
    myObj.qrcode = qrcode;
    myObj.plateNo = plateNo;
    myObj.isAddMoreCar = self.isAddMoreCar;
    [self.navigationController pushViewController:myObj animated:YES];
}
@end


@implementation ProvinceButton
//内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageH - 10, (imageH - 3) / 2.0, 10, 6);
}
//内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(0, 0, titleH - 10, titleH);
}
@end
@implementation ProvinceTextField
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.leftViewMode = UITextFieldViewModeAlways;
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return self;
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, 40, 30);
}
-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(50, 0, bounds.size.width - 50, bounds.size.height);
}
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(50, 0, bounds.size.width - 50, bounds.size.height);
}
-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(50, 0, bounds.size.width - 50, bounds.size.height);
}
@end


