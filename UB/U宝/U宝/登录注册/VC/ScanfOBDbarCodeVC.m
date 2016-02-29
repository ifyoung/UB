//
//  ScanfOBDbarCodeVC.m
//  赛格车圣
//
//  Created by 朱鹏的Mac on 15/8/19.
//  Copyright © 2015年 朱鹏的Mac. All rights reserved.
//

#import "ScanfOBDbarCodeVC.h"
#import "ScanfOBDbarCodeComfirmVC.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanfOBDbarCodeVC ()<AVCaptureMetadataOutputObjectsDelegate>{

    UIView *topV;
    UIView *bottV;
    UIView *leftV;
    UIView *righV;
    UILabel *bottomL;
    UIImageView *scanfRectView;
    UIImageView *lineImg;
}

@property(nonatomic,assign)BOOL isComplete;
@property(nonatomic,strong)AVCaptureSession *session;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *preview;

@end
@implementation ScanfOBDbarCodeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定OBD智能终端";
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    if (!_session) {
        
        _isComplete = NO;
        
        [self initSession];
    }
}

/*
 *  创建会话
 */
- (void)initSession{
    
    [MBProgressHUD showMessage:@"加载中..."];
    
    //耗时的操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Device
       AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

        // Input
        NSError *error;
       AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
  
        // Output
       AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //_output.rectOfInterest = CGRectMake(0.5 ,0.5 ,0.5,0.5 );
        //设置AVCaptureMetadataOutput  的rectOfInterest 的属性就可以了
        //这样设置就可以：CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
        
        
        // Session
        if(_session == nil)
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:input]){
            [_session addInput:input];
        }
        if ([_session canAddOutput:output]){
            [_session addOutput:output];
        }
        
        
        // 条码类型 AVMetadataObjectTypeQRCode
        NSArray *types = [NSArray arrayWithObjects:
         //AVMetadataObjectTypeQRCode,
         AVMetadataObjectTypeEAN13Code,
         AVMetadataObjectTypeEAN8Code,
         AVMetadataObjectTypeCode128Code,nil];
        
        
        
       if([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code] ||
          [output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]||
          [output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]//||
          
          //[output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]
          )
           
            output.metadataObjectTypes = types;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //更新界面
            if(_preview == nil)
            _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame =  CGRectMake(0, 0, KSCREEWIDTH, KSCREEHEGIHT - 64);//  self.view.bounds;
            _preview.backgroundColor = [UIColor redColor].CGColor;
            //[self.view.layer insertSublayer:self.preview atIndex:0];
            [self.view.layer addSublayer:_preview];
            
            [self createmaskSubViews];
            
            
            [MBProgressHUD hideHUD];
            
            // Start
            [_session startRunning];
        });
    });
}

/*
 *   AVCaptureMetadataOutputObjects  Delegate
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if(_isComplete) return;  //每次扫描可能进来多次
    
    NSString *stringValue = @"";
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }

    _isComplete = YES;
    
    
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    _session = nil;
    _preview = nil;
    [self removemaskSubViews];
    
    
      dispatch_async(dispatch_get_main_queue(), ^{
            if(stringValue && stringValue.length > 0){
            
               ScanfOBDbarCodeComfirmVC *codec = [[ScanfOBDbarCodeComfirmVC alloc]init];
               codec.qrcode = stringValue;
               codec.isAddMoreCar =  self.isAddMoreCar;
              [self.navigationController pushViewController:codec animated:YES];
            }
      });
}




/*
 *  创建mask
 */
- (void)createmaskSubViews{
    
    CGFloat kx = (KSCREEWIDTH - 200) / 2.0;
    CGFloat ky = 100;
    CGFloat kwidth = 200;
    UIColor *kkcplor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.7];
    
    if(topV == nil)
        topV = [UIView new];
    topV.frame = CGRectMake(0, 0, KSCREEWIDTH, ky);
    topV.backgroundColor = kkcplor;
    [self.view addSubview:topV];
    
    if(bottV == nil)
        bottV = [UIView new];
    bottV.frame = CGRectMake(0, ky + kwidth, KSCREEWIDTH, KSCREEHEGIHT - 64 - (ky + kwidth));
    bottV.backgroundColor = kkcplor;
    [self.view addSubview:bottV];
    
    if(leftV == nil)
        leftV = [UIView new];
    leftV.frame = CGRectMake(0, ky, kx, kwidth);
    leftV.backgroundColor = kkcplor;
    [self.view addSubview:leftV];
    
    if(righV == nil)
        righV = [UIView new];
    righV.frame = CGRectMake(KSCREEWIDTH - kx, ky, kx, kwidth);
    righV.backgroundColor = kkcplor;
    [self.view addSubview:righV];
    
    
    CGRect rect =  CGRectMake(kx, ky, kwidth, kwidth);
    if(scanfRectView == nil)
        scanfRectView = [[UIImageView alloc]initWithFrame:rect];
    scanfRectView.image = [UIImage imageNamed:@"临时扫码框"];
    [self.view addSubview:scanfRectView];
    
    CGRect  lineImgrect = CGRectMake(scanfRectView.left + 5, scanfRectView.top, scanfRectView.width - 10, 5);
    if(lineImg == nil)
        lineImg = [[UIImageView alloc]initWithFrame:lineImgrect];
    lineImg.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:lineImg];
    
    
    bottomL = [[UILabel alloc]initWithFrame:CGRectMake(20, scanfRectView.bottom + 20, KSCREEWIDTH - 40, 20)];
    bottomL.text = @"将二维码/条形码放入框内，即可自动扫描";
    bottomL.textAlignment = NSTextAlignmentCenter;
    bottomL.textColor = [UIColor colorWithWhite:.8 alpha:.8];
    bottomL.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:bottomL];
    //bottomL.backgroundColor = [UIColor redColor];
    
    lineImg.top = scanfRectView.top;
    [UIView animateWithDuration:2 delay:0.5 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat  animations:^{
        
        lineImg.bottom = scanfRectView.bottom;
    } completion:NULL];
}
- (void)removemaskSubViews{
    [topV removeFromSuperview];          topV = nil;
    [bottV removeFromSuperview];         bottV = nil;
    [leftV removeFromSuperview];         leftV = nil;
    [righV removeFromSuperview];         righV = nil;
    [bottomL removeFromSuperview];       bottomL = nil;
    [lineImg removeFromSuperview];       lineImg = nil;
    [scanfRectView removeFromSuperview]; scanfRectView = nil;
}

@end
