 //
//  ScanfOBDbarCodeComfirmVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "ScanfOBDbarCodeComfirmVC.h"
#import "BindTopPregress.h"
#import "BindComfirmPlateNumVC.h"

#import "RSCodeGen.h"



@interface ScanfOBDbarCodeComfirmVC (){
    UIImageView *barCodeView;
}

@end

@implementation ScanfOBDbarCodeComfirmVC

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
    
    [self createEANbarcode];

    [self createBottomButton];
}


/*
 *   头部进度
 */
- (void)createTopPregress{
    BindTopPregress *pregress = [BindTopPregress bindTopPregress:0];
    [self.view addSubview:pregress];
}


/*
 *   条形码生成数字
 */
- (void)createEANbarcode{
    
    UIView *topline = [UIView new];
    topline.frame = CGRectMake(0, 80, KSCREEWIDTH, .5);
    topline.backgroundColor = IWColor(214, 214, 214);
    [self.view addSubview:topline];
    
    CGRect rect = CGRectMake(40, 80 + 35, KSCREEWIDTH - 80, 100.0);
    barCodeView = [[UIImageView alloc]initWithFrame:rect];
    UIImage *img;

    if(iOS8Earlier){
        img = [CodeGen genCodeWithContents:self.qrcode machineReadableCodeObjectType:AVMetadataObjectTypeCode128Code];
    }else{
        img = [self generateBarCode:self.qrcode width:barCodeView.width height:barCodeView.height];
    }
    
    barCodeView.image = img;
    [self.view addSubview:barCodeView];
    
    
    UILabel *labrel = [[UILabel alloc]initWithFrame:CGRectMake(barCodeView.left, barCodeView.bottom, barCodeView.width, 20)];
    CGFloat width =  [[self.qrcode substringToIndex:1]  boundingRectWithSize:CGSizeMake(barCodeView.width, labrel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:
                      @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],} context:nil].size.width;
    NSDictionary *attrs = @{
                            NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                            NSKernAttributeName : [NSNumber numberWithDouble:(barCodeView.width - width * self.qrcode.length) / (self.qrcode.length - 1)]
                            };
    NSAttributedString
    *as = [[NSAttributedString alloc] initWithString: self.qrcode
                                                 attributes:attrs];
    labrel.attributedText = as;
    labrel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:labrel];
    //labrel.backgroundColor = [UIColor redColor];
    
    
    UIView *bottomline = [UIView new];
    bottomline.frame = CGRectMake(0,barCodeView.bottom + 35 , KSCREEWIDTH, .5);
    bottomline.backgroundColor = IWColor(214, 214, 214);
    [self.view addSubview:bottomline];
    
    
    [self createComfirmcodeLabel];
}



/*
 *   确认条形码（核对有误请返回重拍）
 */
- (void)createComfirmcodeLabel{
    UILabel *comfirmL = [[UILabel alloc]initWithFrame:CGRectMake(10, barCodeView.bottom + 35 + 30, KSCREEWIDTH - 20, 20)];
    comfirmL.text = @"确认条形码（核对有误请返回重拍）";
    [self.view addSubview:comfirmL];
    //comfirmL.backgroundColor = [UIColor redColor];
    
    CGFloat labelH = 40.0f;
    CGFloat labelFont = 25.0f;
    CGFloat width =  [[self.qrcode substringToIndex:1]  boundingRectWithSize:CGSizeMake(KSCREEWIDTH - 20, labelH) options:NSStringDrawingUsesLineFragmentOrigin attributes:
   @{NSFontAttributeName: [UIFont systemFontOfSize:labelFont],} context:nil].size.width;
    NSDictionary *attrs = @{
                            NSFontAttributeName: [UIFont systemFontOfSize:labelFont],
                            NSKernAttributeName : [NSNumber numberWithDouble:(KSCREEWIDTH - 20 - width * self.qrcode.length) / (self.qrcode.length - 1)]
                            };
    NSAttributedString
    *as = [[NSAttributedString alloc] initWithString: self.qrcode
                                                attributes:attrs];

    
    UILabel *codeL = [[UILabel alloc]initWithFrame:CGRectMake(10, comfirmL.bottom + 10, KSCREEWIDTH - 20, labelH)];
    codeL.textAlignment = NSTextAlignmentLeft;
    codeL.adjustsFontSizeToFitWidth = YES;
    codeL.textColor = kColor;
    codeL.attributedText = as;
    [self.view addSubview:codeL];
}


/*
 *  下一步按钮
 */
- (void)createBottomButton{
    UIButton *bobutton = [self customButton:@"下一步"];
    bobutton.frame = CGRectMake(20, KSCREEHEGIHT - 64 - 60, KSCREEWIDTH - 40, 40);
    [self.view addSubview:bobutton];
}
- (void)customButtonAction:(UIButton *)button{

    BindComfirmPlateNumVC *patec = [[BindComfirmPlateNumVC alloc]init];
    patec.qrcode = self.qrcode;
    patec.isAddMoreCar = self.isAddMoreCar;
    [self.navigationController pushViewController:patec animated:YES];
}



#pragma mark - 格式化code
// 每隔4个字符空两格
- (NSString *)formatCode:(NSString *)code {
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    for (int i = 0, j = 0 ; i < [code length]; i++, j++) {
        [chars addObject:[NSNumber numberWithChar:[code characterAtIndex:i]]];
        if (j == 3) {
            j = -1;
            [chars addObject:[NSNumber numberWithChar:' ']];
            [chars addObject:[NSNumber numberWithChar:' ']];
        }
    }
    
    int length = (int)[chars count];
    char str[length];
    for (int i = 0; i < length; i++) {
        str[i] = [chars[i] charValue];
    }
    
    NSString *temp = [NSString stringWithUTF8String:str];
    return temp;
}

#pragma mark - 生成条形码
// 参考文档
// https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    CIImage *barcodeImage;
    NSData *data = [self.qrcode dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    
    /*
    CIQRCodeGenerator (iOS 7)
    CIAztecCodeGenerator (iOS 8)
    CICode128BarcodeGenerator (iOS 8)
    CIPDF417BarcodeGenerator (iOS 9)
     */
    
    //二维码
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    //[filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    
    barcodeImage = [filter outputImage];
    
    
    //计算比例 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}
@end
