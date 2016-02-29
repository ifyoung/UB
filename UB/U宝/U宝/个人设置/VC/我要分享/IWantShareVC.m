//
//  IWantShareVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "IWantShareVC.h"
#import "IWantSharePopView.h"
//#import "SocialLoginHelper.h"

@interface IWantShareVC ()<IWsharedelegate>

@end

@implementation IWantShareVC

- (void)loadView{
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    scrollView.contentSize = CGSizeMake(KSCREEWIDTH,KSCREEHEGIHT - 64 + 1);
    scrollView.showsVerticalScrollIndicator = NO;
    self.view = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享车圣U宝";
    
    [self leftButtonItem];
    
    [self createSubViews];
    
    [self createQRCodeFromURL];
    
    [self createViewForFooter];
}



/*
 *   createSubViews
 */
- (void)createSubViews{

    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, KSCREEWIDTH - 40, 20)];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = kColor;
    topLabel.text = @"安全开车不任性,多挣保费好心情";
    [self.view addSubview:topLabel];
    
    
    NSString *bottomTitle = @"扫描二维码,即可下载车圣U宝,每天安全开车有收益！还等什么,赶快分享给小伙伴吧～";
    CGSize size = [bottomTitle sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(KSCREEWIDTH - 40, KSCREEHEGIHT)];
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 260, KSCREEWIDTH - 40, size.height)];
    bottomLabel.numberOfLines = 0;
    bottomLabel.text = bottomTitle;
    bottomLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:bottomLabel];
}


/**
 *   生成二维码
 *
 *  @return
 */
- (void)createQRCodeFromURL{

    UIImage *image = [self createQRForString:@"http://user.qzone.qq.com/705586988/4"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake((KSCREEWIDTH - 180) / 2.0, 60, 180, 180);
    [self.view addSubview:imageView];
}



#pragma mark - Utility methods
- (UIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *image = qrFilter.outputImage;
    
    
    // Render the CIImage into a CGImage
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * 2 * [[UIScreen mainScreen] scale], image.extent.size.width * 2*[[UIScreen mainScreen] scale]));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    // Need to set the image orientation correctly
    UIImage *flippedImage = [UIImage imageWithCGImage:[scaledImage CGImage]
                                                scale:scaledImage.scale
                                          orientation:UIImageOrientationDownMirrored];
    
    return flippedImage;

}




/**
 *   查询按钮
 *
 *  @return
 */
- (void)createViewForFooter{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 400;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.userInteractionEnabled  = YES;
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = kColor;
    [button setTitle:@"分享" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, KSCREEHEGIHT- 64 - 50, KSCREEWIDTH - 40, 40);
    [self.view addSubview:button];
}

/**
 *   弹出选择分享平台界面
 *
 *  @return
 */
- (void)shareAction{
    //[IWantSharePopView showShareViewDelegate:self];
}


/**
 *   点击一键分享到某个平台
 *
 *  @return
 */
- (void)didselectPlateform:(NSInteger)index{
    //[SocialLoginHelper shareToSelectPlateform:index vc:self];
}
@end
